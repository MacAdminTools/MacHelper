//
//  ScenarioManager.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

class ScenarioManager {
    
    static func loadScenarioData (path: String) -> Data? {
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            else {
                return nil
        }
        
        return data
    }
    
    static func decodeScenario (json: Data) -> Scenario? {
        
        let decoder = PropertyListDecoder()
        do {
            let scenario = try decoder.decode(Scenario.self, from: json)
            return scenario
        }catch{
            print("Error info: \(error)")
        }
        
        return nil
    }
    
    static func runScenario (scenario: Scenario, runningScenario: RunningScenario) {
        
        guard let initialScenes = ScenarioManager.getInitialElements(elements: scenario.scenes, runningElements: runningScenario.scenes, exitAnchors: runningScenario.exitAnchors) as? [Scene]
            else {return}
        
        if initialScenes.count == 0 && (runningScenario.scenes.filter{$0.status == .running}.count == 0) || runningScenario.status == .terminated {
            print("END SCENARIO: \(scenario.name)")
            runningScenario.status = .terminated
            NotificationCenter.default.post(name: .ElementTerminated, object: nil, userInfo: ["type": NotificationElement.scenario])
        }else{
            if runningScenario.status == .initial {print("START SCENARIO: \(scenario.name)")}
            runningScenario.status = .running
            initialScenes.forEach{ ScenarioManager.runScene(scenario: scenario, scene: $0, runningScenario: runningScenario)}
            ScenarioManager.saveRunningStatus(runningScenario: runningScenario)
        }
    }
    
    static func runScene (scenario: Scenario, scene: Scene, runningScenario: RunningScenario){
        guard let runningScene = runningScenario.scenes.filter({ (runningscene) -> Bool in runningscene.id == scene.id})[safe: 0],
            let initialNodes = ScenarioManager.getInitialElements(elements: scene.nodes, runningElements: runningScene.nodes, exitAnchors: runningScene.exitAnchors) as? [Node]
            else {return}
        
        if initialNodes.count == 0 && (runningScene.nodes.filter{$0.status == .running}.count == 0) || runningScene.status == .terminated {
            runningScene.status = .terminated
            ScenarioManager.saveRunningStatus(runningScenario: runningScenario)
            print("  END SCENE: \(scene.name)")
            NotificationCenter.default.post(name: .ElementTerminated, object: nil, userInfo: ["type": NotificationElement.scene, "scenario": scenario, "runningScenario": runningScenario])
        }else{
            if runningScene.status == .initial {print("  START SCENE: \(scene.name)")}
            runningScene.status = .running
            ScenarioManager.saveRunningStatus(runningScenario: runningScenario)
            initialNodes.forEach{ScenarioManager.runNode(scenario: scenario, scene: scene, node: $0, runningScene: runningScene, completion: {
                ScenarioManager.runScene(scenario: scenario, scene: scene, runningScenario: runningScenario)
            })}
        }
    }
    
    static func runNode (scenario: Scenario, scene: Scene, node: Node, runningScene: RunningScene, completion:@escaping ()->()){
        guard let runningNode = runningScene.nodes.filter({ (runningnode) -> Bool in runningnode.id == node.id})[safe: 0]
            else {return}
        runningNode.status = .running
        print("    START NODE: \(node.name)")
        ScenarioManager.testNodeLoop(triggers: node.triggers, runningNode: runningNode) { (trigger) in
            ScenarioManager.executeTrigger(blocks: trigger.actionBlocks, completion: {
                runningNode.status = .terminated
                print("    END NODE: \(node.name)")
                completion()
            })
        }
    }
    
    static func testNodeLoop (triggers: [Trigger], runningNode: RunningNode, completion: @escaping (Trigger)->()){
        ScenarioManager.testNode(triggers: triggers, runningNode: runningNode) { (trigger) in
            if let trigg = trigger {
                completion(trigg)
            }else{
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                    ScenarioManager.testNodeLoop(triggers: triggers, runningNode: runningNode, completion: completion)
                })
            }
        }
    }
    
    static func testNode (triggers: [Trigger], runningNode: RunningNode, completion: @escaping (Trigger?)->()) {
        let serialQueue = DispatchQueue(label: "serialQueue\(runningNode.id)")
        let group = DispatchGroup()
        
        // a revoir: foreach, Trigger equatable, triggers.first.last
        for i in 0...triggers.count-1 {
            serialQueue.async {
                if i != 0 {group.wait()}
                group.enter()
                if !runningNode.test{
                    ScenarioManager.testTrigger(trigger: triggers[i], completion: { (res, trigger) in
                        //print("trigger test ended with res: \(res)")
                        runningNode.test = res
                        if res {
                            completion(trigger)
                        }else{
                            if i == triggers.count-1 {
                                completion(nil)
                            }
                        }
                        
                        group.leave()
                    })
                }
            }
        }
    }
    
    static func executeTrigger (blocks: [ActionBlock], completion:@escaping ()->()){
        let actionGroup = DispatchGroup()
        
        for actionBlock in blocks {
            actionGroup.enter()
            DispatchQueue.global(qos: .default).async {
                runActionBlock(actionBlock: actionBlock, completion: { (res) in
                    actionGroup.leave()
                })
            }
        }
        
        actionGroup.notify(queue: .main) {
            completion()
        }
    }
    
    static func runActionBlock(actionBlock: ActionBlock, completion: @escaping (Int) -> Void) {
        actionBlock.action.launch { code in
            if !actionBlock.actionBlocks.isEmpty {
                executeTrigger(blocks: actionBlock.actionBlocks.filter{ $0.parentCode == code || $0.parentCode == -1 }, completion: {
                    completion(code)
                })
            } else {
                completion(code)
            }
        }
    }
    
    static func testTrigger (trigger: Trigger, completion: @escaping (Bool, Trigger) -> Void) {
        
        let conditionGroup = DispatchGroup()
        var test = true
        
        for condition in trigger.conditions {
            conditionGroup.enter()
            condition.test(completion: { res in
                if !res {
                    test = false
                }
                conditionGroup.leave()
            })
        }
        
        conditionGroup.notify(queue: DispatchQueue.main) {
            completion(test, trigger)
        }
    }
    
    static func getInitialElements (elements:[SceneAndNode], runningElements: [RunningSceneAndNode], exitAnchors: [String]) -> [SceneAndNode] {
        
        let noAnchorScene = elements.filter{$0.startAnchors.isEmpty}
        let anchorExistScene = elements.filter{!$0.startAnchors.filter{exitAnchors.contains($0)}.isEmpty}
        let initialStatusRunningSceneIds = ScenarioManager.getInitialStatusIds(runningElements: runningElements)
        let initialScenes = (noAnchorScene + anchorExistScene).filter{initialStatusRunningSceneIds.contains($0.id)}
        
        return initialScenes
    }
    
    static func getInitialStatusIds (runningElements: [RunningSceneAndNode]) -> [String] {
        return runningElements.filter{$0.status == .initial}.map{$0.id}
    }
    
    static func createRunningScenario (scenario: Scenario, path: String) -> RunningScenario {
        let scenes = scenario.scenes.map { (scene) -> RunningScene in
            let nodes = scene.nodes.map({ (node) -> RunningNode in
                return RunningNode(id: node.id, name: node.name, status: .initial)
            })
            return RunningScene(id: scene.id, name: scene.name, status: .initial, nodes: nodes)
        }
        return RunningScenario(id: scenario.id, name: scenario.name, path: path, status: .initial, scenes: scenes)
    }
    
    static func saveRunningStatus (runningScenario: RunningScenario) {
        guard let jsonData = try? JSONEncoder().encode(runningScenario) else
        {
            print("cant encode")
            return
        }
        UserDefaults.standard.set(jsonData, forKey: runningScenario.id)
    }
    
    static func loadRunningStatus(scenarioId: String) -> RunningScenario? {
        guard let runningScenarioData = ScenarioManager.getRunningScenarioFromDefaults(scenarioId: scenarioId)
            else{
                return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let runningScenario = try decoder.decode(RunningScenario.self, from: runningScenarioData)
            return runningScenario
        }catch{
            print("Error info: \(error)")
            return nil
        }
    }
    
    static func getRunningScenarioFromDefaults (scenarioId: String) -> Data? {
        guard let scenarioData = UserDefaults.standard.data(forKey: scenarioId)
            else{
                print("scenario not available in defaults")
                return nil
        }
        return scenarioData
    }
    
    static func getSearchElement (id: String, searchElements: [SearchElement]) -> SearchElement? {
        guard let element = searchElements.filter({ (element) -> Bool in
            element.id == id
        })[safe: 0]
            else{
                return nil
        }
        return element
    }
    
    static func generateRunningScenario(scenario: Scenario, path: String = "") -> RunningScenario {
        if let runningScenario = ScenarioManager.loadRunningStatus(scenarioId: scenario.id) {
            runningScenario.scenes.filter{$0.status == .running}.forEach { $0.nodes.forEach{ $0.status = .initial}}
            print("RunningScenario loaded from Defaults")
            return runningScenario
        }else{
            let runningScenario = ScenarioManager.createRunningScenario(scenario: scenario, path: path)
            ScenarioManager.saveRunningStatus(runningScenario: runningScenario)
            print("RunningScenario created and saved")
            return runningScenario
        }
    }
    
    static func loadScenario (path: String) -> Scenario? {
        guard let data = ScenarioManager.loadScenarioData(path: path),
            let scenario = ScenarioManager.decodeScenario(json: data)
            else {
                return nil
        }
        
        let runningScenario = ScenarioManager.generateRunningScenario(scenario: scenario, path: path)
        ScenarioManager.saveRunningStatus(runningScenario: runningScenario)
        
        return scenario
    }
    
}

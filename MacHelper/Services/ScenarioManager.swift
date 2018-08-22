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
        
        guard let initialScenes = ScenarioManager.getInitialElements(elements: scenario.scenes, runningElements: runningScenario.scenes) as? [Scene]
            else {return}
        
        runningScenario.status = .running
        initialScenes.forEach{ ScenarioManager.runScene(scenario: scenario, scene: $0, runningScenario: runningScenario)}
        ScenarioManager.saveRunningStatus(runningScenario: runningScenario)
    }
    
    static func runScene (scenario: Scenario, scene: Scene, runningScenario: RunningScenario){
        guard let runningScene = runningScenario.scenes.filter({ (runningscene) -> Bool in runningscene.id == scene.id})[safe: 0],
            let initialNodes = ScenarioManager.getInitialElements(elements: scene.nodes, runningElements: runningScene.nodes) as? [Node]
            else {return}
        runningScene.status = .running
        initialNodes.forEach{ScenarioManager.runNode(scenario: scenario, scene: scene, node: $0, runningScene: runningScene)}
    }
    
    static func runNode (scenario: Scenario, scene: Scene, node: Node, runningScene: RunningScene){
        guard let runningNode = runningScene.nodes.filter({ (runningnode) -> Bool in runningnode.id == node.id})[safe: 0]
            else {return}
        runningNode.status = .running
        
        ScenarioManager.testNodeLoop(triggers: node.triggers, runningNode: runningNode) { (trigger) in
            
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
                        print("trigger test ended with res: \(res)")
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
    
    static func executeTrigger (trigger: Trigger, completion:()->()){
        
    }
    
    /*static func runtriggers(node: Node, nodeTerminated: @escaping () -> Void) {
        node.triggers.forEach {$0.execute(onTriggerSuccess: {
            LogManager.shared.log(line: self.name+" : success trigger")
            self.status = .executing
        }, onActionsSuccess: {
            LogManager.shared.log(line: self.name+" : success action")
            self.status = .over
            nodeTerminated()
        })
        }
    }
    
    static func execute(onTriggerSuccess: (() -> Void)?, onActionsSuccess: (() -> Void)?) {
        
        self.test { res in
            if res {
                if let trig = onTriggerSuccess {
                    trig()
                }
                Trigger.launchActionBlocks(actionBlocks: self.actionBlocks, onActionsSuccess: onActionsSuccess)
            }
        }
    }*/
    
    /*static func testTrigger (trigger: Trigger, completion:@escaping (Bool) -> Void) {
        ScenarioManager.testConditions(conditions: trigger.conditions, completion: { res in
            if res {
                completion(res)
            } else {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
                    ScenarioManager.testTrigger(trigger: trigger, completion: completion)
                    timer.invalidate()
                })
            }
        })
    }*/
    
    /*static func launchActionBlocks (actionBlocks: [ActionBlock], onActionsSuccess: (() -> Void)?) {
        
        let actionGroup = DispatchGroup()
        
        for actionBlock in actionBlocks {
            actionGroup.enter()
            DispatchQueue.global(qos: .default).async {
                actionBlock.run(completion: { _ in
                    actionGroup.leave()
                })
            }
        }
        
        actionGroup.notify(queue: .main) {
            if let clos = onActionsSuccess {
                clos()
            }
        }
    }*/
    
    static func testTrigger (trigger: Trigger, completion: @escaping (Bool, Trigger) -> Void) {
        
        print("start test trigger")
        let conditionGroup = DispatchGroup()
        var test = true
        
        for condition in trigger.conditions {
            conditionGroup.enter()
            print("test condition: \(condition.name)")
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
    
    static func getInitialElements (elements:[SceneAndNode], runningElements: [RunningSceneAndNode]) -> [SceneAndNode] {
        
        let noAnchorScene = elements.filter{$0.startAnchors.isEmpty}
        let runningSceneExitAnchor = ScenarioManager.getExitAnchors(runningElements: runningElements)
        let anchorExistScene = elements.filter{!$0.startAnchors.filter{runningSceneExitAnchor.contains($0)}.isEmpty}
        let initialStatusRunningSceneIds = ScenarioManager.getInitialStatusIds(runningElements: runningElements)
        let initialScenes = (noAnchorScene + anchorExistScene).filter{initialStatusRunningSceneIds.contains($0.id)}
        
        return initialScenes
    }
    
    static func getExitAnchors (runningElements: [RunningSceneAndNode]) -> [String] {
        return runningElements.reduce([String]()) { (res, element) -> [String] in
            res + element.exitAnchors
        }
    }
    
    static func getInitialStatusIds (runningElements: [RunningSceneAndNode]) -> [String] {
        return runningElements.filter{$0.status == .initial}.map{$0.id}
    }
    
    static func createRunningScenario (scenario: Scenario, path: String) -> RunningScenario {
        let scenes = scenario.scenes.map { (scene) -> RunningScene in
            let nodes = scene.nodes.map({ (node) -> RunningNode in
                return RunningNode(id: node.id, name: node.name, status: .initial, exitAnchors: [String]())
            })
            return RunningScene(id: scene.id, name: scene.name, status: .initial, exitAnchors: [String](), nodes: nodes)
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
    
    static func printStatus(id: String) {
        guard let data = ScenarioManager.getRunningScenarioFromDefaults(scenarioId: id)
            else{return}
        print(String(data: data, encoding: .utf8) ?? "Scenario data not decodable")
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

//
//  ScenarioManager.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

class ScenarioManager {
    
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
    
    /*static func encodeScenario (scenario: Scenario) -> String? {
        
        guard let jsonData = try? JSONEncoder().encode(scenario) else
        {
            print("cant encode")
            return nil
        }
        
        return String(data: jsonData, encoding: .utf8)
    }*/
    
    static func runScenario (scenario: Scenario, runningScenario: RunningScenario) {
        let initialScenes = ScenarioManager.getInitialScenes(scenario: scenario, runningScenario: runningScenario)
        ScenarioManager.runScenes(scenario: scenario, scenes: initialScenes)
    }
    
    static func runScenes (scenario: Scenario, scenes: [Scene]) {
        
    }
    
    static func getInitialScenes (scenario: Scenario, runningScenario: RunningScenario) -> [Scene] {
        
        let noAnchorScene = scenario.scenes.filter{$0.anchors.isEmpty}
        let runningSceneAnchor = ScenarioManager.getSceneAnchors(runningScenario: runningScenario)
        let anchorExistScene = scenario.scenes.filter{!$0.anchors.filter{runningSceneAnchor.contains($0)}.isEmpty}
        let initialStatusRunningSceneIds = ScenarioManager.getInitialStatusSceneIds(runningScenario: runningScenario)
        let initialScenes = (noAnchorScene + anchorExistScene).filter{initialStatusRunningSceneIds.contains($0.id)}
        
        return initialScenes
    }
    
    static func getSceneAnchors (runningScenario: RunningScenario) -> [String] {
        return runningScenario.scenes.reduce([String]()) { (res, scene) -> [String] in
            res + scene.exitAnchors
        }
    }
    
    static func getInitialStatusSceneIds (runningScenario: RunningScenario) -> [String] {
        return runningScenario.scenes.filter{$0.status == .initial}.map{$0.sceneId}
    }
}

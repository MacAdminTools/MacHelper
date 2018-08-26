//
//  MainController.swift
//  MacHelper
//
//  Created by mathieu on 15.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

class MainController {
    
    static let shared = MainController()
    
    var runningScenarios = [RunningScenario]()
    var scenarios = [Scenario]()
    
    init() {
        NotificationCenter.default.addObserver(forName: .ElementTerminated, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo,
            let type = userInfo["type"] as? NotificationElement
                else{
                    print("Error: Notification type not recognized")
                    return
            }
            switch type {
            case .scenario:
                if (self.runningScenarios.filter{$0.status == .running}.count == 0){
                    NotificationCenter.default.post(name: .HelperShouldQuit, object: nil)
                }
            case .scene:
                guard let scenario = userInfo["scenario"] as? Scenario,
                let runningScenario = userInfo["runningScenario"] as? RunningScenario
                    else{
                        return
                }
                ScenarioManager.runScenario(scenario: scenario, runningScenario: runningScenario)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .AddAnchor, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo,
                let type = userInfo["type"] as? NotificationElement
                else{
                    return
            }
            switch type {
            case .scenario:
                guard let scenarioId = userInfo["scenarioId"] as? String,
                    let anchor = userInfo["anchor"] as? String,
                    let runningScenario = ScenarioManager.getSearchElement(id: scenarioId, searchElements: self.runningScenarios) as? RunningScenario
                    else{
                        return
                }
                runningScenario.exitAnchors.append(anchor)
            case .scene:
                guard let scenarioId = userInfo["scenarioId"] as? String,
                    let sceneId = userInfo["sceneId"] as? String,
                    let anchor = userInfo["anchor"] as? String,
                    let runningScenario = ScenarioManager.getSearchElement(id: scenarioId, searchElements: self.runningScenarios) as? RunningScenario,
                    let runningScene = ScenarioManager.getSearchElement(id: sceneId, searchElements: runningScenario.scenes) as? RunningScene
                    else{
                        return
                }
                
                runningScene.exitAnchors.append(anchor)
            }
        }
    }
    
    func play (path: String) {
        guard let scenario = ScenarioManager.loadScenario(path: path)
            else{
            return
        }
        
        NotificationsManager.shared.run()
        self.scenarios.append(scenario)
        let runningScenario = ScenarioManager.generateRunningScenario(scenario: scenario, path: path)
        self.runningScenarios.append(runningScenario)
        ScenarioManager.runScenario(scenario: scenario, runningScenario: runningScenario)
        
    }
    
    func play () {
        NotificationsManager.shared.run()
        ScenarioManager.runAllScenario(scenarios: self.scenarios, runningScenarios: self.runningScenarios)
        
    }
    
}

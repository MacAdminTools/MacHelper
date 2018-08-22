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
    
    static var runningScenarios = [RunningScenario]()
    static var scenarios = [Scenario]()
    
    static func play (path: String) {
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
    
}

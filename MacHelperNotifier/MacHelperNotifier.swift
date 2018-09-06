//
//  MacHelperNotifier.swift
//  MacHelperNotifier
//
//  Created by mathieu on 22.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

class MacHelperNotifier {
        
    static func printStatus(id: String) {
        guard let data = MacHelperNotifier.getRunningScenarioFromDefaults(scenarioId: id)
            else{return}
        print(String(data: data, encoding: .utf8) ?? "Scenario data not decodable")
    }
    
    static func getRunningScenarioFromDefaults (scenarioId: String) -> Data? {
        guard let defaults = UserDefaults.init(suiteName: "MacHelper"), let scenarioData = defaults.data(forKey: scenarioId)
            else{
                print("scenario not available in defaults")
                return nil
        }
        return scenarioData
    }
}

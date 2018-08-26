//
//  AddAnchor.swift
//  MacHelper
//
//  Created by mathieu on 24.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct AddAnchor: Action {
    
    let name: String
    let scenarioId: String
    let sceneId: String
    
    func launch(completion: @escaping (Int) -> Void){
        if sceneId == "" {
            NotificationCenter.default.post(name: .AddAnchor, object: nil, userInfo: ["type": NotificationElement.scenario, "scenarioId": scenarioId, "anchor": name])
            print("      ACTION: Add anchor \(name) to scenario \(scenarioId)")
        }else{
            NotificationCenter.default.post(name: .AddAnchor, object: nil, userInfo: ["type": NotificationElement.scene, "scenarioId": scenarioId, "sceneId": sceneId, "anchor": name])
            print("      ACTION: Add anchor \(name) to scene \(sceneId)")
        }
        completion(0)
    }
}

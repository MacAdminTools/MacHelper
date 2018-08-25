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
    
    func launch(completion: ((Int) -> Void)){
        if sceneId == "" {
            NotificationCenter.default.post(name: .AddAnchor, object: nil, userInfo: ["type": NotificationElement.scenario, "scenarioId": scenarioId, "anchor": name])
        }else{
            NotificationCenter.default.post(name: .AddAnchor, object: nil, userInfo: ["type": NotificationElement.scene, "scenarioId": scenarioId, "sceneId": sceneId, "anchor": name])
        }
        completion(0)
    }
}

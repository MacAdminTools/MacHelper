//
//  AddAnchor.swift
//  MacHelper
//
//  Created by mathieu on 24.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct AddAnchor: Action {
    
    let id: String
    let name: String
    let scenarioId: String
    let sceneId: String
    let anchor: String
    
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
    
    private enum CodingKeys: String, CodingKey {
        case id, name, scenarioId, sceneId, anchor
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        scenarioId = try values.decode(String.self, forKey: .scenarioId)
        sceneId = try values.decode(String.self, forKey: .sceneId)
        anchor = try values.decode(String.self, forKey: .anchor)
    }
}

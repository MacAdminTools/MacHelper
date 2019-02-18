//
//  Reset.swift
//  MacHelper
//
//  Created by mathieu on 27.01.19.
//  Copyright © 2019 altab. All rights reserved.
//

import Foundation

struct Reset: Action {
    
    let id: String
    let name: String
    let scenarioId: String
    let sceneId: String
    let nodeId: String
    
    func launch(completion: @escaping (Int) -> Void){
        if nodeId == "" {
            NotificationCenter.default.post(name: .ResetElement, object: nil, userInfo: ["type": NotificationElement.scenario, "scenarioId": scenarioId, "sceneId": sceneId])
            print("      ACTION: ResetElement scene : \(sceneId)")
        }else{
            NotificationCenter.default.post(name: .ResetElement, object: nil, userInfo: ["type": NotificationElement.scene, "scenarioId": scenarioId, "sceneId": sceneId, "nodeId": nodeId])
            print("      ACTION: ResetElement node : \(nodeId)")
        }
        completion(0)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, scenarioId, sceneId, nodeId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        scenarioId = try values.decode(String.self, forKey: .scenarioId)
        sceneId = try values.decode(String.self, forKey: .sceneId)
        nodeId = try values.decode(String.self, forKey: .nodeId)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
}

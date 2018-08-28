//
//  ResetElement.swift
//  MacHelper
//
//  Created by mathieu on 26.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct ResetElement: Action {
    
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
        case scenarioId, sceneId, nodeId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        scenarioId = try values.decode(String.self, forKey: .scenarioId)
        sceneId = try values.decode(String.self, forKey: .sceneId)
        nodeId = try values.decode(String.self, forKey: .nodeId)
    }
}

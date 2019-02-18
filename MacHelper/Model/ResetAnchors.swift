//
//  ResetAnchors.swift
//  MacHelper
//
//  Created by mathieu on 27.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct ResetAnchors: Action {
    
    let scenarioId: String
    let sceneId: String
    let anchors: [String]
    
    func launch(completion: @escaping (Int) -> Void){
        usleep(100000)
        if sceneId == "" {
            NotificationCenter.default.post(name: .ResetAnchors, object: nil, userInfo: ["type": NotificationElement.scenario, "scenarioId": scenarioId, "anchors": anchors])
            print("      ACTION: ResetAnchors \(anchors)")
        }else{
            NotificationCenter.default.post(name: .ResetAnchors, object: nil, userInfo: ["type": NotificationElement.scene, "scenarioId": scenarioId, "sceneId": sceneId, "anchors": anchors])
            print("      ACTION: ResetAnchors \(anchors)")
        }
        completion(0)
    }
    
    private enum CodingKeys: String, CodingKey {
        case scenarioId, sceneId, anchors
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        scenarioId = try values.decode(String.self, forKey: .scenarioId)
        sceneId = try values.decode(String.self, forKey: .sceneId)
        anchors = try values.decode([String].self, forKey: .anchors)
    }
}

//
//  ActionBlock.swift
//  MacHelper
//
//  Created by mathieu on 14.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct ActionBlock: Decodable {
    
    let id: String
    let action: Action
    let actionBlocks: [ActionBlock]
    let parentCode: Int
    
    enum CodingKeys: String, CodingKey {
        case action, actionBlocks, parentCode, id
    }
    
    enum ActionTypes: String, Decodable {
        case script, notification, addAnchor, reset
    }
    
    enum ActionTypeKey: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeContainer = try container.nestedContainer(keyedBy: ActionTypeKey.self, forKey: CodingKeys.action)
        let type = try typeContainer.decode(ActionTypes.self, forKey: ActionTypeKey.type)
        
        switch type {
        case .script:
            action = try container.decode(Script.self, forKey: .action)
        case .notification:
            action = try container.decode(AppNotification.self, forKey: .action)
        case .addAnchor:
            action = try container.decode(AddAnchor.self, forKey: .action)
        case .reset:
            action = try container.decode(Reset.self, forKey: .action)
        }
        id = try container.decode(String.self, forKey: .id)
        actionBlocks = try container.decode([ActionBlock].self, forKey: .actionBlocks)
        parentCode = try container.decode(Int.self, forKey: .parentCode)        
    }
    
}

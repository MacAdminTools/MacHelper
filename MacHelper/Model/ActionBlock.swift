//
//  ActionBlock.swift
//  MacHelper
//
//  Created by mathieu on 14.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct ActionBlock: Decodable {
    
    let action: Action
    let actionBlocks: [ActionBlock]
    let parentCode: Int
    
    enum CodingKeys: String, CodingKey {
        case action, actionBlocks, parentCode
    }
    
    enum ActionTypes: String, Decodable {
        case script = "script"
        case notification = "notification"
        case addAnchor = "addAnchor"
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
        }
        
        actionBlocks = try container.decode([ActionBlock].self, forKey: .actionBlocks)
        parentCode = try container.decode(Int.self, forKey: .parentCode)
        //print(self.action)
        
    }
    
}

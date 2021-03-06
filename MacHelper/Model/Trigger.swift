//
//  Trigger.swift
//  MacHelper
//
//  Created by mathieu on 13.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct Trigger: Decodable {
    
    let id: String
    let name: String
    var conditions: [Condition]
    var actionBlocks: [ActionBlock]
    
    enum CodingKeys: CodingKey {
        case id, name, conditions, actionBlocks
    }
    
    enum ConditionTypeKey: CodingKey {
        case type
    }
    
    enum ConditionTypes: String, Decodable {
        case script, signal, scriptTemplate
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conditions = try Trigger.decodeConditions(container: container)
        actionBlocks = try container.decode([ActionBlock].self, forKey: .actionBlocks)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
    }
    
    static func decodeConditions(container: KeyedDecodingContainer<CodingKeys>) throws -> [Condition]{
        var conditionsContainer = try container.nestedUnkeyedContainer(forKey: CodingKeys.conditions)
        var conditions = [Condition]()
        var conditionsArray = conditionsContainer
        
        while(!conditionsContainer.isAtEnd)
        {
            let cond = try conditionsContainer.nestedContainer(keyedBy: ConditionTypeKey.self)
            let type = try cond.decode(ConditionTypes.self, forKey: ConditionTypeKey.type)
            switch type {
            case .script:
                conditions.append(try conditionsArray.decode(Script.self))
            case .signal:
                conditions.append(try conditionsArray.decode(Signal.self))
            case .scriptTemplate:
                conditions.append(try conditionsArray.decode(ScriptTemplate.self))
            }
        }
        
        return conditions
    }
    
}

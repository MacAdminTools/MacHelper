//
//  Trigger.swift
//  MacHelper
//
//  Created by mathieu on 13.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct Trigger: Decodable {
    
    var conditions: [Condition]
    var actionBlocks: [ActionBlock]
    
    enum CodingKeys: CodingKey {
        case conditions, actionBlocks
    }
    
    enum ConditionTypeKey: CodingKey {
        case type
    }
    
    enum ConditionTypes: String, Decodable {
        case script = "script"
        case signal = "signal"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conditions = try Trigger.decodeConditions(container: container)
        actionBlocks = try container.decode([ActionBlock].self, forKey: .actionBlocks)
        
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
            }
        }
        
        return conditions
    }
    
}

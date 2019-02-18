//
//  Node.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct Node: Codable, SceneAndNode, SearchElement {
    
    let id: String
    let name: String
    var triggers: [Trigger]
    let startAnchors: [String]
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, nodes, name, startAnchors
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(String.self, forKey: .id)
        triggers = try values.decode([Trigger].self, forKey: .nodes)
        startAnchors = try values.decode([String].self, forKey: .startAnchors)
    }
}

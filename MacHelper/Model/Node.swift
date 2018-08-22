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
    var triggers: [Trigger]
    let name: String
    let startAnchors: [String]
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
    }
    
}

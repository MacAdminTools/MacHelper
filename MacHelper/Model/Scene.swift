//
//  Scene.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct Scene: Codable {
    
    let id: String
    let name: String
    let anchors: [String]
    var nodes: [Node]
    
}

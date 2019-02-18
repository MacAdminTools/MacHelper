//
//  Scene.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

protocol SceneAndNode {
    var id: String { get }
    var name: String { get }
    var startAnchors: [String] { get }
}

protocol RunningSceneAndNode {
    var id: String { get }
    var name: String { get }
    var status: RunningStatus { get }
}

struct Scene: Codable, SceneAndNode, SearchElement {
    
    let id: String
    let name: String
    let startAnchors: [String]
    var nodes: [Node]
    
}

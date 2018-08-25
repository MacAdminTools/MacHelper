//
//  Scenario.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct Scenario: Decodable, SearchElement {
    let id: String
    let name: String
    let version: String
    var scenes = [Scene]()
}

protocol SearchElement {
    var id: String { get }
}

class RunningScenario: Codable, SearchElement {
    let id: String
    let name: String
    let path: String
    var exitAnchors = [String]()
    var status: RunningScenarioStatus
    var scenes: [RunningScene]
    
    init(id: String, name: String, path: String, status: RunningScenarioStatus, scenes: [RunningScene]) {
        self.id = id
        self.name = name
        self.path = path
        self.status = status
        self.scenes = scenes
    }
}

class RunningScene: Codable, RunningSceneAndNode, SearchElement {
    let id: String
    let name: String
    var status: RunningStatus
    var exitAnchors = [String]()
    var nodes: [RunningNode]
    
    init(id: String, name: String, status: RunningStatus, nodes: [RunningNode]) {
        self.id = id
        self.name = name
        self.status = status
        self.nodes = nodes
    }
}

class RunningNode: Codable, RunningSceneAndNode, SearchElement {
    let id: String
    let name: String
    var status: RunningStatus
    var test = false
    
    init(id: String, name: String, status: RunningStatus) {
        self.id = id
        self.name = name
        self.status = status
    }
}

enum RunningStatus: String, Codable {
    case initial, running, terminated
}

enum RunningScenarioStatus: String, Codable {
    case initial, pause, running, terminated
}

enum NotificationElement {
    case scenario, scene
}

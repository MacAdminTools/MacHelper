//
//  Scenario.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct Scenario: Decodable {
    
    let id: String
    let name: String
    let path: String
    let version: String
    let runAtLoad: Bool
    var scenes = [Scene]()

}

struct RunningScenario: Codable {
    let scenarioId: String
    let name: String
    var scenes: [RunningScene]
}

struct RunningScene: Codable {
    let sceneId: String
    let name: String
    var status: RunningStatus
    var exitAnchors: [String]
    var nodes: [RunningNode]
}

struct RunningNode: Codable {
    let nodeId: String
    let name: String
    var status: RunningStatus
    var exitAnchors: [String]
}

enum RunningStatus: String, Codable {
    case initial, running, terminated
}

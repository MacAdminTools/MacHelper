//
//  Script.swift
//  MacHelper
//
//  Created by mathieu on 14.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct Script: Condition, Action {
    
    let name: String
    //let language: ScriptLanguage
    let script: String
    //let user: UserType
    //let scriptType: ScriptType
    
    func test(completion: @escaping (Bool) -> Void) {
        completion(false)
    }
    
    func launch(completion: ((Int) -> Void)) {
        completion(0)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case script
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        script = try values.decode(String.self, forKey: .script)
    }
    
}

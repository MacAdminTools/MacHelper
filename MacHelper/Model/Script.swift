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
    let language: ScriptLanguage
    let script: String
    let user: UserType
    let scriptType: ScriptType
    
    func test(completion: @escaping (Bool) -> Void) {
        ScriptManager.test(script: self.script, lang: self.language, type: self.scriptType, user: self.user, out: { out in
            if out != "" {
                //LogManager.shared.log(line: "condition : \(self.title)\nOut: \(out)", logType: .events)
            }
        }, err: { err in
            if err != "" {
                //LogManager.shared.log(line: "condition : \(self.title)\nError: \(err)", logType: .events)
            }
        }, completion: { res in
            //LogManager.shared.log(line: "condition : \(self.title) \(res ? "✓":"✗")", logType: .events)
            completion(res)
        })
    }
    
    func launch(completion: @escaping ((Int) -> Void)) {
        ScriptManager.run(script: self.script, lang: self.language, out: { out in
            if out != "" {
                print("      ACTION: \(self.name), out: \(out)")
                //LogManager.shared.log(line: "action : \(self.title)\nOut: \(out)")
            }
        }, err: { err in
            if err != "" {
                print("      ACTION: \(self.name), error: \(err)")
                //LogManager.shared.log(line: "action : \(self.title)\nError: \(err)")
            }
        }, completion: { code in
            //LogManager.shared.log(line: "action : \(self.title) \(code == 0 ? "✓":"✗")")
            print("      ACTION: \(self.name), completion: \(code)")
            completion(code)
        })
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, script, language, user, scriptType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        script = try values.decode(String.self, forKey: .script)
        language = try values.decode(ScriptLanguage.self, forKey: .language)
        user = try values.decode(UserType.self, forKey: .user)
        scriptType = try values.decode(ScriptType.self, forKey: .scriptType)
    }
    
}

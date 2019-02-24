//
//  ScriptManager.swift
//  MacHelper
//
//  Created by mathieu on 25.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

enum ScriptLanguage: String, Decodable {
    case bash, python, applescript
}

enum UserType: String, Decodable {
    case root, user
}

struct ScriptManager {
    
    static var username: String?
    
    static func test (script: String, lang: ScriptLanguage, user: UserType = .root,
                      out: @escaping (String) -> Void, err: @escaping (String) -> Void, completion: @escaping (Bool) -> Void) {
        
        var args = ["-c"]
        var command = "/bin/bash"
        
        switch lang {
        case .bash:
            args.append(script)
        case .python:
            
            if user == .root {
                command = "/usr/bin/python"
                args.append(script)
            } else {
                if let username = self.username {
                    args = ["-u", username, "python", "-c", script]
                    command = "/usr/bin/sudo"
                    //LogManager.shared.log(line: "test python : \(args.description)\n\(command)")
                } else {
                    //LogManager.shared.log(line: "username not initiated while trying to use it")
                }
            }
        case .applescript:
            command = "/usr/bin/osascript"
            args = ["-e", script]
        }
        
        //print(args)
        
        ScriptManager.runTask(command: command, arguments: args, outCompletion: { outStr in
            out(outStr)
        }, errCompletion: { errStr in
            err(errStr)
        }, codeCompletion: { code in
            let res = code == 0 ? true : false
            completion(res)
        })
        
    }
    
    static func run (script: String, lang: ScriptLanguage, out: @escaping (String) -> Void, err: @escaping (String) -> Void, completion: @escaping (Int) -> Void) {
        
        let argument = ["-c", script]
        let command = "/bin/bash"
        
        ScriptManager.runTask(command: command, arguments: argument, outCompletion: { outStr in
            out(outStr)
        }, errCompletion: { errStr in
            err(errStr)
        }, codeCompletion: { code in
            completion(code)
        })
    }
    
    static private func runTask(command: String, arguments: [String], outCompletion: ((String) -> Void)?, errCompletion: ((String) -> Void)?, codeCompletion: ((Int) -> Void)?) {
        let task: Process = Process()
        task.launchPath = command
        task.arguments = arguments
        
        let stdout = Pipe()
        let stderr = Pipe()
        
        task.standardOutput = stdout
        task.standardError = stderr
        
        if #available(OSX 10.13, *) {
            do {
                try task.run()
            } catch {
                
            }
        } else {
            task.launch()
        }
        
        task.waitUntilExit()
        
        if let out = outCompletion {
            let data = stdout.fileHandleForReading.readDataToEndOfFile()
            if let string = String(data: data, encoding: .utf8) {
                out(string)
            }
        }
        
        if let err = errCompletion {
            let data = stderr.fileHandleForReading.readDataToEndOfFile()
            if let string = String(data: data, encoding: .utf8) {
                if !string.isEmpty {
                    err(string)
                }
            }
        }
        
        if let code = codeCompletion {
            //code(NSNumber(value: task.terminationStatus))
            code(Int(task.terminationStatus))
        }
    }
    
    static func initUsername(completion: @escaping ((Int) -> Void)) {
        let script = """
                    from SystemConfiguration import SCDynamicStoreCopyConsoleUser;
                    import sys;
                    username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0];
                    username = [username,\"\"][username in [u\"loginwindow\", None, u\"\"]];
                    sys.stdout.write(username);
                    """
        let arguments = ["-c", script]
        ScriptManager.runTask(command: "/usr/bin/python", arguments: arguments, outCompletion: { str in
            if str != "" {
                //LogManager.shared.log(line: "username initiation success: \(str)")
                self.username = str
            }
        }, errCompletion: { err in
            //LogManager.shared.log(line: "username initiation failed: \(err)")
        }, codeCompletion: { num in
            completion(num)
        })
    }
    
}

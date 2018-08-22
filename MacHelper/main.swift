//
//  main.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

if CommandLine.arguments.count > 1 {
    
    let command = CommandLine.arguments[1]
    
    if command == "-load" {
        if let path = CommandLine.arguments[safe: 2] {
            MacHelper.load(path: path)
        }else{
            print("Path is missing")
        }
    }
    
    if command == "-play" {
        if let path = CommandLine.arguments[safe: 2] {
            let macHelper = MacHelper()
            macHelper.run(path: path)
        }else{
            print("Path is missing")
        }
    }
    
    if command == "-status" {
        if let idScenario = CommandLine.arguments[safe: 2] {
            ScenarioManager.printStatus(id: idScenario)
        }else{
            print("Status is missing")
        }
    }
    
    if command == "-signal" {
        if let signal = CommandLine.arguments[safe: 2] {
            NotificationsManager.sendSignal(signal: signal)
        }else{
            print("Signal is missing")
        }
    }
    
} else {
    //let macHelper = MacHelper()
    //macHelper.run()
}




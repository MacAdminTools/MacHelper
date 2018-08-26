//
//  main.swift
//  MacHelperNotifier
//
//  Created by mathieu on 22.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

if CommandLine.arguments.count > 1 {
    
    let command = CommandLine.arguments[1]
    
    if command == "-status" {
        if let idScenario = CommandLine.arguments[safe: 2] {
            MacHelperNotifier.printStatus(id: idScenario)
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
    
}


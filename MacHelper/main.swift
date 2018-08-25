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
    switch command {
    case "-load":
        if let path = CommandLine.arguments[safe: 2] {
            MacHelper.load(path: path)
        }else{
            print("Path is missing")
            MacHelper.printUsage()
        }
    case "-play":
        if let path = CommandLine.arguments[safe: 2] {
            let macHelper = MacHelper()
            macHelper.run(path: path)
        }else{
            print("Path is missing")
            MacHelper.printUsage()
        }
    default:
        print("Unknown command")
        MacHelper.printUsage()
    }
} else {
    let macHelper = MacHelper()
    macHelper.run(path: "")
}



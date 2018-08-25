//
//  MacHelper.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

class MacHelper {
    private var shouldQuitCheckInterval = 1.0
    private var shouldQuit = false
    
    init() {
        NotificationCenter.default.addObserver(forName: .HelperShouldQuit, object: nil, queue: nil) { _ in
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                self.shouldQuit = true
            })
        }
    }
    
    static func load(path: String) {
        if let scenario = ScenarioManager.loadScenario(path: path) {
            print("Scenario \(scenario.name) loaded successfully")
        }else{
            print("Scenario failed loading")
        }
    }
    
    func run(path: String = "") {
        
        MainController.shared.play(path: path)
        
        while !shouldQuit {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: shouldQuitCheckInterval))
        }
    }
    
    static func printUsage() {
        
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        print("usage:")
        print("\(executableName) -a string1 string2")
        print("or")
        print("\(executableName) -p string")
        print("or")
        print("\(executableName) -h to show usage information")
        print("Type \(executableName) without an option to enter interactive mode.")
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
}

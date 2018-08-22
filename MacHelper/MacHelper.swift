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
        
        /*let mainController = MainController()
        mainController.play(path: path)*/
        MainController.play(path: path)
        
        while !shouldQuit {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: shouldQuitCheckInterval))
        }
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
}

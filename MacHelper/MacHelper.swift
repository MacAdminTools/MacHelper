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
    
    func run(path: String = "") {
        
        while !shouldQuit {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: shouldQuitCheckInterval))
        }
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
}

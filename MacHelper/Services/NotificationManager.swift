//
//  NotificationManager.swift
//  MacHelper
//
//  Created by mathieu on 22.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

class NotificationsManager {
    
    static let shared = NotificationsManager()
    
    var signals = [String]()
    var observer: Any?
    
    static func sendSignal(signal: String){
        NotificationsManager.postNotification(name: .HostNotification, userInfo: ["type": "signal", "name": signal])
    }
    
    func run() {
        self.registerForNotification(name: .HostNotification) { dic in
            guard let type = dic["type"] as? String
                else {
                    return
            }
            
            switch type {
            case "signal":
                if let name = dic["name"] as? String {
                    print("      Signal received: \(name)")
                    //LogManager.shared.log(line: "Signal received: \(name)")
                    self.addSignal(signal: name)
                }
            default: break
            }
        }
        //LogManager.shared.log(line: "Did register for notifications : " + Notification.Name.HostNotification.rawValue)
    }
    
    func registerForNotification (name: NSNotification.Name, completion: @escaping (_ userInfo: [AnyHashable: Any]) -> Void) {
        
        observer = DistributedNotificationCenter.default().addObserver(forName: name, object: nil, queue: nil) { notification in
            if let userinfo = notification.userInfo {
                completion(userinfo)
            } else {
                //LogManager.shared.log(line: "Userinfo is nil")
            }
        }
    }
    
    func addSignal (signal: String) {
        self.signals.append(signal)
    }
    
    func isSignal (signal: String) -> Bool {
        return self.signals.contains(signal)
    }
    
    static func postNotification (name: NSNotification.Name, userInfo: [String: Any]) {
        DistributedNotificationCenter.default().postNotificationName(name, object: nil, userInfo: userInfo, options: [.deliverImmediately, .postToAllSessions])
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
        if let obs = observer {
            DistributedNotificationCenter.default().removeObserver(obs)
        }
    }
}

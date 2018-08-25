//
//  Constant.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let HelperShouldQuit = Notification.Name("ch.altab.MacHelper.HelperShouldQuit")
    static let ElementTerminated = Notification.Name("ch.altab.MacHelper.ElementTerminated")
    static let HostNotification = Notification.Name("ch.altab.MacHelper.HostNotification")
    static let AddAnchor = Notification.Name("ch.altab.MacHelper.AddAnchor")
}

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//
//  Constant.swift
//  MacHelper
//
//  Created by mathieu on 11.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let HelperShouldQuit = Notification.Name("com.nestec.MacHelper.HelperShouldQuit")
}

enum ScenarioStatus: String {
    case initial, running, terminated
}

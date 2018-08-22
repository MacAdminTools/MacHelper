//
//  Signal.swift
//  MacHelper
//
//  Created by mathieu on 14.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct Signal: Condition {
    
    let name: String

    func test(completion: @escaping (Bool) -> Void) {
        let res = NotificationsManager.shared.isSignal(signal: self.name)
        completion(res)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
    }
    
}

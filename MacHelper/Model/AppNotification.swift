//
//  AppNotification.swift
//  MacHelper
//
//  Created by mathieu on 14.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct AppNotification: Action {
    
    //let appPath: String
    let name: String
    //let userInfo: [AnyHashable: Any]
    //let launchIfRequired: Bool
    //let interval: Double
    //let command: String
    
    func launch(completion: ((Int) -> Void)) {
        completion(0)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
    }
    
}

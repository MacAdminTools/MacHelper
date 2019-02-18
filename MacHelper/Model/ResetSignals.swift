//
//  ResetSignals.swift
//  MacHelper
//
//  Created by mathieu on 27.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

struct ResetSignals: Action {
    
    let signals: [String]
    
    func launch(completion: @escaping (Int) -> Void){
        usleep(200000)
        NotificationCenter.default.post(name: .ResetSignals, object: nil, userInfo: ["signals": signals])
        print("      ACTION: ResetSignals \(signals)")
        completion(0)
    }
    
    private enum CodingKeys: String, CodingKey {
        case signals
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        signals = try values.decode([String].self, forKey: .signals)
    }
}

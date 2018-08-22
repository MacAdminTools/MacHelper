//
//  Condition.swift
//  MacHelper
//
//  Created by mathieu on 14.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

protocol Condition: Decodable {
    
    var name: String { get }
    func test(completion: @escaping (Bool) -> Void)
    
}

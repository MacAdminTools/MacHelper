//
//  Action.swift
//  MacHelper
//
//  Created by mathieu on 14.08.18.
//  Copyright © 2018 altab. All rights reserved.
//

import Foundation

protocol Action: Decodable {
    
    func launch(completion: ((Int) -> Void))
    
}

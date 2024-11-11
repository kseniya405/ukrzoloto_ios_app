//
//  Dictionary+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension Dictionary {
  
  static func += (left: inout [String: Any], right: [String: Any]) {
    for (k, v) in right {
      left[k] = v
    }
  }
  
}

//
//  Array+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 9/13/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension Array {
  
  func dropLastOdd() -> Array {
    return count % 2 == 0 ? self : dropLast()
  }
}

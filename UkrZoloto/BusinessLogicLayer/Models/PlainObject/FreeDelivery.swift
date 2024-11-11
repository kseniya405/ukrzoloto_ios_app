//
//  FreeDelivery.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 8/21/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FreeDelivery {
  
  let novaPoshta: Int
  let courierKiev: Int
  
  init(json: JSON) {
    self.novaPoshta = json[NetworkResponseKey.FreeDelivery.novaPoshta].intValue
    self.courierKiev = json[NetworkResponseKey.FreeDelivery.courierKiev].intValue
  }
  
}

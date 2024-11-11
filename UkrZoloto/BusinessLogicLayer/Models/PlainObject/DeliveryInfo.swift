//
//  DeliveryInfo.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/30/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

struct DeliveryInfo {

  let title: String
  let code: String
  
  init?(json: JSON) {
    guard let title = json[NetworkResponseKey.DeliveryInfo.title].string,
      let code = json[NetworkResponseKey.DeliveryInfo.type].string else {
        return nil
    }
    self.title = title
    self.code = code
  }
}

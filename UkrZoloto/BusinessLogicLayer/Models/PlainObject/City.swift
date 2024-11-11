//
//  City.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/19/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

struct City: HashableTitle, Hashable {
  let id: Int
  let title: String
  
  let shops: [Shop]
  
  init(id: Int,
       title: String,
       shops: [Shop] = []) {
    self.id = id
    self.title = title
    self.shops = shops
  }
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.City.id].int,
      let title = json[NetworkResponseKey.City.title].string else {
        return nil
    }
    
    self.id = id
    self.title = title
    self.shops = json[NetworkResponseKey.City.shops].arrayValue.compactMap { shopItem in
      return Shop(json: shopItem)
    }
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(title)
  }

  static func == (lhs: City, rhs: City) -> Bool {
    return lhs.id == rhs.id
  }
}

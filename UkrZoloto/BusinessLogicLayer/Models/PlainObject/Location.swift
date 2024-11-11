//
//  Location.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Location: HashableTitle, Hashable {

  // MARK: - Public variables
  let id: Int
  let title: String
  
  // MARK: - Life cycle
  init(shop: NewShopsItem) {
    self.id = shop.id ?? 0
    self.title = shop.title ?? ""
  }
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Delivery.id].int,
      let title = json[NetworkResponseKey.Delivery.title].string else {
        return nil
    }
    self.id = id
    self.title = title.prefix(1) == " " ? String(title.dropFirst()) : title
  }
  
  func isBold() -> Bool {
    switch self.id {
    case 1: return true
    case 31: return true
    case 32: return true
    case 2: return true
    case 41: return true
    case 23: return true
    case 40: return true
    case 5: return true
    case 30: return true
    case 26: return true
    case 27193: return true
    case 28280: return true
    case 29581: return true
    case 26695: return true
    case 27668: return true
    case 28646: return true
    case 26923: return true
    case 26297: return true
    case 29597: return true
    case 29699: return true

    default: return false
    }
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(title)
  }
}

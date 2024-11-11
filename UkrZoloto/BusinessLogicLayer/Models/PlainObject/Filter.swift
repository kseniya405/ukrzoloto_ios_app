//
//  Filter.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 08.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

class Filter {
  
  let id: String
  let type: String
  let title: String
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Filter.id].string else {
      return nil
    }
    self.id = id
    self.type = json[NetworkResponseKey.Filter.type].stringValue
    self.title = json[NetworkResponseKey.Filter.title].stringValue
  }
  
}

class RangeFilter: Filter {
  
  let max: Int
  let min: Int
  var minPrice: Int
  var maxPrice: Int
  
  override init?(json: JSON) {
    self.max = json[NetworkResponseKey.RangeFilter.max].intValue / 100
    self.min = json[NetworkResponseKey.RangeFilter.min].intValue / 100
    self.minPrice = json[NetworkResponseKey.RangeFilter.minPrice].intValue / 100
    self.maxPrice = json[NetworkResponseKey.RangeFilter.maxPrice].intValue / 100
    guard min < max else { return nil }
    super.init(json: json)
  }
  
}

class SelectFilter: Filter {
  
  var variants = [FilterVariant]()
  
  override init?(json: JSON) {
    self.variants = json[NetworkResponseKey.SelectFilter.variants].arrayValue.compactMap { FilterVariant(json: $0) }
    super.init(json: json)
  }
  
}

// MARK: - Equatable
extension Filter: Equatable {
  static func == (lhs: Filter, rhs: Filter) -> Bool {
    return lhs.id == rhs.id
  }

}

//
//  FilterVariant.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 08.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TypeSelect: String {
  case manual
  case auto // TODO: Check
}

struct FilterVariant {
  
  let id: String
  let slug: String
  let value: String
  let active: Bool
  var status: Bool
  let typeSelect: TypeSelect
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.FilterVariant.id].string else {
      return nil
    }
    self.id = id
    self.slug = json[NetworkResponseKey.FilterVariant.slug].stringValue
    self.value = json[NetworkResponseKey.FilterVariant.value].stringValue
    self.active = json[NetworkResponseKey.FilterVariant.active].boolValue
    self.status = json[NetworkResponseKey.FilterVariant.status].boolValue
    self.typeSelect = TypeSelect(rawValue: json[NetworkResponseKey.FilterVariant.typeSelect].stringValue) ?? .manual
  }
}

extension FilterVariant: Equatable {
  static func == (lhs: FilterVariant, rhs: FilterVariant) -> Bool {
    return lhs.slug == rhs.slug
  }
}

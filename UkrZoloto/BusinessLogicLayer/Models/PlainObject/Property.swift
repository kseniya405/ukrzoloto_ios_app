//
//  Property.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Property: Hashable {
  
  let code: String
  let name: String
  let title: String
  
  init(code: String,
       name: String,
       title: String) {
    self.code = code
    self.name = name
    self.title = title
  }
  
  init?(json: JSON) {
    guard let code = json[NetworkResponseKey.Property.code].string,
      let name = json[NetworkResponseKey.Property.name].string,
      let title = json[NetworkResponseKey.Property.title].string else {
        return nil
    }
    self.code = code
    self.name = name
    self.title = title
  }
}

// MARK: - Equatable
extension Property: Equatable {
  static func == (lhs: Property, rhs: Property) -> Bool {
    return lhs.code == rhs.code
  }
  
}

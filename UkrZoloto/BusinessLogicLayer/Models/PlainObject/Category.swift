//
//  Category.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category {

  let id: Int
  let name: String
  let slug: String
  let imageURL: URL?
  let subcategories: [Subcategory]

  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Category.id].int,
      let name = json[NetworkResponseKey.Category.name].string,
      let slug = json[NetworkResponseKey.Category.slug].string else {
        return nil
    }
    self.id = id
    self.name = name
    self.slug = slug
    self.imageURL = URL(string: json[NetworkResponseKey.Category.image].stringValue)
    subcategories = json[NetworkResponseKey.Category.children].arrayValue.compactMap { Subcategory(json: $0) }
  }
}

//
//  Subcategory.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/29/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Subcategory {

  let id: Int
  let name: String
  let imageURL: URL?
  let categoryExternalId: Int?
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Subcategory.categoryId].int,
      let name = json[NetworkResponseKey.Subcategory.name].string else {
        return nil
    }
    self.id = id
    self.name = name
    self.imageURL = URL(string: json[NetworkResponseKey.Category.image].stringValue)
    self.categoryExternalId = json[NetworkResponseKey.Category.categoryExternalId].int
  }
  
  init(id: Int,
       name: String,
       imageURL: URL?,
       categoryExternalId: Int? = nil) {
    self.id = id
    self.name = name
    self.imageURL = imageURL
    self.categoryExternalId = categoryExternalId
  }
}

//
//  Banner.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Banner {
  
  let id: Int
  let title: String
  let categoryId: Int
  let url: URL?
  let categoryExternalId: Int?
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Banner.id].int,
      let title = json[NetworkResponseKey.Banner.title].string,
      let categoryId = json[NetworkResponseKey.Banner.categoryId].int else {
        return nil
    }
    self.id = id
    self.title = title
    self.categoryId = categoryId
    url = URL(string: json[NetworkResponseKey.Banner.image].stringValue)
    self.categoryExternalId = json[NetworkResponseKey.Banner.categoryExternalId].int
  }
  
  init(id: Int,
       title: String,
       categoryId: Int,
       url: URL?,
       categoryExternalId: Int?) {
    self.id = id
    self.title = title
    self.categoryId = categoryId
    self.url = url
    self.categoryExternalId = categoryExternalId
  }
  
}

//
//  CategoryPush.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 11/18/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

struct CategoryPush {

  // MARK: - Public variables
  let id: Int
  let name: String?

  // MARK: - Life cycle
  init?(_ dictionary: [AnyHashable: Any]) {
    guard let categoryIdString = dictionary[NetworkResponseKey.CategoryPush.categoryId] as? String,
      let categoryId = Int(categoryIdString) else { return nil }
    self.id = categoryId
    name = dictionary[NetworkResponseKey.CategoryPush.categoryName] as? String
  }
}

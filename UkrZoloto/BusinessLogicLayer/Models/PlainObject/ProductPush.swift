//
//  ProductPush.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 05.05.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

struct ProductPush {

  // MARK: - Public variables
  let id: Int
  
  // MARK: - Life cycle
  init?(_ dictionary: [AnyHashable: Any]) {
    guard let productIdString = dictionary[NetworkResponseKey.ProductPush.productId] as? String,
      let productId = Int(productIdString) else { return nil }
    self.id = productId
  }
  
  init(id: Int) {
    self.id = id
  }
  
}

//
//  Variant.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Variant {
  
  let id: Int
  let name: String
  let sku: String
  let price: Price
  let quantity: Int
  let size: Property?
  var isInCart: Bool

  let properties: [Property]
	let creditList: [CreditOption]
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Product.id].int,
      let name = json[NetworkResponseKey.Product.name].string,
      let sku = json[NetworkResponseKey.Product.sku].string,
      // TODO: Change
      let price = Price(json: json[NetworkResponseKey.Product.price]),
      let quantity = json[NetworkResponseKey.Product.quantity].int else {
        return nil
    }
    self.id = id
    self.name = name
    self.sku = sku
    self.price = price
    self.quantity = quantity
    self.size = Property(json: json[NetworkResponseKey.Product.size])
    self.properties = json[NetworkResponseKey.Product.properties].arrayValue.compactMap { Property(json: $0) }
    isInCart = json[NetworkResponseKey.Product.inCart].boolValue
		self.creditList = json[NetworkResponseKey.Product.creditList].arrayValue.compactMap { CreditOption(json: $0) }
  }
}

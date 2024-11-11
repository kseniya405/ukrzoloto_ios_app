//
//  Cart.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Cart {
  
  var cartItems: [CartItem]
  let totalPrice: Currency
	let amountExchange: Int
  
  init?(json: JSON) {
    guard let price = json[NetworkResponseKey.Cart.total].int else {
        return nil
    }
    self.totalPrice = Decimal(price) / 100
    cartItems = json[NetworkResponseKey.Cart.cart].arrayValue.compactMap { CartItem(json: $0) }
		amountExchange = json[NetworkResponseKey.Cart.amountExchange].intValue
  }
	
	init(cartItems: [CartItem], totalPrice: Currency, amountExchange: Int) {
		self.cartItems = cartItems
		self.totalPrice = totalPrice
		self.amountExchange = amountExchange
	}
}

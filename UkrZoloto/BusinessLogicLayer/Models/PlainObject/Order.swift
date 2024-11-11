//
//  Order.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/30/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

enum OrderStatus: String {
  case new
}

struct Order {
  
  let id: Int
  let number: Int
  let status: OrderStatus
  let deliveryInfo: DeliveryInfo
  let paymentInfo: PaymentInfo
  let totalPrice: Currency
  let products: [CartItem]
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Order.id].int,
      let number = json[NetworkResponseKey.Order.number].int,
      let deliveryInfo = DeliveryInfo(json: json[NetworkResponseKey.Order.delivery]),
      let total = json[NetworkResponseKey.Order.total].int,
      let status = OrderStatus(rawValue: json[NetworkResponseKey.Order.status].stringValue),
      let paymentInfo = PaymentInfo(json: json[NetworkResponseKey.Order.payment]) else {
        return nil
    }
    self.id = id
    self.number = number
    self.deliveryInfo = deliveryInfo
    self.paymentInfo = paymentInfo
    self.totalPrice = Decimal(total) / 100
    self.status = status
    
    products = json[NetworkResponseKey.Order.goods].arrayValue.compactMap { CartItem(json: $0) }
  }
}

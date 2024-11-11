//
//  DeliveryMethod.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

enum DeliveryType {
  case location(location: Location?, sublocation: Location?)
  case address(location: Location?, sublocation: Location?, address: Address?)
}

struct DeliveryMethod {
  
  // MARK: - Public variables
  let id: Int
  let code: String
  var type: DeliveryType
  let title: String
  let description: String?
  let paymentMethods: [PaymentMethod]
  let minPrice: Int?

  // MARK: - Life cycle
  init?(json: JSON) {
    guard let code = json[NetworkResponseKey.Delivery.code].string,
      let id = json[NetworkResponseKey.Delivery.id].int,
      let title = json[NetworkResponseKey.Delivery.title].string,
          json[NetworkResponseKey.Delivery.type].string != nil else {
        return nil
    }
    self.id = id
    self.code = code
    self.title = title

    if self.code == NetworkResponseKey.Delivery.DeliveryCode.novaPoshtaAddress {
      self.type = .address(location: nil, sublocation: nil, address: nil)
    } else {
      self.type = .location(location: nil, sublocation: nil)
    }
//    switch type {
//    case NetworkResponseKey.Delivery.location:
//      self.type = .location(location: nil, sublocation: nil)
//    case NetworkResponseKey.Delivery.address:
//      self.type = .address(location: nil, nil)
//    default:
//      return nil
//    }

    description = json[NetworkResponseKey.Delivery.description].string
    paymentMethods = json[NetworkResponseKey.Delivery.payments].arrayValue.compactMap { FullPayment(json: $0) ?? InstallmentPaymentMethod(json: $0) }
    minPrice = json[NetworkResponseKey.Delivery.minPriceActivated].int
  }
  
  init() {
    id = 1234
    code = "code"
    type = .location(location: nil, sublocation: nil)
    title = "TEST"
    description = nil
    paymentMethods = [PaymentMethod()]
    minPrice = 0
    
  }
  
}

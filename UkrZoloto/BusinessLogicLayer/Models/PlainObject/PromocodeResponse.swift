//
//  PromocodeResponse.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 21.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PromocodeResponse {

  let promocodHave: Bool
  let statusBonus: Bool
  let pricePromo: Decimal
  let priceDiscont: Decimal
  let amountBonus: Int?
  let error: ServerError?
  
  init?(json: JSON) {
    self.promocodHave = json[NetworkResponseKey.CartPriceDetails.promocodHave].boolValue
    self.statusBonus = json[NetworkResponseKey.CartPriceDetails.statusBonus].boolValue
    self.pricePromo = Decimal(json[NetworkResponseKey.CartPriceDetails.pricePromo].intValue)
    self.priceDiscont = Decimal(json[NetworkResponseKey.CartPriceDetails.priceDiscont].intValue)
    self.amountBonus = json[NetworkResponseKey.CartPriceDetails.amountBonus].intValue
    
    let errorJSON = json[NetworkResponseKey.CartPriceDetails.error]
    if !errorJSON.isEmpty {
      let errorCode = errorJSON[NetworkResponseKey.Error.code].intValue
      self.error = ServerError(type: errorCode, json: errorJSON)
    } else {
      self.error = nil
    }
  }
}

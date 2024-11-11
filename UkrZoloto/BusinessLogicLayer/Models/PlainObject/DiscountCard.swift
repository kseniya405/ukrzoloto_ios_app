//
//  DiscountCard.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 11/1/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DiscountCard {
  
  // MARK: - Public variables
  let goldDiscount: Int
  let silverDiscount: Int
  let cardNumber: String
  
  // MARK: - Life Cycle
  init?(json: JSON) {
    guard let dictionary = json.dictionary,
      let goldDiscount = dictionary[NetworkResponseKey.DiscountCard.discountGold]?.intValue,
      // let silverDiscount = dictionary[NetworkResponseKey.DiscountCard.discountSilver]?.intValue,
      let cardNumber = dictionary[NetworkResponseKey.DiscountCard.cardNumber]?.string else {
        return nil
    }
    self.goldDiscount = goldDiscount
    self.silverDiscount = 5 // silverDiscount
    self.cardNumber = cardNumber
  }
  
  init?(discountCardMO: DiscountCardMO) {
    guard let cardNumber = discountCardMO.number else { return nil }
    goldDiscount = Int(discountCardMO.gold)
    silverDiscount = Int(discountCardMO.silver)
    self.cardNumber = cardNumber
  }
}

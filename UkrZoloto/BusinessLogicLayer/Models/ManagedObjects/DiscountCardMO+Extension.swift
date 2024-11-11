//
//  DiscountCardMO+Extension.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 02.11.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension DiscountCardMO {
  func fill(from discountCard: DiscountCard) {
    gold = Int16(discountCard.goldDiscount)
    silver = Int16(discountCard.silverDiscount)
    number = discountCard.cardNumber
  }
}

//
//  Price.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias Currency = Decimal
typealias Percent = Int

struct Price {
  
  let current: Currency
  let old: Currency
  let discount: Percent
  
  init(current: Currency,
       old: Currency,
       discount: Percent) {
    self.current = current
    self.old = old
    self.discount = discount
  }
  
  init(_ currency: Currency) {
    self.init(current: currency, old: currency, discount: 0)
  }
  
  init?(json: JSON) {
    guard let current = json[NetworkResponseKey.Price.current].int,
          let old = json[NetworkResponseKey.Price.old].int else {
      return nil
    }
    self.current = Decimal(current) / 100
    self.old = Decimal(old) / 100
    discount = json[NetworkResponseKey.Price.discountPercent].intValue
  }
}

private extension Price {
  static func currentPriceWithDiscount(currentPrice: Decimal) -> Decimal {
    var discount = ProfileService.shared.discountValue()

    if ProfileService.shared.isBirthdayPeriod() {
      discount += 5
    }

    let discountValue: Decimal = (100.0 - Decimal(discount)) / 100.0

    let calcualtedCurrentPrice = currentPrice * discountValue
    let roundedCurrentPrice = roundCurrenPrice(calcualtedCurrentPrice)

    return roundedCurrentPrice
  }

  static func roundCurrenPrice(_ priceValue: Decimal) -> Decimal {
    let roundingBehavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
    let decimalNumber = NSDecimalNumber(decimal: priceValue)
    let roundedNumber = decimalNumber.rounding(accordingToBehavior: roundingBehavior)

    return roundedNumber.decimalValue
  }
}

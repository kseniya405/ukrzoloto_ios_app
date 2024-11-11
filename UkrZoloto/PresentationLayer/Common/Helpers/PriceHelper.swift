//
//  PriceHelper.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 30.04.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

class PriceHelper {
  
  // MARK: - Public variables
  static let shared = PriceHelper()
  
  // MARK: - Life cycle
  private init() {}
  
  // MARK: - Interface
  func getDiscountPrice(totalPrice: Price, discount: Int) -> Price {
    let discountAmount = (totalPrice.current as NSDecimalNumber).intValue * discount / 100
    return Price(Currency(discountAmount))
  }
  
  func getTotalDiscountPrice(totalPrice: Price, discount: Int) -> Price {
    let discountAmount = (totalPrice.current as NSDecimalNumber).intValue * discount / 100
    return Price(totalPrice.current - Decimal(discountAmount))
  }
  
  func getWithBonusesPrice(currentPrice: Price, promoBonuses: Int, bonuses: Int, promocode: Decimal) -> Price {
    return Price(currentPrice.current - Decimal(promoBonuses) - Decimal(bonuses) - promocode)
  }
  
}

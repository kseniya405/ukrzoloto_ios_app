//
//  PriceCalculationService.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 15.08.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation

class PriceCalculationService {
  private enum Consts {
    static let cashbackValue: Decimal = 0.02
  }

  // MARK: - Public variables
  static let shared = PriceCalculationService()

  func calculatePriceWithDiscount(_ price: Price) -> Decimal {
    let discount = ProfileService.shared.discountValue()

    let discountValue: Decimal = (100.0 - Decimal(discount)) / 100.0

    let priceWithDiscount = roundPriceValue(price.current * discountValue)

    return priceWithDiscount
  }

  func calculateCashback(_ price: Price) -> Decimal {
    let priceWithDiscount = self.calculatePriceWithDiscount(price)

    let cashback = roundPriceValue(priceWithDiscount * Consts.cashbackValue)

    return cashback
  }

  private func roundPriceValue(_ priceValue: Decimal) -> Decimal {
    let roundingBehavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
    let decimalNumber = NSDecimalNumber(decimal: priceValue)
    let roundedNumber = decimalNumber.rounding(accordingToBehavior: roundingBehavior)

    return roundedNumber.decimalValue
  }
}

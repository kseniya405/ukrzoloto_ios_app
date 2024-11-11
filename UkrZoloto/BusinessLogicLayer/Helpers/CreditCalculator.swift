//
//  CreditCalculator.swift
//  UkrZoloto
//
//  Created by Mykola on 04.10.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class CreditCalculator {
  
  class func getMonthlyPaymentIfAvailable(price: Decimal, comission: Double, months: Int?) -> Int? {
		guard let months = months else { return nil }
    return getMonthlyPayment(price: price, comission: comission, months: months)
  }
	
	class func getMonthlyPayment(price: Decimal, comission: Double, months: Int) -> Int {
		let price = NSDecimalNumber(decimal: price).doubleValue
		let comissionPart = comission * 0.01 * price
		let paymentWithoutComission = price / Double(months)
		let monthlyPayment = comissionPart + paymentWithoutComission
		return Int(monthlyPayment.rounded())
	}
  
  class func getLowestMonthlyPayment(price: Price, credits: [CreditOption]) -> NSDecimalNumber? {
    
		let results = credits.compactMap( { getMonthlyPaymentIfAvailable(price: price.current, comission: $0.comission, months: $0.month.max())}).min()
    
    if let value = results {
      return NSDecimalNumber(integerLiteral: value)
    }
    
    return nil
  }
	
	class func getBiggestMonthCount(credits: [CreditOption]) -> Int? {
		return credits.compactMap({$0.month.max()}).max()
	}
}

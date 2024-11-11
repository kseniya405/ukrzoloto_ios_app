//
//  InstallmentPaymentViewModel.swift
//  UkrZoloto
//
//  Created by Mykola on 02.11.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit


class InstallmentPaymentViewModel {
  
  var providerName: String
  var allowedMonths: [Int]
  var selectedMonth: Int {
    didSet {
      recalculate()
    }
  }
  var code: String
  var detailsText: String
  let comission: Double
  
  var isSelected: Bool
  var bankIcon: UIImage?
  var totalPrice: Currency
  
  var monthlyPayment: Currency!
  
  init(providerName: String,
       allowedMonths: [Int],
       description: String,
       selectedMonth: Int? = nil,
       isSelected: Bool,
       code: String,
       icon: UIImage?,
       totalPrice: Currency,
       comission: Double) {
    
    self.providerName = providerName
    self.allowedMonths = allowedMonths
    self.selectedMonth = selectedMonth ?? (allowedMonths.max() ?? 0)
    self.isSelected = isSelected
    self.code = code
    self.bankIcon = icon
    self.totalPrice = totalPrice
    self.detailsText = description
    self.comission = comission
    
    recalculate()
  }
  
  func updateTotalPrice(price: Currency) {
    
    totalPrice = price
    recalculate()
  }
  
  func recalculate() {
    
    let monthlyPayment = CreditCalculator.getMonthlyPayment(price: totalPrice, comission: comission, months: selectedMonth)
    self.monthlyPayment = Decimal(monthlyPayment)
  }
}

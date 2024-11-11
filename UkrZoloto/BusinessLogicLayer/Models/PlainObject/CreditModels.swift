//
//  CreditModels.swift
//  UkrZoloto
//
//  Created by Mykola on 04.10.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

enum CreditOptionsItem {
  case title(imageUrl: URL?, title: String, price: Price)
  case option(data: CreditOptionData)
}

struct CreditDTO {
  let bank: Bank
  let months: Int
  let variantId: Int
}

struct CreditOptionData {
  let bank: Bank
  let title: String
  let availableMonths: [Int]
  var months: Int
  var expanded: Bool
  var description: String
  let comission: Double
  var monthlyPayment: Int
  
  mutating func toggle() {
    self.expanded = !self.expanded
  }
  
  mutating func updateMonths(_ months: Int) {
    self.months = months
  }
  
  mutating func updateMonthlyPayment(_ payment: Int) {
    self.monthlyPayment = payment
  }
}

enum Bank: String, CaseIterable  {
  case otp = "otp_bank"
  case monobank
  case privat = "credit_privat_bank"
  case privatInstallment = "credit_privat_instant_installment"
  case alpha = "credit_alfabank"
  case globusPlus = "credit_globus_plus"
  case abank = "credit_abank"
  
  func getIcon() -> UIImage? {
    switch self {
    case .otp: return UIImage(named: "otp_active")
    case .monobank: return UIImage(named: "monobank_active")
    case .privat: return UIImage(named: "privat_active")
    case .privatInstallment: return UIImage(named: "privat_installment_active")
    case .alpha: return UIImage(named: "alpha_active")
    case .globusPlus: return UIImage(named: "globus_plus")
    case .abank: return UIImage(named: "abank_active")
    }
  }
  
  func getAvailableMonths(_ months: [Int]) -> [Int] {
    guard months.count <= 1 else {
      return months
    }

    var result = [Int]()
    
    switch self {
    case .otp:
      result = self.getAvailableMonthsBy(minAvailableMonths: months.first ?? 5, maxAvailableMonths: months.first)
    case .privat:
      result = self.getAvailableMonthsBy(minAvailableMonths: 2, maxAvailableMonths: months.first)
    case .monobank, .globusPlus:
      result = self.getAvailableMonthsBy(minAvailableMonths: 3, maxAvailableMonths: months.first)
    case .privatInstallment:
      result = self.getAvailableMonthsBy(minAvailableMonths: 2, maxAvailableMonths: months.first)
    case .alpha:
      result.append(contentsOf: months)
    case .abank:
      result = self.getAvailableMonthsBy(minAvailableMonths: 4, maxAvailableMonths: months.first)
    }
    
    return result
  }

  private func getAvailableMonthsBy(minAvailableMonths: Int, maxAvailableMonths: Int?) -> [Int] {
    var result = [Int]()

    for i in minAvailableMonths...(maxAvailableMonths ?? minAvailableMonths) {
      result.append(i)
    }

    return result
  }
}

//
//  PaymentMethod.swift
//  UkrZoloto
//
//  Created by Andrew on 8/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

enum PaymentCode: String {
  case cash
  case wayforpay
  case liqpay
  case cashless
  case credit
}

class PaymentMethod {
  
  var id: Int
  var type: String
  var title: String
  var code: PaymentCode
  var deliverySummary: String?
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Payment.id].int,
      let code = PaymentCode(rawValue: json[NetworkResponseKey.Payment.code].stringValue) else {
      return nil
    }
    self.id = id
    self.type = json[NetworkResponseKey.Payment.type].stringValue
    self.title = json[NetworkResponseKey.Payment.title].stringValue
    self.code = code
    deliverySummary = nil
  }
  
  init() {
    self.id = 321
    self.type = "pay type"
    self.title = "pay title"
    self.code = PaymentCode.cash
    deliverySummary = nil
  }
  
  func rawRepresentation() -> String {
    
    return code.rawValue
  }
  
  func nestedRepresentation() -> [String: Any] {
    
    return ["type": rawRepresentation()]
  }
}

class FullPayment: PaymentMethod {
  
  override init?(json: JSON) {
    super.init(json: json)
  }
}

class InstallmentPaymentMethod: PaymentMethod {
  
  var providerCode: String!
  var allowedMonths: [Int] = []
  
  var description: String!
  var comission: Double!
  
  lazy var selectedMonth: Int = {
    
    guard let code = providerCode,
          let bank = Bank(rawValue: code) else {
      return 0
    }
    
    switch bank {
      
    case .privatInstallment:
      return allowedMonths.max()!
      
    default:
      return allowedMonths.min()!
    }
  }()
  
  var icon: UIImage?
  var cardNumbers: String?

  override func rawRepresentation() -> String {
    
    return providerCode
  }

  override func nestedRepresentation() -> [String: Any] {
    if rawRepresentation() == NetworkResponseKey.Credits.alphabank {
      return ["type": rawRepresentation(), "data": ["partsCount": "\(selectedMonth)", "card" : "\(cardNumbers ?? "")"]]
    } else {
      return ["type": rawRepresentation(), "data": ["partsCount": "\(selectedMonth)"]]
    }
  }
  
  override init?(json: JSON) {
    
    super.init()
        
    self.id = json[NetworkResponseKey.Payment.id].int ?? 0
    self.type = json[NetworkResponseKey.Payment.type].stringValue
    self.title = json[NetworkResponseKey.Payment.title].stringValue.replacingOccurrences(of: "&nbsp;", with: "\u{00A0}")
        
    self.providerCode = json[NetworkResponseKey.Payment.code].stringValue
    self.description = json[NetworkResponseKey.Payment.description].stringValue.replacingOccurrences(of: "&nbsp;", with: "\u{00A0}")
    
    let creditInfo = json[NetworkResponseKey.Payment.credit]
    
    comission = creditInfo[NetworkResponseKey.Payment.comission].doubleValue
    
    guard let bank = Bank(rawValue: self.providerCode) else { return nil }

    
    if let month = creditInfo[NetworkResponseKey.Payment.month].int {
      
      self.allowedMonths = bank.getAvailableMonths([month])
      
    } else {
      
      let months = creditInfo[NetworkResponseKey.Payment.month].arrayValue.map({ $0.intValue })
      self.allowedMonths = months
    }
    
    self.icon = bank.getIcon()
    
  }
}

// MARK: - Equatable
extension PaymentMethod: Equatable {
  static func == (lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
    return lhs.id == rhs.id
  }
  
}

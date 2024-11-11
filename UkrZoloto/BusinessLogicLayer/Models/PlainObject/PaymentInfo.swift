//
//  PaymentInfo.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/30/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

struct PaymentInfo {

  let title: String
  let type: PaymentCode
  let isPayed: Bool
  let paymentURL: URL?
  let redirectURL: URL?
  
  init?(json: JSON) {
    guard let title = json[NetworkResponseKey.PaymentInfo.title].string else {
        return nil
    }
    
    if let type = PaymentCode(rawValue: json[NetworkResponseKey.PaymentInfo.type].stringValue) {
      self.type = type
    } else {
      self.type = .credit
    }
    
    self.title = title
    isPayed = json[NetworkResponseKey.PaymentInfo.isPayed].boolValue
    paymentURL = URL(string: json[NetworkResponseKey.PaymentInfo.paymentUrl].stringValue)
    redirectURL = URL(string: json[NetworkResponseKey.PaymentInfo.redirectUrl].stringValue)
  }
}

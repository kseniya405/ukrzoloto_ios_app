//
//  AdjustAnalyticsService.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 24.01.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation
import Adjust

private enum Consts {
  enum General {
    static let appToken = "jmw24vpe8lc0"
    static let unauthorizedUser = "unauthorized"
  }

  enum EventToken {
    static let authorization = "9xq44y"
    static let addToCart = "682s5f"
    static let createOrder = "njntpb"
  }

  enum EventKey {
    static let userId = "user_id"
    static let transactionId = "transaction_id"
  }
}

class AdjustAnalyticsService {
  class func configureApp() {
    let environment = ADJEnvironmentProduction // ADJEnvironmentSandbox

    let adjustConfig = ADJConfig(
      appToken: Consts.General.appToken,
      environment: environment)

      adjustConfig?.logLevel = ADJLogLevelVerbose

    Adjust.appDidLaunch(adjustConfig)
  }
}

// MARK: - Events
extension AdjustAnalyticsService {
  class var userPhoneNumber: String? {
    get {
      return ProfileService.shared.user?.phone
    }
  }

  class func logSignUp() {
    if ProfileService.shared.user != nil {
      Adjust.trackEvent(ADJEvent(eventToken: Consts.EventToken.authorization))
    }
  }

  class func logSignIn() {
    if ProfileService.shared.user != nil {
      Adjust.trackEvent(ADJEvent(eventToken: Consts.EventToken.authorization))
    }
  }

  class func logAddToCart(productId: String, currency: String = "UAH", price: Decimal) {
    Adjust.trackEvent(ADJEvent(eventToken: Consts.EventToken.addToCart))
  }

  class func logSuccessOrder(
    orderNumber: Int,
    productIds: String,
    currency: String = "UAH",
    price: Decimal) {
    if let convertedTotalPrice = Double("\(price)"),
       let event = ADJEvent(eventToken: Consts.EventToken.createOrder) {
      event.setRevenue(convertedTotalPrice, currency: currency)

      var userIdValue = ""
			if let userId = ProfileService.shared.userId {
				userIdValue = "\(userId)"
			}
			
      event.addCallbackParameter(Consts.EventKey.userId, value: userIdValue)
      event.addCallbackParameter(Consts.EventKey.transactionId, value: "\(orderNumber)")
      
      Adjust.trackEvent(event)
    }
  }
}

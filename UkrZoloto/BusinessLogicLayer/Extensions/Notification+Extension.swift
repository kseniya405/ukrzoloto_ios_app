//
//  Notification+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

extension Notification.Name {
  static let networkBecomeAvailable = Notification.Name("networkBecomeAvailable")
  static let networkBecomeNotAvailable = Notification.Name("networkBecomeNotAvailable")
  
  static let userWasUpdated = Notification.Name("userWasUpdated")
  static let userWasLoggedOut = Notification.Name("userWasLoggedOut")
  static let needToSignIn = Notification.Name("needToSignIn")

  static let cartWasUpdated = Notification.Name("cartWasUpdated")
  static let showCategory = Notification.Name("showCategory")
  static let showProduct = Notification.Name("showProduct")
  
  static let logOutProfile = Notification.Name("logOutProfile")

  static let didUpdateProductFavoriteStatus = Notification.Name("updateFavoriteStatus")
  static let contactsUpdated = Notification.Name("contactsUpdated")
}

extension Notification {
  struct Key {
    static let productId = "productId"
    static let newFavoriteStatus = "newFavoriteStatus"
    static let updatedUser = "updatedUser"
    static let categoryPush = "categoryPush"
    static let productPush = "productPush"
  }
}

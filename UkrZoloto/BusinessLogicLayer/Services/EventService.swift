//
//  EventService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 12/28/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import FirebaseAnalytics
import FBSDKCoreKit
import StoreKit
import Reteno
import SwiftUI

class EventService {
  private var defaults = UserDefaults.standard
  private let deepLinkEventParameters = "deepLinkEventParameters"
  // MARK: - Public variables
  static let shared = EventService()
	var sessionId: Int64 = -1
  
  // MARK: - Life cycle
  private init() { }
    
  // MARK: - Events
  func logAddToCart(productId: Int, name: String, price: Decimal, currency: String = "UAH") {
    AdjustAnalyticsService.logAddToCart(productId: "\(productId)", price: price)

    let params: [String: Any] = [AnalyticsParameterItemName: name,
                                 AnalyticsParameterItemID: "\(productId)",
                                 AnalyticsParameterCurrency: currency,
                                 AnalyticsParameterPrice: price as NSNumber,
                                 AnalyticsParameterValue: price as NSNumber
    ]
    Analytics.logEvent(AnalyticsEventAddToCart,
                       parameters: params)

    let fbParams: [AppEvents.ParameterName: Any] = [
      AppEvents.ParameterName.contentID: productId,
      AppEvents.ParameterName.contentType: "product",
      AppEvents.ParameterName.currency: currency
    ]

    AppEvents.shared.logEvent(.addedToCart,
                       valueToSum: Double(truncating: price as NSNumber),
                       parameters: fbParams)
    broadcastAdTrackingToFacebook()
  }
  
  func logAppStart() {
//    
  }

  func logSuccessOrder(order: Order) {
    RetenoAnalyticsService.logSuccessOrder(successOrder: order)

    let productIds = order.products.map { $0.productId }.map { "\($0)" }.joined(separator: ",")

    AdjustAnalyticsService.logSuccessOrder(
      orderNumber: order.number,
      productIds: productIds,
      price: order.totalPrice)
  }
  
  func logBeginCheckout(price: Decimal, ids: [Int], currency: String = "UAH") {
    let params: [String: Any] = [AnalyticsParameterCurrency: currency,
                                 AnalyticsParameterValue: price as NSNumber
    ]
    Analytics.logEvent(AnalyticsEventBeginCheckout,
                       parameters: params)
    
    let parameters: [AppEvents.ParameterName: Any] =
    [AppEvents.ParameterName.contentID: ids.map { "\($0)" }.joined(separator: ","),
     AppEvents.ParameterName.currency: currency]

    AppEvents.shared.logEvent(.initiatedCheckout,
                       valueToSum: Double(truncating: price as NSNumber),
                       parameters: parameters)
    broadcastAdTrackingToFacebook()
  }
  
	func logPurchase(id: Int, price: Decimal, currency: String = "UAH", userId: Int) {
//    var params: [String: Any] = [AnalyticsParameterTransactionID: "\(id)",
//                                 AnalyticsParameterCurrency: currency,
//                                 AnalyticsParameterValue: price as NSNumber,
//                                 "user_id": "\(userId)",
//                                 "platform": "iOS"
//    ]
//    
//      if let deepLinkEventParameters = defaults.value(forKey: deepLinkEventParameters) as?  [String: Any] {
//          
//          deepLinkEventParameters.forEach({ key, value in
//        params[key] = value
//      })
//    }
//
//    Analytics.logEvent("purchase",
//                       parameters: params)
//    
		let price = Double(truncating: price as NSNumber)
		AppEvents.shared.logPurchase(
			amount: price,
			currency: currency,
			parameters: [AppEvents.ParameterName("transaction_id"): "\(id)", AppEvents.ParameterName("user_id"): "\(userId)"])
				
		broadcastAdTrackingToFacebook()
	}
	
	func logPurchase(order: Order, currency: String = "UAH") {
		var itemsProduct = [[String: Any]]()
		for item in order.products {
			itemsProduct.append([
				AnalyticsParameterItemID: item.sku,
				AnalyticsParameterItemName: item.name,
				AnalyticsParameterItemCategory: item.categoryExternalId ?? "",
				AnalyticsParameterItemVariant: item.size ?? "",
				AnalyticsParameterPrice: item.price
			])
		}
		itemsProduct.append([AnalyticsParameterQuantity: itemsProduct.count])

		var purchaseParams: [String: Any] = [
			AnalyticsParameterTransactionID: order.number,
			AnalyticsParameterCurrency: currency,
			AnalyticsParameterValue: order.totalPrice,
			"payment_type": order.paymentInfo.title,
			"delivery_type": order.deliveryInfo.title
		]

		purchaseParams[AnalyticsParameterItems] = [itemsProduct]
		Analytics.logEvent(AnalyticsEventPurchase, parameters: purchaseParams)

		var purchaseParams2: [String: Any] = [
			AnalyticsParameterTransactionID: order.number,
			AnalyticsParameterCurrency: currency,
			AnalyticsParameterValue: order.totalPrice
		]

		purchaseParams2[AnalyticsParameterItems] = [itemsProduct]

		Analytics.logEvent(AnalyticsEventPurchase, parameters: purchaseParams2)
		
		broadcastAdTrackingToFacebook()
	}
  
  func logAutoLogout(appVersion: String, appName: String, request: String, date: Date, method: String, statusFromServer: Int, headers: [String: String]) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YYYY HH:mm:ss.SSS"

    let fbParams: [AppEvents.ParameterName: Any] = [
      AppEvents.ParameterName(rawValue: "app_version_code"): appVersion,
      AppEvents.ParameterName(rawValue: "app_version_name"): appName,
      AppEvents.ParameterName(rawValue: "request"): request,
      AppEvents.ParameterName(rawValue: "method"): method,
      AppEvents.ParameterName(rawValue: "status_from_server"): statusFromServer,
      AppEvents.ParameterName(rawValue: "headers"): headers,
      AppEvents.ParameterName(rawValue: "time"): dateFormatter.string(from: date),
      AppEvents.ParameterName(rawValue: "platform"): "iOS"
    ]

    AppEvents.shared.logEvent(AppEvents.Name(rawValue: "auto_logout"), parameters: fbParams)

    let params: [String: Any] = [
      "app_version_code": appVersion,
      "app_version_name": appName,
      "request": request,
      "method": method,
      "status_from_server": statusFromServer,
      "headers": headers,
      "time": dateFormatter.string(from: date),
      "platform": "iOS"
    ]

    Analytics.logEvent("auto_logout", parameters: params)
    broadcastAdTrackingToFacebook()
  }
  
  func logSignUp() {
    let params = ["method": "phone"]
    Analytics.logEvent("sign_up", parameters: params)

    AppEvents.shared.logEvent(.completedRegistration, parameters: [AppEvents.ParameterName.registrationMethod: "phone"])
    broadcastAdTrackingToFacebook()
    AdjustAnalyticsService.logSignUp()
  }
  
  func logOpenDiscountCart() {
    Analytics.logEvent("open_discont_cart", parameters: [:])
  }
  
  func logProfileStatus(isFull: Bool) {
    let params = ["isFull": isFull]
    Analytics.logEvent("profile_status", parameters: params)
  }
  
  func logLogin() {
    let params = ["method": "phone"]
    Analytics.logEvent("login", parameters: params)
    AdjustAnalyticsService.logSignIn()
  }
  
  func logUniversalLinkEvent(urlPath: String) {
    
    var params = getQueryItems(urlPath)
    params = params.filter { key, value in
      return !(key.contains("adj_") || key.contains("adjust_"))
    }
    defaults.setValue(params, forKey: deepLinkEventParameters)

    Analytics.logEvent("first_client_open", parameters: params)
  }
    
    func logUniversalLinkEvent(data: [String: Any]) {
      defaults.setValue(data, forKey: deepLinkEventParameters)
            
      Analytics.logEvent("first_client_open", parameters: data)
    }
    
  func logSearch(search: String, isFound: Bool) {
    let params = ["search_term": search]
    Analytics.logEvent("search", parameters: params)

    RetenoAnalyticsService.logSearch(search, isFound: isFound)
    
  }
  
  func logFirstLaunch() {
    SKAdNetwork.registerAppForAdNetworkAttribution()
  }
  
  func logSearchResults(search: String) {
    let params = ["search_term": search]
    Analytics.logEvent("view_search_results", parameters: params)
  }
  
  func logViewItem(itemId: String) {
    let params = ["item_id": itemId]
    Analytics.logEvent("view_item", parameters: params)
  }
  
  func logViewItemList(itemCategory: Int) {
    let params = ["item_category": itemCategory]
    Analytics.logEvent("view_item_list", parameters: params)
  }
  
  func logViewCart(items: [Int], value: Decimal, currency: String = "UAH") {
    let params: [String: Any] = [
      "items": items,
      "value": value,
      "currency": currency]
    Analytics.logEvent("view_cart", parameters: params)
  }
  
  func logRemoveFromCart(items: [Int], value: Decimal, currency: String = "UAH") {
    let params: [String: Any] = [
      "items": items,
      "value": value,
      "currency": currency]
    Analytics.logEvent("remove_from_cart", parameters: params)
  }
  
  func filterWasOpened() {
    AppEvents.shared.logEvent(AppEvents.Name(rawValue: "search_filter_open"), parameters: [:])
    Analytics.logEvent("search_filter_open", parameters: [:])
    broadcastAdTrackingToFacebook()
  }
  
  func filterWasApplied() {
    AppEvents.shared.logEvent(AppEvents.Name(rawValue: "search_filter_open"), parameters: [:])
    broadcastAdTrackingToFacebook()
    Analytics.logEvent("search_filter_done", parameters: [:])
  }
  
  func broadcastAdTrackingToFacebook() {
//
//    if #available(iOS 14.0, *) {
//      let permissionGranted = AdvertisingService.shared.getTrackingPermissionState()
//
//      Settings.shared.isAdvertiserTrackingEnabled = permissionGranted
//    }
  }
  
  // MARK: Checkout & Wishlist
  
  func logAddToWithlist(productSKU: String) {
    Analytics.logEvent("add_to_wishlist", parameters: ["item_id": productSKU])
  }
  
  func logViewWishlist() {
    Analytics.logEvent("view_wishlist", parameters: nil)
  }
  
  func logShareProduct(productSKU: String) {
    Analytics.logEvent("item_share", parameters: ["item_share": productSKU])
  }
  
  func logShippingInfo(shippingCode: String) {
    Analytics.logEvent("add_shipping_info", parameters: ["shipping_tier": shippingCode])
  }
  
  func logAddPaymentInfo(paymentCode: String, months: Int?) {
    
    let params: [String: Any] = {
      
      var result = [String: Any]()
      
      result["payment_type"] = paymentCode
      
      if let months = months {
        result["months_credit"] = months
      }
      
      return result
    }()
    
    Analytics.logEvent("add_payment_info", parameters: params)
  }
  
  func logCreditBuyButtonTapped() {
    Analytics.logEvent("button_credit_in_card", parameters: nil)
  }
  
  func logAddToCartWithCredit(bankCode: String, months: Int) {
    
    let params: [String: Any] = ["type_credit": bankCode,
                                 "months_credit": months]
    
    Analytics.logEvent("select_type_credit_in_card", parameters: params)
  }
  
  // MARK: Profile Form Events
  func trackProfileFormOpened() {
    Analytics.logEvent("open_anketa_auth", parameters: [:])
  }
  
  func trackProfileFormClosed() {
    Analytics.logEvent("close_anketa_auth", parameters: [:])
  }
  
  func trackProfileFormSaved() {
    Analytics.logEvent("save_anketa_auth", parameters: [:])
  }

  // MARK: Discount Hint
  func trackDiscountHintAppearing() {
    Analytics.logEvent("open_discount_info_listing", parameters: [:])
  }

  func trackDiscountHintCloaseAction() {
    Analytics.logEvent("close_discount_info_listing", parameters: [:])
  }

  func trackDiscountHintAuthAction() {
    Analytics.logEvent("click_auth_disc_info_listing", parameters: [:])
  }
}

// ESPUTNIK ANALYTICS EVENTS
extension EventService {
  private enum CustomFieldsKeys {
    static let dateOfBirth = "PERSONAL.DATE_OF_BIRTH"
    static let ukrzolotoCard = "IDKEYS.CARDUKRZOLOTO"
    static let gender = "PERSONAL.GENDER"
    static let websiteID = "IDKEYS.WEBSITEUZID"
    static let useMobileApp = "LOYALTY.UZMOBAPP"
    static let discountLevel = "LOYALTY.UZDISCOUNTLEVEL"
  }

  private enum CustomFieldsMobileAppUsage {
    static let useMobileApp = "1"
    static let notUseMobileApp = "0"
  }

  private enum CustomFieldsGender {
    static let male = "ч"
    static let female = "ж"
  }

  private enum UserDefaultsKeys {
    static let isUserRegistered = "isUserRegistered"
  }

  func tryUpdateUserInformation() {
    ProfileService.shared.getProfile { _ in }
  }

  func updateUserInformation(_ user: User, isForceUpdate: Bool) {
    if !isUserRegistered || isForceUpdate {
      Reteno.updateUserAttributes(
        externalUserId: user.phone,
        userAttributes: getUserAttributesFrom(user))

      self.markUserAsRegistered()
    }
  }
  
  private var isUserRegistered: Bool {
    let isUserRegisteredBoolValue = self.defaults.bool(forKey: UserDefaultsKeys.isUserRegistered)

    return isUserRegisteredBoolValue
  }

  private func markUserAsRegistered() {
    self.defaults.setValue(true, forKey: UserDefaultsKeys.isUserRegistered)
  }

  func markUserAsUnregistered() {
    self.defaults.setValue(false, forKey: UserDefaultsKeys.isUserRegistered)
  }

  private func getUserAttributesFrom(_ user: User) -> UserAttributes {
    return UserAttributes(
      phone: user.phone,
      email: user.email,
      firstName: user.name,
      lastName: user.surname,
      fields: getCustomFieldsFrom(user))
  }

  private func getCustomFieldsFrom(_ user: User) -> [UserCustomField] {
    var userCustomFields = [UserCustomField]()

    userCustomFields.append(
      UserCustomField(key: CustomFieldsKeys.websiteID, value: String(user.id))
    )

    userCustomFields.append(
      UserCustomField(key: CustomFieldsKeys.useMobileApp, value: CustomFieldsMobileAppUsage.useMobileApp)
    )

    if let birthday = user.birthday {
      userCustomFields.append(UserCustomField(key: CustomFieldsKeys.dateOfBirth, value: getFormattedDateOfBirthFrom(birthday)))
    }

    if let discountCard = user.discountCard {
      userCustomFields.append(UserCustomField(key: CustomFieldsKeys.ukrzolotoCard, value: discountCard.cardNumber))
      userCustomFields.append(UserCustomField(key: CustomFieldsKeys.discountLevel, value: String(discountCard.goldDiscount)))
    }

    if user.gender != .undefined {
      userCustomFields.append(UserCustomField(key: CustomFieldsKeys.gender, value: getGenderValueFrom(user)))
    }

    return userCustomFields
  }

  private func getFormattedDateOfBirthFrom(_ birthday: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"

    return dateFormatter.string(from: birthday)
  }

  private func getGenderValueFrom(_ user: User) -> String {
    if user.gender == .male {
      return CustomFieldsGender.male
    } else {
      return CustomFieldsGender.female
    }
  }
  
  func getQueryItems(_ urlString: String) -> [String: String] {
    var queryItems: [String: String] = [:]
    let components: NSURLComponents? = getURLComonents(urlString)
    for item in components?.queryItems ?? [] {
      queryItems[item.name] = item.value?.removingPercentEncoding
    }
    return queryItems
  }
  
  func getURLComonents(_ urlString: String?) -> NSURLComponents? {
      var components: NSURLComponents?
      let linkUrl = URL(string: urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
      if let linkUrl = linkUrl {
          components = NSURLComponents(url: linkUrl, resolvingAgainstBaseURL: true)
      }
      return components
  }
}

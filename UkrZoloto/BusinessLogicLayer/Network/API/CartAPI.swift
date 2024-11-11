//
//  CartAPI.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import Alamofire

class CartAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = CartAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let cart = "/cart"
    static func cart(_ id: Int) -> String {
      return "/cart/\(id)"
    }
    
    static let deliveries = "/order/delivery"
    static func deliveryDetails(_ code: String) -> String {
      return "/order/delivery/" + code
    }
    
    static func payments(paymentCode: String) -> String {
      return "/order/payment/" + paymentCode
    }
    
    static let createOrder = "/order"
    
    static func promocode(_ promocode: String) -> String {
      return "/order/checkPromocode/\(promocode)"
    }
    static let promotionalbonuses = "/user/get_marketing_bonus"
    
    static let calculate = "/cart/calculate"
    
    static func credit(variantId: Int) -> String {
     return "/credit/\(variantId)"
    }
  }
  
  // MARK: - Cart
  func getCart(completion: @escaping (_ result: Result<Cart?>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.cart,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let cart = Cart(json: data)
                        completion(.success(cart))
                      }
    }
  }
  
  func addToCart(
    variantId: Int,
		exchange: ExtraServiceOption? = nil,
    completion: @escaping (_ result: Result<Cart>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
			completion(.failure(ServerError.noInternetConnection))
			return
		}
			var params : [String : Any] = [:]
			if let exchange = exchange {
				let exchangeOptions = [[NetworkRequestKey.Cart.code : exchange.code]]
				let options: [String : Any] = [NetworkRequestKey.Cart.code : NetworkRequestKey.Cart.exchange,
											 NetworkRequestKey.Cart.options : exchangeOptions]
				params = [NetworkRequestKey.Cart.variantId: variantId,
				NetworkRequestKey.Cart.options: [options]]
			} else
			{
				params = [
				NetworkRequestKey.Cart.variantId: variantId,
				NetworkRequestKey.Cart.options: []]
			}

			
    alamofireRequest(endpoint: Endpoint.cart,
                     method: .post,
                     parameters: params) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse, showDebugInfo: true)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let cart = Cart(json: data) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        completion(.success(cart))
												debugPrint(data)
                      }
    }
  }
  
  func removeFromCart(variantId: Int, completion: @escaping (_ result: Result<Cart>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.cart(variantId),
                     method: .delete,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let cart = Cart(json: data) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        completion(.success(cart))
                      }
    }
  }
  
  // MARK: - Delivery
  func getDeliveries(completion: @escaping (_ result: Result<[DeliveryMethod]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.deliveries,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let deliveries = data.arrayValue.compactMap { DeliveryMethod(json: $0) }
                        completion(.success(deliveries))
                      }
    }
  }
  
  func getLocations(for deliveryCode: String,
                    completion: @escaping (_ result: Result<[Location]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    alamofireRequest(endpoint: Endpoint.deliveryDetails(deliveryCode),
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let locations = data[NetworkResponseKey.Delivery.locations].arrayValue.compactMap { Location(json: $0) }
                        completion(.success(locations))
                      }
    }
  }
  
  func getSublocations(for deliveryCode: String,
                       locationId: Int,
                       completion: @escaping (_ result: Result<[Location]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    alamofireRequest(endpoint: Endpoint.deliveryDetails(deliveryCode),
                     method: .get,
                     parameters: [NetworkRequestKey.Cart.locationId: locationId]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let locations = data[NetworkResponseKey.Delivery.subLocations].arrayValue.compactMap { Location(json: $0) }
                        completion(.success(locations))
                      }
    }
  }
  
  // MARK: - PaymentMethods
  
  func getCreditOptions(for variantId: Int, completion: @escaping ((Result<[CreditOption]>) -> ())) {
    
    alamofireRequest(endpoint: Endpoint.credit(variantId: variantId),
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
      
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      
      switch parsedResult {
      case .failure(let error):
        print(error)
        
      case .success(let json):
                
        guard let array = json[NetworkResponseKey.Credits.creditList].array else { return }
        let options = array.compactMap({ CreditOption(json: $0)})
        
        completion(.success(options))
      }
    }
  }
  
  func getPaymentMethods(for paymentCode: String,
                         completion: @escaping (_ result: Result<DeliveryMethod>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.payments(paymentCode: paymentCode),
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let deliveryMethod = DeliveryMethod(json: data) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        completion(.success(deliveryMethod))
                      }
    }
  }
  
  // MARK: - Order
  func createOrder(recipient: Recipient,
                   delivery: DeliveryMethod,
                   payment: PaymentMethod,
                   promocode: String?,
                   bonusesDiscount: BonusesDiscount?,
                   comment: String?,
                   appInstanceId: String,
									 sessionId: String,
                   completion: @escaping (_ result: Result<(Order, UserID?)>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    let params = getOrderParameters(for: recipient,
                                    delivery: delivery,
                                    payment: payment,
                                    promocode: promocode,
                                    bonusesDiscount: bonusesDiscount,
                                    appInstanceId: appInstanceId,
																		comment: comment, 
																		sessionId: sessionId)
    alamofireRequest(endpoint: Endpoint.createOrder,
                     method: .post,
                     parameters: params) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let order = Order(json: data) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        let userId = data[NetworkResponseKey.Auth.userId].int
                        completion(.success((order, userId)))
                      }
    }
  }
  
  func sendPromocode(promocode: String, completion: @escaping (_ result: Result<PromocodeResponse>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    alamofireRequest(endpoint: Endpoint.promocode(promocode).escapingCyrillic(),
                     method: .post,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        guard let promocodeResponse = PromocodeResponse(json: data) else {
          completion(.failure(ServerError.unknown))
          return
        }
        completion(.success(promocodeResponse))
      }
    }
  }
  
  func calculateCart(completion: @escaping (_ result: Result<CartPriceDetails>) -> Void) {
    
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.calculate,
                     method: .post,
										 parameters: [:]) { [weak self] dataResponse in
			if let data = dataResponse.data, let string = String(data: data, encoding: String.Encoding.utf8) {
				print("clear calculate response", string)
			}
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        guard let priceDetails = CartPriceDetails(json: data) else {
          completion(.failure(ServerError.unknown))
          return
        }
        completion(.success(priceDetails))
      }
    }
  }
  
  func getPriceFor(promocode: String?,
                   bonuses: Int,
                   marketingBonuses: Int,
                   paymentCode: Any,
                   completion: @escaping (_ result: Result<CartPriceDetails>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params = getPriceParameters(promocode: promocode,
                                    bonuses: bonuses,
                                    marketingBonuses: marketingBonuses,
                                    paymentCode: paymentCode)
    alamofireRequest(endpoint: Endpoint.calculate,
                     method: .post,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        guard let priceDetails = CartPriceDetails(json: data) else {
          completion(.failure(ServerError.unknown))
          return
        }
        completion(.success(priceDetails))
      }
    }
  }
  
  func getPromoBonuses(completion: @escaping (_ result: Result<Int>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    alamofireRequest(endpoint: Endpoint.promotionalbonuses,
                     method: HTTPMethod.post,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        guard let amountBonus = data[NetworkResponseKey.PromotionalBonuses.amountBonus].int else {
          completion(.failure(ServerError.unknown))
          return
        }
        completion(.success(amountBonus))
      }
    }
  }

  
  // MARK: - Private methods
  func getOrderParameters(for recipient: Recipient,
                          delivery: DeliveryMethod,
                          payment: PaymentMethod,
                          promocode: String?,
                          bonusesDiscount: BonusesDiscount?,
                          appInstanceId: String,
                          comment: String?,
													sessionId: String) -> [String: Any] {
    let recipientAttr: [String: Any] = [
      NetworkRequestKey.Order.Profile.name: recipient.name,
      NetworkRequestKey.Order.Profile.surname: recipient.surname,
      NetworkRequestKey.Order.Profile.telephoneNumber: recipient.phone,
      NetworkRequestKey.Order.Profile.email: recipient.email,
      NetworkRequestKey.Order.Profile.shippingMethod: delivery.code
    ]
    
    var deliveryAttr: [String: Any] = [
      NetworkRequestKey.Order.Delivery.type: delivery.code
    ]
    var deliveryData: [String: Any] = [String: Any]()
    
    switch delivery.type {
    case .location(let location, let sublocation):
      deliveryData[NetworkRequestKey.Order.Delivery.city] = location?.id
      deliveryData[NetworkRequestKey.Order.Delivery.warehouse] = sublocation?.id
    case .address(let location, _, let address):
      let deliveryAddress = StringComposer.shared.getAddressStringFrom(cityName: location?.title, address: address)

      deliveryData[NetworkRequestKey.Order.Delivery.deliveryAddress] = deliveryAddress
    }
    deliveryAttr[NetworkRequestKey.Order.Delivery.data] = deliveryData
    
    var paymentAttr: [String: Any] = payment.nestedRepresentation()
    
    if let comment = comment {
      paymentAttr[NetworkRequestKey.Order.Payment.comment] = comment
    }
    
    var bonusesAttr: [String: Any] = [:]
    if let bonusesDiscount = bonusesDiscount {
      bonusesAttr = [
        NetworkRequestKey.Order.Bonuses.sumToPayFromBonus: bonusesDiscount.sumToPayFromBonus,
        NetworkRequestKey.Order.Bonuses.marketingBonus: bonusesDiscount.marketingBonus
      ]
    }
    
    var attr: [String: Any] = [
      NetworkRequestKey.Order.Profile.profile: recipientAttr,
      NetworkRequestKey.Order.Delivery.delivery: deliveryAttr,
      NetworkRequestKey.Order.Payment.payment: paymentAttr,
      NetworkRequestKey.Order.Bonuses.bonus: bonusesAttr,
      NetworkRequestKey.Order.doNotCallBack: false
    ]
    
    if let promocode = promocode {
      attr[NetworkRequestKey.Order.coupon] = promocode
    }

    attr[NetworkRequestKey.Order.Profile.platform] = "ios"
    attr[NetworkRequestKey.Order.Profile.appInstanceId] = appInstanceId
		attr[NetworkRequestKey.Order.Profile.sessionId] = sessionId

    return attr
  }
  
  private func getPriceParameters(promocode: String?,
                                  bonuses: Int,
                                  marketingBonuses: Int,
                                  paymentCode: Any) -> [String: Any] {
    var params: [String: Any] = [
      NetworkRequestKey.Order.Price.bonus: bonuses,
      NetworkRequestKey.Order.Price.marketingBonus: marketingBonuses,
      NetworkRequestKey.Order.Price.payment: paymentCode
    ]
    if let promocode = promocode {
      params[NetworkRequestKey.Order.Price.coupon] = promocode
    }
    
    return params
  }
}


//
//  CartService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class CartService {
  
  // MARK: - Public variables
  static let shared = CartService()
  
  private(set) var cart: Cart? {
	 didSet {
		 cartWasUpdated()
	 }
 }
	
	private(set) var priceDetails: CartPriceDetails?
	private var services: [String: [ExtraServiceItem]] = [:]
	
	private var preselectedExchangeVariants: [Int: ExchangeItem] = [:]
  
  private typealias VariantId = Int
  
  private(set) var selectedCreditOption: CreditDTO?
  
  var selectedPaymentMethodCode: String? {
    return selectedCreditOption?.bank.rawValue
  }
	
	var cartDidUpdated: ((Cart?) -> Void)?

  // MARK: - Life cycle
  private init() { }

  // MARK: - Interface

  func getCart(completion: @escaping (_ result: Result<Cart?>) -> Void) {
    CartAPI.shared.getCart { result in
      switch result {
      case .success(let cart):
				self.updateCart(newCart: cart)
      case .failure:
        break
      }
      completion(result)
    }
  }
  
  func addToCartVariantBy(variantId: Int, sku: String, exchange: ExtraServiceOption? = nil, completion: @escaping (_ result: Result<Cart>) -> Void) {
    CartAPI.shared.addToCart(variantId: variantId, exchange: exchange) { result in
      switch result {
      case .success(let cart):
				self.updateCart(newCart: cart)
        RetenoAnalyticsService.logEditCart(cart)

        self.addToCartVariantWith(sku: sku)

        completion(.success(cart))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func addToCartWithCreditPayment(creditDTO: CreditDTO, completion: @escaping (_ result: Result<Cart>) -> Void) {
        
    CartAPI.shared.addToCart(variantId: creditDTO.variantId) { result in
      
      switch result {
      case .success(let cart):
				self.updateCart(newCart: cart)
        self.selectedCreditOption = creditDTO

        RetenoAnalyticsService.logEditCart(cart)

        completion(.success(cart))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func clearCreditData() {
    selectedCreditOption = nil
  }
  
  func removeFromCart(by variantId: Int, sku: String, completion: @escaping (_ result: Result<Cart>) -> Void) {
    CartAPI.shared.removeFromCart(variantId: variantId) { result in
      switch result {
      case .success(let cart):
				self.updateCart(newCart: cart)
        RetenoAnalyticsService.logEditCart(cart)

        self.removeFromCartVariantWith(sku: sku)

        completion(.success(cart))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func getDeliveries(completion: @escaping (_ result: Result<[DeliveryMethod]>) -> Void) {
    CartAPI.shared.getDeliveries(completion: completion)
  }
  
  func getLocations(for deliveryCode: String,
                    location: Location?,
                    completion: @escaping (_ result: Result<[Location]>) -> Void) {
    if let location = location {
      CartAPI.shared.getSublocations(for: deliveryCode,
                                     locationId: location.id,
                                     completion: completion)
    } else {
      CartAPI.shared.getLocations(for: deliveryCode,
                                  completion: completion)
    }
  }
  
  func getPaymentMethods(for deliveryCode: String,
                         completion: @escaping (_ result: Result<[PaymentMethod]>) -> Void) {
    CartAPI.shared.getPaymentMethods(for: deliveryCode) { result in
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let deliveryMethod):
        let paymentMethods = deliveryMethod.paymentMethods
        paymentMethods.forEach { $0.deliverySummary = deliveryMethod.description }
        completion(.success(paymentMethods))
      }
    }
  }
  
  func createOrder(recipient: Recipient,
                   delivery: DeliveryMethod,
                   payment: PaymentMethod,
                   promocode: String?,
                   bonusesDiscount: BonusesDiscount?,
                   comment: String?,
                   appInstanceId: String,
									 sessionId: String,
                   completion: @escaping (_ result: Result<Order>) -> Void) {
    CartAPI.shared.createOrder(
      recipient: recipient,
      delivery: delivery,
      payment: payment,
      promocode: promocode,
      bonusesDiscount: bonusesDiscount,
      comment: comment,
			appInstanceId: appInstanceId, 
			sessionId: sessionId) { result in
      switch result {
      case .success(let (order, userId)):
        if let userId = userId {
          ProfileService.shared.updateUserId(userId)
        }
				EventService.shared.logPurchase(id: order.number,
																				price: order.totalPrice,
																				userId: ProfileService.shared.userId ?? -1)
        completion(.success(order))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func sendPromocode(promocode: String, completion: @escaping (_ result: Result<PromocodeResponse>) -> Void) {
    CartAPI.shared.sendPromocode(promocode: promocode) { result in
      completion(result)
    }
  }
  
  func getPromoBonuses(completion: @escaping (_ result: Result<Int>) -> Void) {
    CartAPI.shared.getPromoBonuses { result in
      completion(result)
    }
  }
  
	func calculateCart(completion: @escaping (_ result: Result<CartPriceDetails>) -> Void) {
		CartAPI.shared.calculateCart { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self else { return }
				
				switch result {
				case .failure(_):
					completion(result)
				case .success(let model):
					self.priceDetails = model
					if model.changedResponse ?? false {
						self.services = [:]
					}
					for item in model.goods {
						self.services[item.sku] = item.services
					}
					self.updateCart(newCart: self.cart)
					completion(result)
				}
			}
		}
	}
  
  func getPriceFor(promocode: String?,
                   bonuses: Int,
                   marketingBonuses: Int,
                   paymentCode: Any,
                   completion: @escaping (_ result: Result<CartPriceDetails>) -> Void) {
    
    CartAPI.shared.getPriceFor(promocode: promocode,
                               bonuses: bonuses,
                               marketingBonuses: marketingBonuses,
                               paymentCode: paymentCode,
                               completion: completion)
  }
  
  func getCreditOptions(for variantId: Int, completion: @escaping ((Result<[CreditOption]>) -> Void )) {
    CartAPI.shared.getCreditOptions(for: variantId, completion: completion)
  }
	
	func setNewPreselectedVariant(for item: CartItem, variant: ExchangeItem, forced: Bool = false) {
		if let cartIndex = cart?.cartItems.firstIndex(where: {$0.id == item.id}), let id = cart?.cartItems[cartIndex].id {
			if variant != .none {
				cart?.cartItems[cartIndex].preselectedExchangeVariant = variant
				if let item = cart?.cartItems[cartIndex] {
					for service in item.services ?? [] {
						for option in service.options {
							if option.selected, option.code != variant.rawValue, !forced {
								return
							}
						}
					}
				}
				self.preselectedExchangeVariants[id] = variant
			}
		}
	}
	
	func updateCart(newCart: Cart?) {
		guard var newCart = newCart, !newCart.cartItems.isEmpty else {
			self.cart = newCart
			return
		}
		for index in 0..<newCart.cartItems.count {
			newCart.cartItems[index].preselectedExchangeVariant = self.preselectedExchangeVariants[newCart.cartItems[index].id] ?? .sixMonths
			newCart.cartItems[index].services = self.services[newCart.cartItems[index].sku]
		}
		self.cart = newCart
	}
  
  // MARK: - Private methods
  @objc
  private func cartWasUpdated() {
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: .cartWasUpdated,
                                      object: nil)
			self.cartDidUpdated?(self.cart)
    }
  }

  // MARK: - Product Variants in Cart
  private enum Consts {
    static let variantInCartKey = "variantInCartKey"
  }

  private func addToCartVariantWith(sku: String) {
    var existedVariants = variantsInCart()
    existedVariants.removeAll(where: { $0 == sku })
    existedVariants.append(sku)
    UserDefaults.standard.set(existedVariants, forKey: Consts.variantInCartKey)
  }

  private func removeFromCartVariantWith(sku: String) {
    var existedVariants = variantsInCart()
    existedVariants.removeAll(where: { $0 == sku })
    UserDefaults.standard.set(existedVariants, forKey: Consts.variantInCartKey)
  }

  private func variantsInCart() -> [String] {
    if let array = UserDefaults.standard.array(forKey: Consts.variantInCartKey) as? [String] {
      return array
    }
    return []
  }

  func removeAllVariantAndCreditsFromCart() {
		_ = UserDefaults.standard.dictionaryRepresentation().keys

    cart = nil
    UserDefaults.standard.removeObject(forKey: Consts.variantInCartKey)
  }
}

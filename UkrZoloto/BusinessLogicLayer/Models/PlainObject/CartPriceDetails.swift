//
//  CartPriceDetails.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 08.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CartPriceDetails: Equatable {
  
  /** `true` if promocode was correctly applied, otherwise - `false` (*promocodHave* on server) */
  let promocodeWasApplied: Bool
  /** `true` if we should show personal bonuses block, otherwise - `false` (*statusBonus* on server) */
  let canApplyPersonalBonuses: Bool
  /** Amount of available action (marketing) bonuses (*amountBonus* on server) */
  let availableActionBonus: Int
  /** Full price without any discount (*amountFullPrice* on server) */
  let fullPrice: Decimal
  /** discount from catalog (diff between new and old prices for all goods) (*amountCatalogDiscount* on server) */
  let catalogDiscount: Decimal
  /** amount of discount from profile (*amountDiscont* on server) */
  let personalDiscount: Decimal
  /** discount from promocode (*amountPromo* on server) */
  let promoDiscount: Decimal
  /** amount of applied personal bonuses (*appliedBonus* on server) */
  let personalBonuses: Decimal
  /** amount of applied action (marketing) bonuses (*appliedPromoBonus* on server) */
  let actionBonuses: Decimal
  /** total price with all discounts, bonuses, etc. (except delivery price) (*amountOrderWithDiscounts* on server) */
  let totalPrice: Decimal?
  
  let orderAmount: Decimal
  
  let birthdayDiscountAmount: Decimal
  
  let cashback: Decimal
  
  let marketingDiscountAmount: Decimal
  
  let statusPromoBonus: Bool
	
	let amountExchange: Decimal
  
  private(set) var totalPriceForCredits: Decimal?
  
  let promoBonus: Decimal
	
	let goods: [GoodsItem]
  
  /** Error after applying promocode*/
  let error: ServerError?
	
	let changedResponse: Bool?
  
  var priceWithCatalogDiscount: Decimal {
    return fullPrice - catalogDiscount
  }
  
  static func == (lhs: CartPriceDetails, rhs: CartPriceDetails) -> Bool {
    
    guard let lhs_total = lhs.totalPrice,
          let rhs_total = rhs.totalPrice,
          lhs_total == rhs_total else { return false }
    
    return lhs.orderAmount == rhs.orderAmount
  }
  
  init?(json: JSON) {
    let totals = json[NetworkResponseKey.CartPriceDetails.totals]
    guard !totals.isEmpty else {
      return nil
    }

    promocodeWasApplied = json[NetworkResponseKey.CartPriceDetails.promocodHave].boolValue
    availableActionBonus = json[NetworkResponseKey.CartPriceDetails.amountBonus].intValue
    
    fullPrice = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountFullPrice].doubleValue)
    catalogDiscount = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountCatalogDiscount].doubleValue)
    personalDiscount = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountDiscont].doubleValue)
    promoDiscount = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountPromo].doubleValue)
    personalBonuses = Decimal(totals[NetworkResponseKey.CartPriceDetails.appliedBonus].intValue)
    actionBonuses = Decimal(totals[NetworkResponseKey.CartPriceDetails.appliedPromoBonus].intValue)
		orderAmount = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountOrder].doubleValue)
    totalPrice = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountOrderWithDiscounts].doubleValue)
    cashback = Decimal(totals[NetworkResponseKey.CartPriceDetails.cashback].doubleValue)
    marketingDiscountAmount = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountMarketingDiscount].doubleValue)
    birthdayDiscountAmount = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountBirthdayDiscont].doubleValue)
		amountExchange = Decimal(totals[NetworkResponseKey.CartPriceDetails.amountExchange].doubleValue)
    promoBonus = Decimal(totals[NetworkResponseKey.CartPriceDetails.promoBonus].intValue)
    
    statusPromoBonus = json[NetworkResponseKey.CartPriceDetails.statusPromoBonus].boolValue
    canApplyPersonalBonuses = json[NetworkResponseKey.CartPriceDetails.statusBonus].boolValue
		
		debugPrint(json, "exchange models json")
		
		goods = json[NetworkResponseKey.CartPriceDetails.goods].arrayValue.compactMap { GoodsItem(json: $0) }

    if let creditAmount = totals[NetworkResponseKey.CartPriceDetails.amountOrderForCredits].double {
      totalPriceForCredits = Decimal(creditAmount)
    }
    
    error = ServerError(json: json[NetworkResponseKey.CartPriceDetails.error])
		changedResponse = json[NetworkResponseKey.CartPriceDetails.defaultKey].bool
  }
  
  init(promocodeWasApplied: Bool,
       canApplyPersonalBonuses: Bool,
       availableActionBonus: Int,
       fullPrice: Decimal,
       catalogDiscount: Decimal,
       personalDiscount: Decimal,
       promoDiscount: Decimal,
       personalBonuses: Decimal,
       actionBonuses: Decimal,
       totalPrice: Decimal,
       cashback: Decimal,
       marketingDiscountAmount: Decimal,
       birthdayDiscountAmount: Decimal,
       orderAmount: Decimal,
       promoBonus: Decimal,
       statusPromoBonus: Bool,
			 amountExchange: Decimal,
       error: ServerError?) {
    
    self.promocodeWasApplied = promocodeWasApplied
    self.canApplyPersonalBonuses = canApplyPersonalBonuses
    self.availableActionBonus = availableActionBonus
    self.fullPrice = fullPrice
    self.catalogDiscount = catalogDiscount
    self.personalDiscount = personalDiscount
    self.promoDiscount = promoDiscount
    self.personalBonuses = personalBonuses
    self.actionBonuses = actionBonuses
    self.totalPrice = totalPrice
    self.marketingDiscountAmount = marketingDiscountAmount
    self.birthdayDiscountAmount = birthdayDiscountAmount
    self.cashback = cashback
    self.error = error
    self.orderAmount = orderAmount
    self.promoBonus = promoBonus
    self.statusPromoBonus = statusPromoBonus
		self.amountExchange = amountExchange
		self.goods = []
		self.changedResponse = false
  }
  
  init(totalPrice: Decimal) {
    
    self.init(promocodeWasApplied: false,
              canApplyPersonalBonuses: false,
              availableActionBonus: 0,
              fullPrice: 0,
              catalogDiscount: 0,
              personalDiscount: 0,
              promoDiscount: 0,
              personalBonuses: 0,
              actionBonuses: 0,
              totalPrice: totalPrice,
              cashback: 0,
              marketingDiscountAmount: 0,
              birthdayDiscountAmount: 0,
              orderAmount: 0,
              promoBonus: 0,
							statusPromoBonus: false,
							amountExchange: 0,
              error: nil)
  }
}

struct GoodsItem {
	let sku: String
	let services: [ExtraServiceItem]
	init?(json: JSON) {
		guard let sku = json[NetworkResponseKey.CartPriceDetails.artikul].string else {
				return nil
		}
		let sevices = json[NetworkResponseKey.CartPriceDetails.services].arrayValue.compactMap { ExtraServiceItem(json: $0) }
		self.services = sevices
		self.sku = sku
	}
}

struct ExtraServiceItem {
	let code: String
	let options: [ExtraServiceOption]
	
	init?(json: JSON) {
		guard let code = json[NetworkResponseKey.CartPriceDetails.code].string else {
				return nil
		}
		let options = json[NetworkResponseKey.CartPriceDetails.options].arrayValue.compactMap { ExtraServiceOption(json: $0) }
		self.code = code
		self.options = options
	}
}

struct ExtraServiceOption {
	let code: String
	let price: Int
	let selected: Bool
	
	init?(json: JSON) {
		guard let code = json[NetworkResponseKey.CartPriceDetails.code].string,
					let price = json[NetworkResponseKey.CartPriceDetails.price].int,
					let selected = json[NetworkResponseKey.CartPriceDetails.selected].bool else {
				return nil
		}
		self.code = code
		self.price = price
		self.selected = selected
	}
}

enum ExchangeItem: String {
	case sixMonths = "6"
	case nineMonths = "9"
	case none = "-"
}

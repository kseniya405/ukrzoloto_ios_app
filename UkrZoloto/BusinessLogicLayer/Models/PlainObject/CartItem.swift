//
//  CartItem.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CartItem {
  
  let id: Int
  let name: String
  let price: Price
  let imageURL: URL?
  let size: String?
  let productId: Int
  let sku: String
	
  var categoryExternalId: String?
	var preselectedExchangeVariant: ExchangeItem = .sixMonths
	var availableExchangeVariants: [ExchangeItem] = []
	var exchangeOptions: [String: ExtraServiceOption] = [:]
	var services: [ExtraServiceItem]? {
		didSet {
			availableExchangeVariants = []
			for service in services ?? [] {
				for variant in service.options {
					if let item = ExchangeItem(rawValue: variant.code), variant.price != 0 {
						availableExchangeVariants.append(item)
						exchangeOptions[item.rawValue] = variant
					}
				}
			}
			if availableExchangeVariants.isEmpty {
				preselectedExchangeVariant = .none
			}
		}
	}

  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.CartItem.id].int,
      let name = json[NetworkResponseKey.CartItem.name].string,
      let price = Price(json: json[NetworkResponseKey.CartItem.price]),
      let product = json[NetworkResponseKey.CartItem.parentProduct].dictionary,
      let productId = product[NetworkResponseKey.CartItem.id]?.int,
      let sku = json[NetworkResponseKey.CartItem.sku].string else {
        return nil
    }
    self.price = price
    self.id = id
    self.name = name
    let urlString = json[NetworkResponseKey.CartItem.image].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    imageURL = URL(string: urlString ?? "")
    size = json[NetworkResponseKey.CartItem.size].string
    self.productId = productId
    self.sku = sku
    self.categoryExternalId = json[NetworkResponseKey.CartItem.categoryExternalId].int.flatMap(String.init)
		
  }
}

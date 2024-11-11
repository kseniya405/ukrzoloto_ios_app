//
//  Product.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Product {
	
	let id: Int
	let name: String
	let slug: String
	let sku: String
	let isCredit: Bool
	let isAvailable: Bool
	let imagesURL: [URL]
	let image: URL?
	let price: Price
	let quantity: Int
	var isInFavorite: Bool
	let categories: [Category]
	let freeDelivery: FreeDelivery
	
	let description: String?
	let properties: [Property]
	let variants: [Variant]
	let credits: Credits
	let stickers: [Sticker]
	var indicative: Bool
	let displayedCreditIcon: [[String : String?]]?
	
	var hasSize: Bool {
		return !variants.filter { $0.quantity != 0 }.compactMap { $0.size }.isEmpty
	}
	
	var availableVariants: [Variant] {
		variants.filter { $0.quantity != 0 }.filter { $0.size != nil }
	}
	
	init?(json: JSON) {
		guard let id = json[NetworkResponseKey.Product.id].int,
					let name = json[NetworkResponseKey.Product.name].string,
					let slug = json[NetworkResponseKey.Product.slug].string,
					let sku = json[NetworkResponseKey.Product.sku].string,
					let isAvailable = json[NetworkResponseKey.Product.availability].bool,
					let price = Price(json: json[NetworkResponseKey.Product.price]),
					let quantity = json[NetworkResponseKey.Product.quantity].int,
					let isInFavorite = json[NetworkResponseKey.Product.isFavorite].bool else {
			return nil
		}
		self.id = id
		self.name = name
		self.slug = slug
		self.sku = sku
		self.isCredit = json[NetworkResponseKey.Product.isCredit].bool ?? false
		self.isAvailable = isAvailable
		self.imagesURL = json[NetworkResponseKey.Product.images].arrayValue.compactMap {
			URL(string: $0.stringValue.cyrillic())
		}
		self.image = URL(string: json[NetworkResponseKey.Product.image].stringValue.cyrillic())
		self.price = price
		self.quantity = quantity
		self.categories = json[NetworkResponseKey.Product.categories].arrayValue.compactMap { Category(json: $0) }
		self.description = json[NetworkResponseKey.Product.description].string
		self.properties = json[NetworkResponseKey.Product.properties].arrayValue.compactMap { Property(json: $0) }
		self.variants = json[NetworkResponseKey.Product.variants].arrayValue.compactMap { Variant(json: $0) }
		self.freeDelivery = FreeDelivery(json: json[NetworkResponseKey.Product.freeDelivery])
		self.isInFavorite = isInFavorite
		self.credits = Credits(json: json[NetworkResponseKey.Product.credits])
		self.indicative = json[NetworkResponseKey.Product.indicative].bool ?? false
		self.stickers = json[NetworkResponseKey.Product.stickers].arrayValue.compactMap { Sticker(json: $0) }
		self.displayedCreditIcon = json[NetworkResponseKey.Product.credits].dictionaryValue.compactMap { [$0.key : $0.value.string] }
		setIndicative(json: json, categories: self.categories)
		debugPrint(">>>>>> Product json ", json)
	}
	
	private mutating func setIndicative(json: JSON, categories: [Category]) {
		if self.categories.contains(where: { $0.slug == "sertyfikaty"
			|| $0.slug == "sertifikaty"
			|| $0.slug == "podarochnaya-upakovka"
			|| $0.slug == "podarunkova-upakovka"}) {
			self.indicative = true
		}
	}
	
	func shouldHideKnowSize() -> Bool {
		return !self.categories.contains { $0.slug == "koltsa" || $0.slug == "kabluchky" }
	}
}

struct Goods {
	let key: String
	let value: Int
	
	init?(json: JSON) {
		guard
			let key = json["NetworkResponseKey.Product.id"].string,
			let value = json[NetworkResponseKey.Product.name].int else {
			return nil
		}
		
		self.key = key
		self.value = value
	}
}


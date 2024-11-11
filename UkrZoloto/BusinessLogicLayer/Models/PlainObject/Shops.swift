//
//  Shops.swift
//  UkrZoloto
//
//  Created by Kseniia Shkurenko on 18.06.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Shops
struct NewShops {
		let items: [NewShopsItem]?
		let filter: NewFilter?
	  let cities: [NewCity]
		let coordinates: [ShopCoordinates]
	
	init?(json: JSON) {
			self.items = json[NetworkResponseKey.NewShops.items].arrayValue.compactMap { NewShopsItem(json: $0) }
			self.filter = NewFilter(json: json[NetworkResponseKey.NewShops.filter])
			var cities: [NewCity] = []
			let rawCities = json[NetworkResponseKey.NewShops.cities].dictionaryObject as? [String: String]
			for (key, value) in rawCities ?? [:] {
					cities.append(NewCity(id: key, title: value))
			}
			self.cities = cities
			var coordinatesArray: [ShopCoordinates] = []
			let rawCoordinates = json[NetworkResponseKey.NewShops.coordinates].dictionaryObject as? [String: Int] ?? [:]
			for (key, value) in rawCoordinates {
				if let coordinate = key.toCLLocationCoordinate2D() {
					coordinatesArray.append(ShopCoordinates(shopID: value, coordinates: coordinate))
				}
			}
		  self.coordinates = coordinatesArray
	}
}

struct NewCity: Hashable {
		let id, title: String
}

struct ShopCoordinates {
	let shopID: Int
	let coordinates: CLLocationCoordinate2D
}

// MARK: - Filter
struct NewFilter {
		let filterOpen, jeweler: Int?
	
		init?(json: JSON) {
				self.filterOpen = json[NetworkResponseKey.NewFilter.filterOpen].int
				self.jeweler = json[NetworkResponseKey.NewFilter.jeweler].int
		}
}

// MARK: - Item
struct NewShopsItem {
		let id: Int?
		let title: String?
		let image: String?
		let cityName: String?
		let coordinates: CLLocationCoordinate2D?
		let jeweler, temporaryClose: Bool?
		let schedule: NewSchedule?
		let openAt, closedAt: String?

		init?(json: JSON) {
				self.id = json[NetworkResponseKey.NewShopsItem.id].int
				self.title = json[NetworkResponseKey.NewShopsItem.title].string
				self.image = json[NetworkResponseKey.NewShopsItem.image].string
				self.cityName = json[NetworkResponseKey.NewShopsItem.cityName].string
				let coordinatesString = json[NetworkResponseKey.NewShopsItem.coordinates].string ?? ""
				self.coordinates = coordinatesString.toCLLocationCoordinate2D()
				self.jeweler = json[NetworkResponseKey.NewShopsItem.jeweler].bool
				self.temporaryClose = json[NetworkResponseKey.NewShopsItem.temporaryClose].bool
				self.schedule = NewSchedule(json: json[NetworkResponseKey.NewShopsItem.schedule])
				self.openAt = json[NetworkResponseKey.NewShopsItem.openAt].string
				self.closedAt = json[NetworkResponseKey.NewShopsItem.closedAt].string
		}
}

// MARK: - Schedule
struct NewSchedule {
		let monday, tuesday, wednesday, thursday: Day?
		let friday, saturday, sunday: Day?
	
		init?(json: JSON) {
				self.monday = Day(json: json[NetworkResponseKey.NewSchedule.monday])
				self.tuesday = Day(json: json[NetworkResponseKey.NewSchedule.tuesday])
				self.wednesday = Day(json: json[NetworkResponseKey.NewSchedule.wednesday])
				self.thursday = Day(json: json[NetworkResponseKey.NewSchedule.thursday])
				self.friday = Day(json: json[NetworkResponseKey.NewSchedule.friday])
				self.saturday = Day(json: json[NetworkResponseKey.NewSchedule.saturday])
				self.sunday = Day(json: json[NetworkResponseKey.NewSchedule.sunday])
		}
}

// MARK: - Day
struct Day: Codable {
		let dayOpen, closed: Bool?
		let timeRange: String?
		let dayOff: Bool?
	
		init?(json: JSON) {
				self.dayOpen = json[NetworkResponseKey.Day.dayOpen].bool
				self.closed = json[NetworkResponseKey.Day.closed].bool
				self.timeRange = json[NetworkResponseKey.Day.timeRange].string
				self.dayOff = json[NetworkResponseKey.Day.dayOff].bool
		}
}

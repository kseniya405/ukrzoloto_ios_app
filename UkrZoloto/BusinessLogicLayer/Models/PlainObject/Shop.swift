//
//  Shop.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/19/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

enum ShopStatus: String {
  case isOpened = "isOpen"
  case isPickupPoint
  case isTemporarilyСlosed
}

class Shop {
  
  let id: Int
  let address: String
  let schedule: Schedule
  let coordinates: CLLocationCoordinate2D
  let city: City
  let status: ShopStatus
  
  init(id: Int,
       address: String,
       schedule: Schedule,
       coordinates: CLLocationCoordinate2D,
       city: City,
       status: ShopStatus) {
    self.id = id
    self.address = address
    self.schedule = schedule
    self.coordinates = coordinates
    self.city = city
    self.status = status
  }
  
  init?(json: JSON) {
    guard let id = json[NetworkResponseKey.Shop.id].int,
      let address = json[NetworkResponseKey.Shop.address].string,
      let schedule = Schedule(json: json[NetworkResponseKey.Shop.schedule]),
      let lat = json[NetworkResponseKey.Shop.latitude].double,
      let lng = json[NetworkResponseKey.Shop.longitude].double,
      let city = City(json: json[NetworkResponseKey.Shop.city]) else {
        return nil
    }
    self.id = id
    self.address = address
    self.schedule = schedule
    self.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    self.city = city
    status = ShopStatus(rawValue: json[NetworkResponseKey.Shop.status].stringValue) ?? .isOpened
  }
}

struct Schedule {
  let from: String
  let to: String
  
  init(from: String,
       to: String) {
    self.from = from
    self.to = to
  }
  
  init?(json: JSON) {
    guard let from = json[NetworkResponseKey.Schedule.from].string,
      let to = json[NetworkResponseKey.Schedule.to].string else {
        return nil
    }
    self.from = from
    self.to = to
  }
}

//
//  LocationDeliveryViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class LocationDeliveryViewModel {

  // MARK: - Public variables
  let code: String
  let title: String
  let subtitle: String?
  let locationPlaceholder: String
  let sublocationPlaceholder: String
  
  var location: Location?
  var sublocation: Location?
	
	var shop: NewShopsItem?
  
  var isSelected: Bool
  
  init?(delivery: DeliveryMethod,
        locationPlaceholder: String,
        sublocationPlaceholder: String,
        isSelected: Bool) {
    guard case let DeliveryType.location(location, sublocation) = delivery.type else {
      return nil
    }
    code = delivery.code
    title = delivery.title
    subtitle = delivery.description
    self.locationPlaceholder = locationPlaceholder
    self.sublocationPlaceholder = sublocationPlaceholder
    self.location = location
    self.sublocation = sublocation
    self.isSelected = isSelected
  }
}

extension LocationDeliveryViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(code)
  }
  
  static func == (lhs: LocationDeliveryViewModel, rhs: LocationDeliveryViewModel) -> Bool {
    return lhs.code == rhs.code
  }
}

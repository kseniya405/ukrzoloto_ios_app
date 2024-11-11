//
//  AddressDeliveryViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class AddressDeliveryViewModel {

  // MARK: - Public variables
  let id: Int
  let title: String
  let subtitle: String?
  let streetPlaceholder: String
  let housePlaceholder: String
  let apartmentPlaceholder: String
  let code: String

  let locationPlaceholder: String
  var street: String?
  var house: String?
  var apartment: String?

  var location: Location?
  var sublocation: Location?
  
  var isSelected: Bool
  
  init?(delivery: DeliveryMethod,
        streetPlaceholder: String,
        housePlaceholder: String,
        apartmentPlaceholder: String,
        locationPlaceholder: String,
        isSelected: Bool) {
    guard case let DeliveryType.address(location, sublocation, address) = delivery.type else {
      return nil
    }
    id = delivery.id
    code = delivery.code
    title = delivery.title
    subtitle = delivery.description
    self.locationPlaceholder = locationPlaceholder
    self.streetPlaceholder = streetPlaceholder
    self.housePlaceholder = housePlaceholder
    self.apartmentPlaceholder = apartmentPlaceholder
    house = address?.house
    apartment = address?.apartment
    self.isSelected = isSelected
    self.location = location
    self.sublocation = sublocation
  }
}

extension AddressDeliveryViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: AddressDeliveryViewModel, rhs: AddressDeliveryViewModel) -> Bool {
    return lhs.id == rhs.id
  }
}

//
//  AddressViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

struct AddressViewModel {
  
  // MARK: - Public variables
  var street: String?
  var house: String?
  var appartment: String?
  
  // MARK: - Interface
  func isValid() -> Bool {
    return street != nil && house != nil
  }
}

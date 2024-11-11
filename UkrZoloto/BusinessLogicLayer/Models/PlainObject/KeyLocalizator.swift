//
//  KeyLocalizator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 9/11/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

struct KeyLocalizator {

  // MARK: - Public variables
  let localizator: Localizator?
  let key: String
  
  // MARK: - Life cycle
  init(key: String, localizator: Localizator? = Localizator.standard) {
    self.key = key
    self.localizator = localizator
  }
  
  // MARK: - Interface
  func localizedString() -> String {
    return localizator?.localizedString(key) ?? key
  }
}

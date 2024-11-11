//
//  RegexService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

class RegexService {
  // MARK: Singleton
  static let shared = RegexService()
  
  private init() {}
  
  // MARK: - Public functions
  func isValidEmail(_ email: String) -> Bool {
    let regex = NSRegularExpression(Constants.Regex.email)
    let result = regex.matches(email)
    return result
  }
}

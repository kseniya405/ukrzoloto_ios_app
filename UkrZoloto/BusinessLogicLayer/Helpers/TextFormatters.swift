//
//  TextFormatters.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

class TextFormatters {
  
  // MARK: - Life cycle
  private init() { }
  
  static var priceFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.minimumIntegerDigits = 1
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.decimalSeparator = "."
    numberFormatter.roundingMode = .halfUp
    numberFormatter.groupingSize = 3
    numberFormatter.groupingSeparator = " "
    numberFormatter.usesGroupingSeparator = true
    return numberFormatter
  }
}


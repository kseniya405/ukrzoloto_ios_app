//
//  PhoneNumberHelper.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 02.11.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS

class PhoneNumberHelper {

  // MARK: - Public variables
  static let shared = PhoneNumberHelper()
  
  // MARK: - Life cycle
  private init() { }

  // MARK: - Interface
  func getFormatedNumber(from string: String) -> String? {
    var unformattedPhone = string
    if string.first != "+" {
      unformattedPhone = "+" + string
    }
    let phoneUtil = NBPhoneNumberUtil()
    let parsedPhoneNumber = try? phoneUtil.parse(unformattedPhone, defaultRegion: "")
    return try? phoneUtil.format(parsedPhoneNumber, numberFormat: NBEPhoneNumberFormat.INTERNATIONAL)
  }
}

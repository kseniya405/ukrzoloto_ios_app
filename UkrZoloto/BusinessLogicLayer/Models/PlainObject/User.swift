//
//  User.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 10/21/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

struct User {
  
  // MARK: - Public variables
  let id: Int
  var name: String?
  var surname: String?
  let phone: String
  var email: String?
  var birthday: Date?
  var discountCard: DiscountCard?
  var bonuses: Int
  var marketingBonus: Int
  var gender: Gender
  
  var hasDiscounts: Bool {
    return goldDiscount != 0 || silverDiscount != 0
  }
  
  var goldDiscount: Int {
    return discountCard?.goldDiscount ?? 0
  }
  
  var silverDiscount: Int {
    return discountCard?.silverDiscount ?? 0
  }
  
  var isFull: Bool {
    return !name.isNilOrEmpty && !surname.isNilOrEmpty && !email.isNilOrEmpty && birthday != nil
  }
  
  // MARK: - Life Cycle
  init?(json: JSON) {
    guard let dictionary = json.dictionary,
      let id = dictionary[NetworkResponseKey.User.id]?.int,
      let phone = dictionary[NetworkResponseKey.User.telephoneNumber]?.stringValue else {
        return nil
    }
    self.id = id
    self.phone = phone
    
    if let name = dictionary[NetworkResponseKey.User.name]?.stringValue {
      self.name = name
    }
    if let surname = dictionary[NetworkResponseKey.User.surname]?.stringValue {
      self.surname = surname
    }
    if let email = dictionary[NetworkResponseKey.User.email]?.stringValue {
      self.email = email
    }
    if let dateString = dictionary[NetworkResponseKey.User.birthday]?.stringValue,
      let date = DateFormattersFactory.serverDateFormatter().date(from: dateString) {
      birthday = date
    }
    discountCard = DiscountCard(json: dictionary[NetworkResponseKey.User.discountCard] ?? JSON())
    bonuses = dictionary[NetworkResponseKey.User.bonus]?.intValue ?? 0
    marketingBonus = dictionary[NetworkResponseKey.User.marketingBonus]?.intValue ?? 0
    
    if let genderString = dictionary[NetworkResponseKey.User.gender]?.string,
       let gender = Gender(rawValue: genderString) {
      
      self.gender = gender
    } else {
      
      self.gender = .undefined
    }
  }
  
  init?(userMO: UserMO) {
    guard let phone = userMO.phone else { return nil }
    id = Int(userMO.id)
    self.phone = phone
    name = userMO.name
    surname = userMO.surname
    email = userMO.email
    birthday = userMO.birthday
    if let discountCard = userMO.discountCard {
      self.discountCard = DiscountCard(discountCardMO: discountCard)
    } else {
      discountCard = nil
    }
    bonuses = Int(userMO.bonuses)
    marketingBonus = Int(userMO.marketingBonus)
    
    if let genderString = userMO.gender,
       let gender = Gender(rawValue: genderString) {
      
      self.gender = gender
    } else {
      
      self.gender = .undefined
    }
    
  }
}

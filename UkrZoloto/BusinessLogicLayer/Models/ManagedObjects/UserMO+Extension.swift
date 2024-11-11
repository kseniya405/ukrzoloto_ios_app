//
//  UserMO+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 10/28/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import CoreData

extension UserMO {
  func fill(from user: User, in context: NSManagedObjectContext) {
    id = Int64(user.id)
    phone = user.phone
    name = user.name
    surname = user.surname
    email = user.email
    birthday = user.birthday
    gender = user.gender.rawValue
    
    if let discountCard = discountCard {
      context.delete(discountCard)
    }
    if let card = user.discountCard {
      let discountCardMO = DiscountCardMO(context: context)
      discountCardMO.fill(from: card)
      self.discountCard = discountCardMO
    } else {
      discountCard = nil
    }
    bonuses = Int32(user.bonuses)
    marketingBonus = Int32(user.marketingBonus)
  }
}

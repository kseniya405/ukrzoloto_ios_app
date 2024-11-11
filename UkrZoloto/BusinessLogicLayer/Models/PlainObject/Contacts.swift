//
//  Contacts.swift
//  UkrZoloto
//
//  Created by Mykola on 22.07.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Contacts {
  
  var phone: String
  var workdayHrs: String
  var weekendHrs: String
  
  var telegramUrl: String
  var viberUrl: String
  var messengerUrl: String
  var instagramUrl: String
  var bussinessChatUrl: String
  
  init?(json: JSON) {
    
    guard let dictionary = json.dictionary,
          let socials = dictionary[NetworkResponseKey.Contacts.social]?.dictionary,
          let contacts = dictionary[NetworkResponseKey.Contacts.callCenter]?.dictionary else {
      return nil
    }
    
    guard let phone = contacts[NetworkResponseKey.Contacts.phone]?.string,
          let weekday = contacts[NetworkResponseKey.Contacts.weekday]?.string,
          let weekend = contacts[NetworkResponseKey.Contacts.weekend]?.string,
          let telegram = socials[NetworkResponseKey.Contacts.telegramBot]?.string,
          let viber = socials[NetworkResponseKey.Contacts.viber]?.string,
          let messenger = socials[NetworkResponseKey.Contacts.messenger]?.string,
          let instagram = socials[NetworkResponseKey.Contacts.instagram]?.string,
          let appleChat = socials[NetworkResponseKey.Contacts.appleChat]?.string else {
      return nil
    }
     
    self.phone = phone
    self.weekendHrs = weekend
    self.workdayHrs = weekday
    self.telegramUrl = telegram
    self.viberUrl = viber
    self.messengerUrl = messenger
    self.instagramUrl = instagram
    self.bussinessChatUrl = appleChat
  }
}

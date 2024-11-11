//
//  ContactsHelper.swift
//  UkrZoloto
//
//  Created by Mykola on 22.07.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class ContactsHelper {
  
  private var defaults = UserDefaults.standard
  
  var formattedPhone: String {
    get {
      if let value = defaults.value(forKey: Keys.phone.rawValue) as? String {
        return value
      }
      return "0 800 75 92 29"
    }
    set {
      defaults.setValue(newValue, forKey: Keys.phone.rawValue)
    }
  }
  
  var phone: String {
    return formattedPhone.replacingOccurrences(of: " ", with: "")
  }
  
  var workdayHrs: String {
    get {
      if let value = defaults.value(forKey: Keys.workdayHrs.rawValue) as? String {
        return value
      }
      return "9:00 - 20:00"
    }
    set {
      defaults.setValue(newValue, forKey: Keys.workdayHrs.rawValue)
    }
  }
  
  var weekendHrs: String {
    get {
      if let value = defaults.value(forKey: Keys.weekendHrs.rawValue) as? String {
        return value
      }
      return "10:00 - 19:00"
    }
    set {
      defaults.setValue(newValue, forKey: Keys.weekendHrs.rawValue)
    }
  }
  
  var socials: [Social] {
    
    let defaultArray: [SocialType] = [.viber, .telegram, .facebook, .instagram]
    
    return defaultArray.map({getSocialModel(socialType: $0)})
  }
  
  func getSocialModel(socialType: SocialType) -> Social {
    
    let image: UIImage = {
      switch socialType {
      case .telegram:
        return #imageLiteral(resourceName: "iconsMessengersTelegram")
      case .facebook:
        return #imageLiteral(resourceName: "iconsMessengersFacebookMess")
      case .instagram:
        return #imageLiteral(resourceName: "iconsSocialInst")
      case .viber:
        return #imageLiteral(resourceName: "iconsMessengersViber")
      case .businessChat:
        return #imageLiteral(resourceName: "businessChat")
      }
    }()
    
    let key = [socialKeyPrefix, socialType.rawValue].joined()
    
    let webUrl: String = {
      
      if let storedValue = defaults.value(forKey: key) as? String {
        return storedValue
      }
      
      switch socialType {
      case .telegram:
        return "https://t.me/ukrzoloto"
      case .facebook:
        return "https://m.me/ukrzoloto"
      case .instagram:
        return "https://instagram.com/ukrzoloto"
      case .viber:
        let chatId = "ukrzolotoua"
        return "viber://pa?chatURI=\(chatId)"
      case .businessChat:
        return "https://bcrw.apple.com/sms:open?service=iMessage&recipient=urn:biz:234811c4-ebd3-464f-a4e2-04b54b4a9378"
      }
    }()
    
    return Social(type: socialType, image: image, webUrl: webUrl)
  }
  
  func storeContacts(_ contacts: Contacts) {
    
    formattedPhone = contacts.phone
    workdayHrs = contacts.workdayHrs
    weekendHrs = contacts.weekendHrs
    
    storeSocialUrl(contacts: contacts)
  }
  
  func storeSocialUrl(contacts: Contacts) {
    let telegramKey = socialKeyPrefix + SocialType.telegram.rawValue
    defaults.setValue(contacts.telegramUrl, forKey: telegramKey)
    
    let viberKey = socialKeyPrefix + SocialType.viber.rawValue
    defaults.setValue(contacts.viberUrl, forKey: viberKey)
    
    let messengerKey = socialKeyPrefix + SocialType.facebook.rawValue
    defaults.setValue(messengerKey, forKey: contacts.messengerUrl)
    
    let appleChatKey = socialKeyPrefix + SocialType.businessChat.rawValue
    defaults.setValue(contacts.bussinessChatUrl, forKey: appleChatKey)
    
    let instagramKey = socialKeyPrefix + SocialType.instagram.rawValue
    defaults.setValue(contacts.instagramUrl, forKey: instagramKey)
  }
  
  private let socialKeyPrefix = "social_url_"
}

private extension ContactsHelper {
  
  enum Keys: String {
    case phone
    case workdayHrs
    case weekendHrs
    
    case telegramUrl
    case messengerUrl
    case viberUrl
    case bussinessChatUrl
    case instagramUrl
  }
}

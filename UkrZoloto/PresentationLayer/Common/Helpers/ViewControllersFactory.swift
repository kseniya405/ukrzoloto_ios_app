//
//  ViewControllersFactory.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 13.11.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

enum WebViewControllerType {
  case discount
  case agreement
  case deleteAccountAgreement
  case refund
  case delivery
  case offer
  case site
	case exchangeDetails
}

class ViewControllersFactory {
  
  static func webViewVC(ofType type: WebViewControllerType, keyLocalizator: KeyLocalizator) -> WebViewController? {
    guard let url = getWebURL(type) else { return nil }
    return WebViewController(url: url,
                             redirectURL: nil,
                             shouldDisplayOnFullScreen: true,
                             titleLocalizator: keyLocalizator)
  }
  
  // MARK: - Private methods
  private static func getWebURL(_ type: WebViewControllerType) -> URL? {
    return LocalizationService.shared.language.code == AppLanguage.ISO639Alpha2.russian ? getRussianURL(type) : getUkrainianURL(type)
  }
  
  private static func getUkrainianURL(_ type: WebViewControllerType) -> URL? {
    switch type {
    case .discount:
      return URL(string: "https://ukrzoloto.ua/uk/page/dyskontna-prohrama/")
    case .agreement:
      return URL(string: "https://ukrzoloto.ua/uk/page/uhoda-korystuvacha/")
    case .deleteAccountAgreement:
      return URL(string: "https://ukrzoloto.ua/uk/page/politika-vidalennya-danih-koristuvacha/")
    case .refund:
      return URL(string: "https://ukrzoloto.ua/uk/page/povernennia-ta-obmin-yuvelirnykh-prykras/")
    case .delivery:
      return URL(string: "https://ukrzoloto.ua/uk/page/oplata-i-dostavka/")
    case .offer:
      return URL(string: "https://ukrzoloto.ua/uk/page/publichna-oferta/")
    case .site:
      return URL(string: "ukrzoloto.ua")
    case .exchangeDetails:
      return URL(string: "https://ukrzoloto.ua/uk/page/exchange-service/")
    }
  }
  
  private static func getRussianURL(_ type: WebViewControllerType) -> URL? {
    switch type {
    case .discount:
      return URL(string: "https://ukrzoloto.ua/page/discount-program/")
    case .agreement:
      return URL(string: "https://ukrzoloto.ua/page/polzovatelskoe-soglashenie/")
    case .deleteAccountAgreement:
      return URL(string: "https://ukrzoloto.ua/page/politika-udaleniya-polzovatelskih-dannyh/")
    case .refund:
      return URL(string: "https://ukrzoloto.ua/page/vozvrat-obmen-yuvelirnyh-ukrashenij/")
    case .delivery:
      return URL(string: "https://ukrzoloto.ua/page/oplata-i-dostavka/")
    case .offer:
      return URL(string: "https://ukrzoloto.ua/page/publichnaja-oferta/")
    case .site:
      return URL(string: "ukrzoloto.ua")
		case .exchangeDetails:
			return URL(string: "https://ukrzoloto.ua/page/exchange-service/")
    }
  }
  
}

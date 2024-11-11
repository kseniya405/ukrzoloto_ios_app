//
//  PriceDetailsViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 9/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import UIKit

extension PriceDetailsViewModel {
  
  enum Item {
    
    case header(goodsNumber: Int, price: Decimal)
		case exchange(amount: Int, price: Decimal)
    case discount(Discount, Decimal)
    case delivery(String)
    case cashback(Decimal)
    case total(Decimal)
    
    var title: String {
      
      switch self {
        
      case .header(goodsNumber: _, price: _):
        return Localizator.standard.localizedString("Товаров")
        
      case .discount(let discount, _):
        
        switch discount {
        case .promocode:
          return Localizator.standard.localizedString("Промокод")
        case .bonusUsage:
          return Localizator.standard.localizedString("Списание бонусов")
        case .promoBonus:
          return Localizator.standard.localizedString("Акционные бонусы")
        case .certificate:
          return Localizator.standard.localizedString("Сертификат")
        case .discount:
          return Localizator.standard.localizedString("Дисконтная скидка")
        case .birthday:
          return Localizator.standard.localizedString("Скидка на день рождения")
        case .additionalPromo:
          return Localizator.standard.localizedString("Дополнительная акция")
        }
        
      case .delivery( _):
        return Localizator.standard.localizedString("Доставка")
      case .cashback( _):
        return Localizator.standard.localizedString("Кэшбэк")
      case .total( _):
        return Localizator.standard.localizedString("Итого").uppercased()
			case .exchange(amount: _, price: _):
				return Localizator.standard.localizedString("Обмен украшений")
			}
    }
    
    var valueString: String {
      
      let signString = " ₴‎"
      
      //FORMAT PRICES

      switch self {
      case .header(_, let price):
        return "\(price)" + signString
        
      case .discount(_ , let price):
        return "- \(price)" + signString
        
      case .delivery(let value):
        
        return value
      case .cashback(let price):
        return "+ \(price)" + signString
        
      case .total(let price):
        return "\(price)" + signString
			case .exchange(amount: _, price: let price):
				return "\(price)" + signString
			}
    }
    
    var value: Int? {
      
      switch self {
        
      case .cashback(let amount):
        return NSDecimalNumber(decimal: amount).intValue
        
      default: return nil
      }
    }
    
    var icon: UIImage? {
      
      switch self {
        
      case .discount(let discount, _ ):
        return discount.icon
        
      case .header(_, _):
        return UIImage(named: "base_price_icon")
			case .exchange(_, _):
				return UIImage(named: "iconsExchange")

      default:
        return nil
      }
    }
  }

  enum Discount: CaseIterable {
    
    case promocode
    case bonusUsage // Списание бонусов
    case promoBonus // Акционные бонусы
    case certificate
    case discount // Дисконтная скидка
    case birthday
    case additionalPromo // Дополнительная акция
    
    var icon: UIImage? {
      
      switch self {
      case .promocode:      return UIImage(named: "promocode_icon")
      case .bonusUsage:     return UIImage(named: "bonus_usage_icon")
      case .promoBonus:     return UIImage(named: "promo_bonus_icon")
      case .certificate:    return UIImage(named: "certificate_icon")
      case .discount:       return UIImage(named: "discount_icon")
      case .birthday,
          .additionalPromo: return UIImage(named: "calendar_discount_icon")
      }
    }
    
    var shouldHighlightValue: Bool {
      
      switch self {
      case .bonusUsage, .promoBonus:
        return true
        
      default:
        return false
      }
    }
  }


}

struct PriceDetailsViewModel {
  
  var header: Item?
	var exchange: Item?
  var discounts: [Item] = []
  var delivery: Item?
  var cashback: Item?
  var total: Item?
  
  var totalGoodsCount: Int? = 2
  
  var promocodeTitle = Localizator.standard.localizedString("Промокод")
  var promocodeValue: String? = nil
  var promocodeIcon = UIImage(named: "promocode_icon")
  
  var priceTitle: String!
  var price: Price!
  var actionTitle: String!
  var actionValue: String? = nil
  var discountTitle: String? = nil
  var discount: String? = nil

  var promoBonusTitle: String? = nil
  var promoBonusValue: String? = nil
  var bonusTitle: String? = nil
  var bonusValue: String? = nil
  var deliveryPriceTitle: String? = nil
  var deliveryPriceValue: String? = nil
  var totalPriceTitle: String!
  var totalPrice: Price!
  var bonusesDelayTitle: String?
      
	init(header: Item, exchange: Item?, discounts: [Item], delivery: Item?, cashback: Item?, total: Item) {
    self.header = header
		self.exchange = exchange
    self.discounts = discounts
    self.delivery = delivery
    self.cashback = cashback
    self.total = total
  }
}
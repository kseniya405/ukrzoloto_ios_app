//
//  StringComposer.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

struct PriceStyle {
  let font: UIFont
  let currencyFont: UIFont
}

class StringComposer {
  
  // MARK: - Singleton
  static let shared = StringComposer()
  
  // MARK: - Life cycle
  private init() { }
  
  // MARK: - Interface
	func getScheduleString(shop: NewShopsItem, status: ShopStatus = .isOpened) -> String {
		switch status {
		case .isOpened:
			return getCloseAtTime(closeTime: shop.closedAt)
		case .isPickupPoint:
			return getOpenTime(openTime: shop.openAt)
		case .isTemporarilyСlosed:
			return ""
		}
  }
	
	private func getCloseAtTime(closeTime: String?) -> String {
		guard let closeTime = closeTime else { return ""}
		return "\(Localizator.standard.localizedString("сегодня до")) \(closeTime)"
	}
	
	private func getOpenTime(openTime: String?) -> String {
		guard let openTime = openTime else { return ""}
		return "\(Localizator.standard.localizedString("откроется в")) \(openTime)"
	}
  
  func createDiscountString(for variant: Variant) -> String {
    return "-\(variant.price.discount)%"
  }
  
  func getOldPriceAttriburedString(price: Price,
                                   style: PriceStyle = UIConstants.defaultOldPriceStyle,
                                   isLongCurrency: Bool = true) -> NSAttributedString? {
    guard price.old != price.current,
      let priceText = TextFormatters.priceFormatter.string(from: price.old as NSDecimalNumber) else {
        return nil
    }
    let priceString = NSMutableAttributedString(attributedString: NSAttributedString.strikedAttributedText(from: priceText))
    
    let attributes = [NSAttributedString.Key.strikethroughColor: UIConstants.OldPrice.strikethroughColor,
                      NSAttributedString.Key.foregroundColor: UIConstants.OldPrice.textColor,
                      NSAttributedString.Key.font: style.font
    ]
    priceString.addAttributes(attributes,
                              range: NSRange(location: 0, length: priceString.length))
    
    let currencyString = NSMutableAttributedString(string: Localizator.standard.localizedString(isLongCurrency ? "грн" : "₴"))
    let currencyAttr = [NSAttributedString.Key.strikethroughColor: UIConstants.OldPrice.strikethroughColor,
                        NSAttributedString.Key.foregroundColor: UIConstants.OldPrice.textColor,
                        NSAttributedString.Key.font: style.currencyFont
    ]
    currencyString.addAttributes(currencyAttr,
                                 range: NSRange(location: 0, length: currencyString.length))
    priceString.append(NSAttributedString(string: " "))
    priceString.append(currencyString)
    return priceString
  }
  
  func getPriceAttributedString(price: Price,
                                style: PriceStyle = UIConstants.defaultPriceStyle,
                                isLongCurrency: Bool = true) -> NSAttributedString? {
    guard let priceText = TextFormatters.priceFormatter.string(from: price.current as NSDecimalNumber) else {
      return nil
    }
    let attributes = [NSAttributedString.Key.foregroundColor: UIConstants.Price.textColor,
                      NSAttributedString.Key.font: style.font
    ]
    let priceString = NSMutableAttributedString(string: priceText, attributes: attributes)
    
    let currencyString = NSMutableAttributedString(string: Localizator.standard.localizedString(isLongCurrency ? "грн" : "₴"))
    let currencyAttr = [NSAttributedString.Key.foregroundColor: UIConstants.Price.textColor,
                        NSAttributedString.Key.font: style.currencyFont
    ]
    currencyString.addAttributes(currencyAttr,
                                 range: NSRange(location: 0, length: currencyString.length))
    priceString.append(NSAttributedString(string: " "))
    priceString.append(currencyString)
    return priceString
  }
  
  func getLowestMonthlyPaymentAttributedString(payment: NSDecimalNumber) -> NSAttributedString? {
    
    guard let priceText = TextFormatters.priceFormatter.string(from: payment) else {
      return nil
    }
    
    let prefixString = Localizator.standard.localizedString("от ")
    let postfixString = Localizator.standard.localizedString(" грн/мес")
    
    let str = prefixString + priceText + postfixString
    
    let attrString = NSMutableAttributedString(string: str)
    
    attrString.addAttributes([.foregroundColor: UIColor(hex:"#042320")],
                             range: NSRange(location: 0, length: str.count))
    
    attrString.addAttributes([.font: UIFont(name: "OpenSans-Regular", size: 13)!],
                             range: NSRange(location: 0, length: prefixString.count))
    
    attrString.addAttributes([.font: UIFont.boldAppFont(of: 28)],
                             range: NSRange(location: prefixString.count, length: priceText.count))
    
    attrString.addAttributes([.font: UIFont.semiBoldAppFont(of: 13)],
                             range: NSRange(location: str.count - postfixString.count, length: postfixString.count))
    
    return attrString
  }

  func getShortLowestMonthlyPaymentAttributedString(payment: NSDecimalNumber) -> NSAttributedString? {

    guard let priceText = TextFormatters.priceFormatter.string(from: payment) else {
      return nil
    }

    let postfixString = Localizator.standard.localizedString("₴")

    let str = priceText + " " + postfixString

    let attrString = NSMutableAttributedString(string: str)

    attrString.addAttributes([.foregroundColor: UIColor(hex:"#042320")],
                             range: NSRange(location: 0, length: str.count))

    return attrString
  }
  
  func getPriceString(price: Price) -> String? {
    guard let priceText = TextFormatters.priceFormatter.string(from: price.current as NSDecimalNumber) else {
      return nil
    }
    return priceText + " " + Localizator.standard.localizedString("грн")
  }
  
  func getPriceCurrencyString(_ price: Price) -> String {
    return "\(price.current) ₴"
  }
  
  func getPointString(_ point: String) -> String {
    return "— " + point
  }
  
  func getDeliveryPointEmphasiseString(text: String, emphasise: String) -> NSAttributedString {
		let font = UIFont.regularAppFont(of: 14)
    
    let attributedString = NSMutableAttributedString(string: text,
                                                     attributes: [.font: font])
    
    if let emphasiseRange = text.range(of: emphasise) {
      attributedString.addAttributes([.font: UIFont.boldAppFont(of: 20)],
                                     range: NSRange(emphasiseRange, in: text))
    }
    
    return attributedString
  }
  
  func getPromoBonusString(text: String, emphasise: String) -> NSAttributedString {
    let font = UIFont.regularAppFont(of: 13)
    
    let attributedString = NSMutableAttributedString(
      string: text,
      attributes: [.font: font])
    
    if let emphasiseRange = text.range(of: emphasise) {
      attributedString.addAttributes(
        [.font: UIFont.boldAppFont(of: 13)],
				range: NSRange(emphasiseRange, in: text))
    }
    
    return attributedString
  }
  
  func getFilterValueString(from filter: SelectFilter) -> String {
    var components = [String]()
    components.append(contentsOf: filter.variants
      .filter { $0.status == true }
      .compactMap { $0.value })
    
    return components.joined(separator: ", ")
  }
  
  func getPriceTitle(for title: String) -> String {
    return title + ", \(Localizator.standard.localizedString("грн"))"
  }
  
  func getRangePriceConfigureString(price: Int) -> String {
    return TextFormatters.priceFormatter.string(from: NSNumber(integerLiteral: price)) ?? "\(price)"
  }
  
  func getSearchResultTitle(searchText: String, productsCount: Int) -> String {
    return Localizator.standard.localizedString("Результаты поиска по запросу:\n") + "\(searchText)" + " (\(productsCount) " + Localizator.standard.localizedString("товара", productsCount) + ")"
  }
  
  func getAddressStringFrom(cityName: String?, address: Address?) -> String {
    guard let cityName = cityName, let address = address else { return "" }
    
    var components = [String]()
    components.append(cityName)
    components.append(address.street)
    components.append(address.house)

    if let apartment = address.apartment {
      components.append(apartment)
    }
    
    return components.joined(separator: ", ")
  }
  
  func timeString(seconds: Int) -> String {
    return "\(seconds) " + Localizator.standard.localizedString("сек")
  }
  
  func getDiscountString(goldDiscount: Int) -> String {
      return Localizator.standard.localizedString("Ваша персональная скидка - %d%%", goldDiscount)
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum OldPrice {
    static let strikethroughColor = UIColor.color(r: 255, g: 89, b: 53)
    static let textColor = UIColor.color(r: 4, g: 35, b: 32, a: 0.4)
  }
  
  enum Price {
    static let textColor = UIColor.color(r: 4, g: 35, b: 32)
  }
  
  static let defaultPriceStyle = PriceStyle(font: UIFont.boldAppFont(of: 28),
                                            currencyFont: UIFont.semiBoldAppFont(of: 18))
  
  static let defaultOldPriceStyle = PriceStyle(font: UIFont.regularAppFont(of: 18),
                                            currencyFont: UIFont.regularAppFont(of: 11))
  
  enum DeliveryPointInfo {
    
  }
  
}

//
//  ProductTileViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/17/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

struct ProductTileViewModel {
  
  // MARK: - Public variables
  let id: Int
  let sku: String
  let image: ImageViewModel
  let title: String
  let price: Price
  var isInFavorite: Bool
  let credits: [DisplayableCredit]
  let promo: String?
  let discountHintText: String
  let discountHintIcon: UIImage
  let indicative: Bool
  
  var formattedOldPrice: NSAttributedString? {
    guard price.discount != 0,
    let priceText = TextFormatters.priceFormatter.string(from: price.old as NSDecimalNumber) else {
      return nil
    }
    let priceString = NSMutableAttributedString(attributedString: NSAttributedString.strikedAttributedText(from: priceText))
    
    let attributes = [NSAttributedString.Key.strikethroughColor: UIConstants.OldPrice.strikethroughColor,
                      NSAttributedString.Key.foregroundColor: UIConstants.OldPrice.textColor,
                      NSAttributedString.Key.font: UIConstants.OldPrice.priceFont
    ]
    priceString.addAttributes(attributes,
                              range: NSRange(location: 0, length: priceString.length))
    
    let currencyString = NSMutableAttributedString(string: Localizator.standard.localizedString("₴"))
    let currencyAttr = [NSAttributedString.Key.strikethroughColor: UIConstants.OldPrice.strikethroughColor,
                        NSAttributedString.Key.foregroundColor: UIConstants.OldPrice.textColor,
                        NSAttributedString.Key.font: UIConstants.OldPrice.currencyFont
    ]
    currencyString.addAttributes(currencyAttr,
                              range: NSRange(location: 0, length: currencyString.length))
    priceString.append(NSAttributedString(string: " "))
    priceString.append(currencyString)
    return priceString
  }
  
  var formattedPrice: NSAttributedString? {
    guard let priceText = TextFormatters.priceFormatter.string(from: price.current as NSDecimalNumber) else {
        return nil
    }
    let attributes = [NSAttributedString.Key.foregroundColor: UIConstants.Price.textColor,
                      NSAttributedString.Key.font: UIConstants.Price.priceFont
    ]
    let priceString = NSMutableAttributedString(string: priceText, attributes: attributes)
    
    let currencyString = NSMutableAttributedString(string: Localizator.standard.localizedString("₴"))
    let currencyAttr = [NSAttributedString.Key.foregroundColor: UIConstants.Price.textColor,
                        NSAttributedString.Key.font: UIConstants.Price.currencyFont
    ]
    currencyString.addAttributes(currencyAttr,
                                 range: NSRange(location: 0, length: currencyString.length))
    priceString.append(NSAttributedString(string: " "))
    priceString.append(currencyString)
    return priceString
  }
  
  var discountText: String? {
    guard price.discount > 0 else {
      return nil
    }
    return "-\(price.discount)%"
  }
  
  var favoriteImage: UIImage {
    return isInFavorite ? UIConstants.FavoriteButton.selectedImage : UIConstants.FavoriteButton.deselectedImage
  }
  
  // MARK: - Life cycle
  init(product: Product) {
    id = product.id
    image = .url(product.image, placeholder: #imageLiteral(resourceName: "placeholderProductTIle"))
    title = product.name
    price = product.price
    isInFavorite = product.isInFavorite
    sku = product.sku
    credits = product.credits.getDisplayableCredits()
    indicative = product.indicative

    func getPromoFrom(_ product: Product) -> String? {
      switch product.stickers.count {
      case 0: return nil
      case 1: return Localizator.standard.localizedString("+1 акция")
      case 2: return Localizator.standard.localizedString("+2 акции")
      default: return Localizator.standard.localizedString("+3 акции")
      }
    }

    promo = getPromoFrom(product)

    discountHintText = ProfileService.shared.user == nil ? Localizator.standard.localizedString("Получить скидку") : Localizator.standard.localizedString("Ваша Скидка")
    discountHintIcon = UIConstants.DiscountHint.icon
  }
}

// MARK: - Hashable
extension ProductTileViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: ProductTileViewModel, rhs: ProductTileViewModel) -> Bool {
    return lhs.id == rhs.id
  }
}

private enum UIConstants {
							enum OldPrice {
    static let strikethroughColor = UIColor.color(r: 255, g: 95, b: 95)
    static let priceFont = UIFont.regularAppFont(of: 12)
    static let currencyFont = UIFont.regularAppFont(of: 10)
    static let textColor = UIColor.color(r: 4, g: 35, b: 32, a: 0.4)
  }
  
  enum Price {
    static let priceFont = UIFont.boldAppFont(of: 16)
    static let currencyFont = UIFont.semiBoldAppFont(of: 12)
    static let textColor = UIColor.color(r: 4, g: 35, b: 32)
  }
  
  enum FavoriteButton {
    static let deselectedImage = #imageLiteral(resourceName: "favoriteImageDeselected")
    static let selectedImage = #imageLiteral(resourceName: "favoriteImageSelected")
  }

  enum DiscountHint {
    static let icon = #imageLiteral(resourceName: "iconsDiscountHintInfo")
  }
}

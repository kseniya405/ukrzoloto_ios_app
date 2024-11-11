//
//  ButtonsFactory.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 24.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ButtonsFactory {
  
  static func closeButtonForNavigationItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "controlsClose"))
  }
  
  static func blackCloseButtonForNavigationItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "controlsCloseBlack"))
  }
  
  static func backButtonForNavigationItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "controlsBack"))
  }
  
  static func greenBackButtonForNavItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "greenLeftArrow"))
  }
  
  static func favouriteButtonForNavItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "iconsFavoriteBlack"))
  }
  
  static func shareButtonForNavItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "share"))
  }
  
  static func searchButtonForNavigationItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "controlsSearch"))
  }
  
  static func filterButtonForNavItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "filterIcon"))
  }
  
  static func clearFilterButtonForNavItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "cleanNavbarIcon"))
  }
  
  static func logoutButtonForNavItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "logout"))
  }
  
  static func saveButtonForNavigationItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "controlsAccept"))
  }
  
  static func cartButtonForNavigationItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "basket"))
  }

  static func discountCardButtonForNavItem() -> UIButton {
    return navigationBarItem(image: #imageLiteral(resourceName: "iconsDiscountCard"))
  }
  
  // MARK: Private
  private static func navigationBarItem(image: UIImage?,
                                        size: CGSize = CGSize(width: 24, height: 24)) -> UIButton {
    let button = UIButton()
    button.setImage(image, for: .normal)
    button.imageView?.contentMode = .center
    button.frame = CGRect(origin: CGPoint.zero, size: size)
    return button
  }
  
}

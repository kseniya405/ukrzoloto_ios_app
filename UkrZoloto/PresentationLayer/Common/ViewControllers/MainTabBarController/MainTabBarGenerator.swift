//
//  MainTabBarGenerator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import Localize_Swift

struct TabItem {
  var viewController: UIViewController
  var tabBarItemView: ESTabBarItemContentView
  var tabImage: UIImage
  var tabSelectedImage: UIImage
  var tabName: String
}

enum MainTabBarItemOrder: Int {
  case main
  case catalog
  case shops
  case profile
  case cart
}

class MainTabBarGenerator {
  
  // MARK: - Private variables
  private let tabNameKeys: [MainTabBarItemOrder: String] = [
    .main: "Главная",
    .shops: "Магазины",
    .cart: "Корзина",
    .catalog: "Каталог",
    .profile: "Профиль"
  ]
  
  // MARK: - Public
  @discardableResult
  func createMainTabItem(for viewController: UIViewController) -> TabItem {
    let tabItem = TabItem(viewController: viewController,
                          tabBarItemView: BaseTabBarItemContentView(),
                          tabImage: #imageLiteral(resourceName: "iconsHome"),
                          tabSelectedImage: #imageLiteral(resourceName: "iconsHomeAct"),
                          tabName: findTabNameForItem(order: .main))
    applyAttributes(to: tabItem)
    return tabItem
  }
  
  @discardableResult
  func createShopsTabItem(for viewController: UIViewController) -> TabItem {
    let tabItem = TabItem(viewController: viewController,
                          tabBarItemView: BaseTabBarItemContentView(),
                          tabImage: #imageLiteral(resourceName: "iconsShops"),
                          tabSelectedImage: #imageLiteral(resourceName: "iconsShopsAct2"),
                          tabName: findTabNameForItem(order: .shops))
    applyAttributes(to: tabItem)
    return tabItem
  }
  
  @discardableResult
  func createCartTabItem(for viewController: UIViewController, isEmpty: Bool = true) -> TabItem {
    let tabItem = TabItem(viewController: viewController,
                          tabBarItemView: BaseTabBarItemContentView(),
                          tabImage: isEmpty ?
                            #imageLiteral(resourceName: "iconsBasket") :
                            #imageLiteral(resourceName: "CartFull"),
                          tabSelectedImage: #imageLiteral(resourceName: "iconsBasketAct"),
                          tabName: findTabNameForItem(order: .cart))
    applyAttributes(to: tabItem)
    return tabItem
  }
  
  @discardableResult
  func createCatalogTabItem(for viewController: UIViewController) -> TabItem {
    let tabItem = TabItem(viewController: viewController,
                          tabBarItemView: BaseTabBarItemContentView(),
                          tabImage: #imageLiteral(resourceName: "iconsCatalog"),
                          tabSelectedImage: #imageLiteral(resourceName: "iconsCatalogAct"),
                          tabName: findTabNameForItem(order: .catalog))
    applyAttributes(to: tabItem)
    return tabItem
  }
  
  @discardableResult
  func createProfileTabItem(for viewController: UIViewController) -> TabItem {
    let tabItem = TabItem(viewController: viewController,
                          tabBarItemView: BaseTabBarItemContentView(),
                          tabImage: #imageLiteral(resourceName: "iconsProfile"),
                          tabSelectedImage: #imageLiteral(resourceName: "iconsProfileAct"),
                          tabName: findTabNameForItem(order: .profile))
    applyAttributes(to: tabItem)
    return tabItem
  }
  
  func findTabNameForItem(order: MainTabBarItemOrder) -> String {
    guard let name = tabNameKeys[order]?.localized() else {
      fatalError("findTabNameForItem(order:): tab name was not setted")
    }
    return name
  }
  
  // MARK: - Configure
  
  private func applyAttributes(to tabItem: TabItem) {
    let normalAttributes = createTabBarNormalAttributes()
    let selectedAttributes = createTabBarSelectedAttributes()
    let controller = tabItem.viewController
    let tabBarItem = ESTabBarItem(tabItem.tabBarItemView,
                                  title: tabItem.tabName,
                                  image: tabItem.tabImage,
                                  selectedImage: tabItem.tabSelectedImage)
    controller.tabBarItem = tabBarItem
    controller.tabBarItem.setTitleTextAttributes(normalAttributes, for: .normal)
    controller.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
  }
  
  // MARK: - Text Attributes
  private func createTabBarSelectedAttributes() -> [NSAttributedString.Key: Any] {
    return [.font: ItemConstants.font as Any,
            .foregroundColor: ItemConstants.selectedColor
    ]
  }
  
  private func createTabBarNormalAttributes() -> [NSAttributedString.Key: Any] {
    return [.font: ItemConstants.font as Any,
            .foregroundColor: ItemConstants.normalColor
    ]
  }
}

private enum ItemConstants {
  static let selectedColor = UIColor.color(r: 0, g: 80, b: 47)
  static let normalColor = UIColor.color(r: 4, g: 35, b: 32, a: 0.6)
  static let font = UIFont.semiBoldAppFont(of: 10)
}

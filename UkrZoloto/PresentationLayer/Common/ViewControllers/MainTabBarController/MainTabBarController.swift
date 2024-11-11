//
//  MainTabBarController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import Localize_Swift

class MainTabBarController: ESTabBarController {
  
  // MARK: - Public variables
  static let centerItemOffset: CGFloat = 36
  
  // MARK: - Private variables
  private let topRoundedView = UIView()
  private let backgroundImageView = UIImageView()
  private var controllersGenerator = MainTabBarGenerator()
  
  // MARK: - Life cycle
  init(viewControllers: [UIViewController]) {
    super.init(nibName: nil, bundle: nil)
    self.viewControllers = viewControllers
    configureAppearance()
    setupViewControllers()
    addObservers()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initConfigure()
  }
  
  deinit {
    removeObservers()
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    configureTabBar()
  }
  
  private func configureTabBar() {
    tabBar.isTranslucent = true
    tabBar.barTintColor = UIConstants.backgroundColor
    tabBar.shadowImage = UIImage()
    tabBar.backgroundImage = UIImage()
    (tabBar as? ESTabBar)?.backgroundColor = .clear
    (tabBar as? ESTabBar)?.tintColor = .clear
    configureBackgroundImageView()
  }
  
  private func configureBackgroundImageView() {
    backgroundImageView.image = #imageLiteral(resourceName: "tabBarBackground")
    backgroundImageView.backgroundColor = .clear
    backgroundImageView.contentMode = .scaleAspectFit
    tabBar.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(UIConstants.BackgroundImageView.top)
      make.left.equalToSuperview().inset(UIConstants.BackgroundImageView.left)
      make.right.equalToSuperview().inset(UIConstants.BackgroundImageView.right)
      make.height.equalTo(backgroundImageView.snp.width).multipliedBy(301.0 / 1128.0)
    }
  }
  
  private func setupViewControllers() {
    let bottom = tabBar.frame.height - Constants.Screen.bottomSafeAreaInset - MainTabBarController.centerItemOffset
    viewControllers?.forEach { $0.additionalSafeAreaInsets = UIEdgeInsets(top: 0,
                                                                          left: 0,
                                                                          bottom: -bottom,
                                                                          right: 0)
    }
  }
  
  private func configureAppearance() {
      let appearance = self.tabBar.standardAppearance.copy()
      appearance.shadowImage = nil;
      appearance.shadowColor = nil;
      appearance.backgroundColor = .clear
      appearance.backgroundEffect = nil
      self.tabBar.standardAppearance = appearance;
  }
  
  // MARK: - Private methods
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(cartWasUpdated),
      name: .cartWasUpdated,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userWasLoggedOut),
      name: .userWasLoggedOut,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(languageWasUpdated),
      name: Notification.Name(LCLLanguageChangeNotification),
      object: nil)
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Actions
  @objc
  private func cartWasUpdated() {
    guard let cartViewController = viewControllers?[MainTabBarItemOrder.cart.rawValue] else { return }
    controllersGenerator.createCartTabItem(for: cartViewController,
                                           isEmpty: CartService.shared.cart?.cartItems.isEmpty ?? true)
  }
  
  @objc
  private func userWasLoggedOut() {
    guard let profileViewController = viewControllers?[MainTabBarItemOrder.profile.rawValue] else { return }
    _ = controllersGenerator.createProfileTabItem(for: profileViewController)
  }
  
  @objc func languageWasUpdated() {
    guard let mainVC = viewControllers?[MainTabBarItemOrder.main.rawValue] else { return }
    controllersGenerator.createMainTabItem(for: mainVC)
    guard let shopVC = viewControllers?[MainTabBarItemOrder.shops.rawValue] else { return }
    controllersGenerator.createShopsTabItem(for: shopVC)
    guard let profileVC = viewControllers?[MainTabBarItemOrder.profile.rawValue] else { return }
    controllersGenerator.createProfileTabItem(for: profileVC)
    guard let cartViewController = viewControllers?[MainTabBarItemOrder.cart.rawValue] else { return }
    controllersGenerator.createCartTabItem(for: cartViewController,
                                           isEmpty: CartService.shared.cart?.cartItems.isEmpty ?? true)
  }
}

private enum UIConstants {
  static let cornerRadius: CGFloat = 15
  static let backgroundColor = UIColor.clear
  static let borderColor = UIColor.color(r: 230, g: 230, b: 230)
  static let borderWidth: CGFloat = 2
  enum BackgroundImageView {
    static let top: CGFloat = -12 * Constants.Screen.heightCoefficient
    static let left: CGFloat = 0
    static let right: CGFloat = 0
  }
}

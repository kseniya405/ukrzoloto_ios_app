//
//  TabBarCoordinator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class TabBarCoordinator: Coordinator {
  
  // MARK: - Private variables
  private weak var mainTabBarController: MainTabBarController?
  private var profileCoordinator: ProfileCoordinator?
  private var mainCoordinator: MainCoordinator?
  private var options: [AnyHashable: Any]?

  // MARK: - Private cinstants
  private let dispathGroup = DispatchGroup()
  
  // MARK: - Life cycle
  init(navigationController: UINavigationController,
       options: [AnyHashable: Any]? = nil) {
    self.options = options
    super.init(navigationController: navigationController)
  }
  
  override func start(completion: (() -> Void)? = nil) {
    addObservers()
    show()
  }

  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(showCategory),
      name: .showCategory,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(showProduct),
      name: .showProduct,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userWasLoggedOut),
      name: .userWasLoggedOut,
      object: nil)
  }

  private func show() {
    let generator = MainTabBarGenerator()
    var items: [MainTabBarItemOrder: TabItem] = [:]

    let mainNavVC = ColoredNavigationController()
    mainCoordinator = MainCoordinator(navigationController: mainNavVC,
                                      shouldDisplayContentOnFullScreen: false,
                                      options: options)
    mainCoordinator?.output = self
    dispathGroup.enter()
    mainCoordinator?.start {
      self.dispathGroup.leave()
    }
    items[.main] = generator.createMainTabItem(for: mainNavVC)
    
    let shopsNavVC = ColoredNavigationController()
    let shopsCoordinator = ShopsCoordinator(navigationController: shopsNavVC)
    dispathGroup.enter()
    shopsCoordinator.start {
      self.dispathGroup.leave()
    }
    items[.shops] = generator.createShopsTabItem(for: shopsNavVC)
    
    let catalogNavVC = ColoredNavigationController()
    let catalogCoordinator = CatalogCoordinator(navigationController: catalogNavVC)
    catalogCoordinator.output = self
    dispathGroup.enter()
    catalogCoordinator.start {
      self.dispathGroup.leave()
    }
    items[.catalog] = generator.createCatalogTabItem(for: catalogNavVC)

    let profileNavVC = ColoredNavigationController(style: .transparent)
    profileCoordinator = ProfileCoordinator(navigationController: profileNavVC)
    profileCoordinator?.output = self
    dispathGroup.enter()
    profileCoordinator?.start {
      self.dispathGroup.leave()
    }
    items[.profile] = generator.createProfileTabItem(for: profileNavVC)
    
    let cartNavVC = ColoredNavigationController()
    let cartCoordinator = CartCoordinator(navigationController: cartNavVC)
    cartCoordinator.output = self
    dispathGroup.enter()
    cartCoordinator.start {
      self.dispathGroup.leave()
    }
    items[.cart] = generator.createCartTabItem(for: cartNavVC)
    
    let sortedDict = items.sorted { return $0.key.rawValue < $1.key.rawValue }
    let viewControllers = sortedDict.map { return $0.value.viewController }
    
    let mainVC = MainTabBarController(viewControllers: viewControllers)

    navigationController.pushViewController(mainVC, animated: false)
    self.mainTabBarController = mainVC
  }

  private func showDiscountIfNeeded() {
    if ProfileService.shared.user != nil {
      let vc = DiscountViewController()
      vc.output = self
      mainTabBarController?.present(vc, animated: true)
    } else {
      let guestVC = GuestViewController(shouldDisplayOnFullScreen: false)
      guestVC.output = self
      let navController = ColoredNavigationController(rootViewController: guestVC, style: .green)
      navigationController.present(navController, animated: true)
    }
  }
  
  private func showProfileFormIfNeeded() -> Bool {

    return ProfileFormService.shared.displayProfileDataIfNeeded(context: navigationController)
  }
  
  private func showLogIn() {
    let navController = ColoredNavigationController(style: .green)
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start(animated: true) { [weak navigationController] in
      guard var vcs = navigationController?.viewControllers,
        vcs.count > 1 else { return }
      vcs.remove(at: vcs.count - 2)
      navigationController?.viewControllers = vcs
    }
    navigationController.present(navController, animated: true)
    authCoordinator.output = self
  }

  // MARK: - Actions
  @objc
  private func showCategory() {
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.main.rawValue
  }

  @objc
  private func showProduct() {
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.main.rawValue
  }
  
  @objc
  private func userWasLoggedOut() {
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.profile.rawValue
    showLogIn()
  }
}

// MARK: - MainCoordinatorOutput
extension TabBarCoordinator: MainCoordinatorOutput {
  func showCatalog() {
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.catalog.rawValue
  }

  func showDiscountCard() {
    self.showDiscountIfNeeded()
  }

  func showCart() {
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.cart.rawValue
  }
}

// MARK: - CartCoordinatorOutput
extension TabBarCoordinator: CartCoordinatorOutput {
  func showProducts(isPopToRootVC: Bool) {
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.main.rawValue
    if isPopToRootVC {
      navigationController.popToRootViewController(animated: true)
    }
  }
  
  func showProducts() {
    showProducts(isPopToRootVC: false)
  }
}

// MARK: - GuestViewControllerOutput
extension TabBarCoordinator: GuestViewControllerOutput {
  func didSelectLogin(from viewController: GuestViewController) {
    guard let navController = viewController.navigationController else { return }
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start(animated: true) { [weak navController] in
      guard var vcs = navController?.viewControllers,
        vcs.count > 1 else { return }
      vcs.remove(at: vcs.count - 2)
      navController?.viewControllers = vcs
    }
    authCoordinator.output = self
  }
  
  func didTapOnClose(from viewController: GuestViewController) {
    viewController.navigationController?.dismiss(animated: true)
  }
}

// MARK: - AuthCoordinatorOutput
extension TabBarCoordinator: AuthCoordinatorOutput {
  func didAuthorize() {
    if !showProfileFormIfNeeded() {
      showDiscountIfNeeded()
    }
  }
}

// MARK: - DiscountViewControllerOutput
extension TabBarCoordinator: DiscountViewControllerOutput {
  func showDiscountAgreement(from viewController: DiscountViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(ofType: .discount, keyLocalizator: KeyLocalizator(key: "Дисконтная программа")) else { return }
    webVC.output = self
    let navController = ColoredNavigationController(rootViewController: webVC)
    navigationController.present(navController, animated: true)
  }
}

// MARK: - WebViewControllerOutput
extension TabBarCoordinator: WebViewControllerOutput {
  func back(from: WebViewController) {
    navigationController.dismiss(animated: true)
  }
  
  func successRedirect(from: WebViewController) { }
}

// MARK: - ProfileCoordinatorOutput
extension TabBarCoordinator: ProfileCoordinatorOutput {
  func showMainScreen() {
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.main.rawValue
  }
}

// MARK: - Deeplinks
extension TabBarCoordinator {

  public func showAuthorizationController() {
    closePresentedControllerIfNeeded()
    showLogIn()
  }

  public func showCartController() {
    closePresentedControllerIfNeeded()
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.cart.rawValue
  }

  public func showCatalogController() {
    closePresentedControllerIfNeeded()
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.catalog.rawValue
  }

  public func showCategoryController(with identifier: Int) {
    closePresentedControllerIfNeeded()
    showMainController()
    mainCoordinator?.showCategory(id: identifier)
  }

  public func showProductController(with identifier: String) {
    closePresentedControllerIfNeeded()
    showMainController()
    mainCoordinator?.showProduct(productId: identifier, fullscreen: false)
  }

  public func showProfileController() {
    closePresentedControllerIfNeeded()
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.profile.rawValue
  }

  public func showProfileDataController() {
    closePresentedControllerIfNeeded()
    showProfileController()
    profileCoordinator?.showProfileDataController()
  }

  public func showFavoritesProductsController() {
    closePresentedControllerIfNeeded()
    showProfileController()
    profileCoordinator?.showFavoritesProductsController()
  }

  public func showShopsController() {
    closePresentedControllerIfNeeded()
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.shops.rawValue
  }

  public func showSearchController(text: String) {
    closePresentedControllerIfNeeded()
    showMainController()
    mainCoordinator?.showSearchController(text: text)
  }

  public func showMainController() {
    closePresentedControllerIfNeeded()
    mainTabBarController?.selectedIndex = MainTabBarItemOrder.main.rawValue
  }

  private func closePresentedControllerIfNeeded() {
    let isDiscountControllerPresented = mainTabBarController?.presentedViewController is DiscountViewController
    let isColoredNavigationControllerPresented = navigationController.presentedViewController is ColoredNavigationController

    if isColoredNavigationControllerPresented {
      guard (navigationController.presentedViewController as? ColoredNavigationController)?.viewControllers.last is GuestViewController else { return }
      navigationController.dismiss(animated: false, completion: nil)
    }

    if isDiscountControllerPresented {
      mainTabBarController?.dismiss(animated: false, completion: nil)
    }
  }
}

//
//  CartCoordinator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/5/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol CartCoordinatorOutput: AnyObject {
  func showProducts()
  func showProducts(isPopToRootVC: Bool)
}

class CartCoordinator: Coordinator {
  
  // MARK: - Private variables
  private weak var cartViewController: CartViewController?
  private weak var orderViewController: OrderViewController?
  private weak var resultViewController: OrderResultViewController?
	private weak var locationShopsViewController: LocationShopsViewController?
  private weak var mainCoordinator: MainCoordinator?
  private weak var authCoordinator: AuthCoordinator?
  
  private var orderVCOrder: Order?
  
  // MARK: - Public variables
  weak var output: CartCoordinatorOutput?
  
  // MARK: - Life cycle
  override init(navigationController: UINavigationController) {
    super.init(navigationController: navigationController)
    addObservers()
  }
  
  override func start(completion: (() -> Void)? = nil) {
    showMainCart()
  }
  
  // MARK: - Private
  private func showMainCart() {
    let cartVC = CartViewController(shouldDisplayOnFullScreen: false)
    cartVC.output = self
    navigationController.pushViewController(cartVC, animated: true)
    self.cartViewController = cartVC
  }
  
  private func showGuest() {
    let userTypeVC = UserTypeViewController(shouldDisplayOnFullScreen: true)
    userTypeVC.output = self
    userTypeVC.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(userTypeVC, animated: true)
  }
  
  private func showOrder(removingLastVC: Bool = false) {
    let orderVC = OrderViewController(shouldDisplayOnFullScreen: true)
    orderVC.output = self
    orderVC.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(orderVC, animated: true) { [weak self] in
      guard let self = self else { return }
      if removingLastVC {
        var vcs = self.navigationController.viewControllers
        guard vcs.count > 1 else { return }
        vcs.remove(at: vcs.count - 2)
        vcs.remove(at: vcs.count - 2)
        self.navigationController.viewControllers = vcs
      }
    }
    orderViewController = orderVC
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userWasUpdated),
      name: .userWasUpdated,
      object: nil)
  }
  
  @objc
  private func userWasUpdated() {
    if ProfileService.shared.user != nil {
      if let index = navigationController.viewControllers.firstIndex(where: { $0 is OrderViewController }),
        index < navigationController.viewControllers.count - 1 {
        navigationController.viewControllers.remove(at: index)
      }
    }
  }

  private func proceedToOrder() {
    if let orderViewController = orderViewController {
      navigationController.popToViewController(orderViewController, animated: true)

      self.orderViewController?.continueOrder()
    }
  }
}

// MARK: - CartViewControllerOutput
extension CartCoordinator: CartViewControllerOutput {
	func didTapOnExchangeDetailsLink(from viewController: CartViewController) {
			guard let webVC = ViewControllersFactory.webViewVC(
							ofType: .exchangeDetails,
							keyLocalizator: KeyLocalizator(key: "Обмен украшений")) else { return }
			webVC.output = self
			navigationController.pushViewController(webVC, animated: true)
	}
	
  func showProducts(from viewController: CartViewController) {
    output?.showProducts()
  }
  
  func createOrder(from viewController: CartViewController) {
    if let totalPrice = CartService.shared.cart?.totalPrice,
      let cartItems = CartService.shared.cart?.cartItems {
      EventService.shared.logBeginCheckout(price: totalPrice, ids: cartItems.map { $0.id })
    }
    if ProfileService.shared.user != nil {
      showOrder()
    } else {
      showGuest()
    }
  }
  
  func showProduct(productId: String, from viewController: CartViewController) {
    let mainCoordinator = MainCoordinator(navigationController: navigationController,
                                          shouldDisplayContentOnFullScreen: true)
    mainCoordinator.output = self
    mainCoordinator.showProduct(productId: productId, fullscreen: true)
  }
}

// MARK: - OrderViewControllerOutput
extension CartCoordinator: OrderViewControllerOutput {
  func showWayForPayResult(order: Order, from viewController: OrderViewController) {
    guard let paymentURL = order.paymentInfo.paymentURL else { return }
    self.orderVCOrder = order
    let webVC = WebViewController(url: paymentURL,
                                  redirectURL: order.paymentInfo.redirectURL,
                                  shouldDisplayOnFullScreen: true)
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
  func didTapOnBack(from viewController: OrderViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func showSelectLocationDialog(for deliveryCode: String, location: Location?, withShops: Bool, from viewController: OrderViewController) {
    if let location = location,
       withShops {
      let locationShopsVC = LocationShopsViewController(hostLocation: location,
                                                        shouldDisplayOnFullScreen: true)
      locationShopsVC.output = self
			self.locationShopsViewController = locationShopsVC
      navigationController.pushViewController(locationShopsVC, animated: true)
    } else {
      let locationVC = LocationSearchViewController(deliveryCode: deliveryCode,
                                                    shouldDisplayOnFullScreen: true,
                                                    hostLocation: location)
      locationVC.output = self
      navigationController.pushViewController(locationVC, animated: true)
    }
  }
  
  func showOrderResult(ofType type: ResultType, from viewController: OrderViewController) {
    if case .success(let successOrder) = type {
      EventService.shared.logSuccessOrder(order: successOrder)
    }

    let resultVC = OrderResultViewController(type: type, shouldDisplayOnFullScreen: true)
    resultVC.output = self
    navigationController.pushViewControllerWithFlipAnimation(viewController: resultVC)
  }
  
  func showPublicOffer(from viewController: OrderViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .offer,
            keyLocalizator: KeyLocalizator(key: "Публичная оферта")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
  func showTermsOfUse(from viewController: OrderViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .agreement,
            keyLocalizator: KeyLocalizator(key: "Пользовательское соглашение")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
}

// MARK: - WebViewControllerOutput
extension CartCoordinator: WebViewControllerOutput {
  func back(from: WebViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func successRedirect(from: WebViewController) {
    guard let order = orderVCOrder else { return }
    navigationController.popViewController(animated: true)
    let resultVC = OrderResultViewController(type: .success(order), shouldDisplayOnFullScreen: true)
    resultVC.output = self
    navigationController.pushViewControllerWithFlipAnimation(viewController: resultVC)
    self.orderVCOrder = nil
  }
}

// MARK: - LocationSearchViewControllerOutput
extension CartCoordinator: LocationSearchViewControllerOutput {
  func selectLocation(_ location: Location,
                      deliveryCode: String,
                      parentLocation: Location?,
											on viewController: LocationSearchViewController, shop: NewShopsItem?) {
    orderViewController?.selectLocation(location, parentLocation: parentLocation, shop: shop)

    guard parentLocation == nil else {
      self.proceedToOrder()

      return
    }

    if deliveryCode == "self" {
      let locationShopsVC = LocationShopsViewController(hostLocation: location,
                                                        shouldDisplayOnFullScreen: true)
      locationShopsVC.output = self
			self.locationShopsViewController = locationShopsVC
      navigationController.pushViewController(locationShopsVC, animated: true)
    } else if deliveryCode == "novaposhta_warehouse" {
      let locationVC = LocationSearchViewController(deliveryCode: deliveryCode,
                                                    shouldDisplayOnFullScreen: true,
                                                    hostLocation: location)
      locationVC.output = self
      navigationController.pushViewController(locationVC, animated: true)
    } else if deliveryCode == "novaposhta_courier" {
      let locationVC = LocationSearchViewController(deliveryCode: deliveryCode,
                                                    shouldDisplayOnFullScreen: true,
                                                    hostLocation: location)
      locationVC.output = self
      navigationController.pushViewController(locationVC, animated: true)
    } else if deliveryCode == "novaposhta_parcel_lockers" {
      let locationVC = LocationSearchViewController(deliveryCode: deliveryCode,
                                                    shouldDisplayOnFullScreen: true,
                                                    hostLocation: location)
      locationVC.output = self
      navigationController.pushViewController(locationVC, animated: true)
    } else {
      navigationController.popViewController(animated: true)
    }
  }
  
  func didTapOnBack(from: LocationSearchViewController) {
    navigationController.popViewController(animated: true)
  }
  
}

// MARK: - OrderResultViewControllerOutput
extension CartCoordinator: OrderResultViewControllerOutput {
  func didTapOnClose(resultVC: OrderResultViewController) {
    navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    navigationController.popToRootViewController(animated: false)
  }
  
  func showProducts(from viewController: OrderResultViewController) {
    navigationController.presentedViewController?.dismiss(animated: true)
    navigationController.popToRootViewController(animated: false) {
      self.output?.showProducts(isPopToRootVC: true)
    }
  }
  
  func showBirthday(from viewController: OrderResultViewController) {
    resultViewController = viewController
    let birthdayVC = BirthdayViewController(shouldDisplayOnFullScreen: true)
    birthdayVC.output = self
    navigationController.pushViewController(birthdayVC, animated: true)
  }
}

// MARK: - UserTypeViewControllerOutput
extension CartCoordinator: UserTypeViewControllerOutput {
  func didSMSWasSent(phoneNumber: String, from vc: UserTypeViewController) {
    let smsVC = SMSViewController(phoneNumber: phoneNumber, shouldDisplayOnFullScreen: false)
    smsVC.output = self
    navigationController.pushViewController(smsVC, animated: true)
  }
  
  func didTapOnPrivacyLink(from vc: UserTypeViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .agreement,
            keyLocalizator: KeyLocalizator(key: "Пользовательское соглашение")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
  func didTapOnBack(from viewController: UserTypeViewController) {
    navigationController.popViewController(animated: true)
  }
}

// MARK: - SMSViewControllerOutput
extension CartCoordinator: SMSViewControllerOutput {
  func smsWasConfirmed(from vc: SMSViewController) {
    showOrder(removingLastVC: true)
  }
  
  func didTapOnBack(from vc: SMSViewController) {
    navigationController.popViewController(animated: true)
  }
}

// MARK: - LocationShopsViewControllerOutput
extension CartCoordinator: LocationShopsViewControllerOutput {
	func didTapOnFilter(onlyOpenSelected: Bool, hasJewellerSelected: Bool, showOnlyOpenFilter: Bool, showHasJewellerFilter: Bool) {
		let filtersViewController = ShopsFilterViewController(shouldDisplayOnFullScreen: true)
		filtersViewController.output = self
		filtersViewController.onlyOpen = onlyOpenSelected
		filtersViewController.hasJeweller = hasJewellerSelected
		filtersViewController.showOnlyOpenFilter = showOnlyOpenFilter
		filtersViewController.showHasJewelerFilter = showHasJewellerFilter
		filtersViewController.hidesBottomBarWhenPushed = true
		navigationController.pushViewController(filtersViewController, animated: true)
	}
	
	func selectLocation(_ location: Location, parentLocation: Location, on viewController: LocationShopsViewController, shop: NewShopsItem?) {
    orderViewController?.selectLocation(location, parentLocation: parentLocation, shop: shop)

    self.proceedToOrder()
  }
  
  func didTapOnBack(from: LocationShopsViewController) {
    navigationController.popViewController(animated: true)
  }
}

// MARK: - MainCoordinatorOutput
extension CartCoordinator: MainCoordinatorOutput {
  func showCatalog() {}
  func showDiscountCard() {}

  func showCart() {
    navigationController.popToRootViewController(animated: true, completion: {})
  }
}

// MARK: - BirthdayViewControllerOutput
extension CartCoordinator: BirthdayViewControllerOutput {
  func didTapOnBack(from viewController: BirthdayViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func didSaveBirthday(from viewController: BirthdayViewController) {
    resultViewController?.showGiftReceived()
    navigationController.popViewController(animated: true)
  }
}

extension CartCoordinator: ShopsFilterViewControllerOutput {
	func applyFilters(onlyOpen: Bool, hasJeweller: Bool) {
		locationShopsViewController?.setFilters(onlyOpen: onlyOpen, hasJeweller: hasJeweller)
		navigationController.popViewController(animated: true)
	}
	
	func didTapOnBack(from: ShopsFilterViewController) {
		navigationController.popViewController(animated: true)
	}
}

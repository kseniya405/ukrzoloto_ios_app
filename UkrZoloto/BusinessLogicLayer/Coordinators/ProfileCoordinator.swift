//
//  ProfileCoordinator.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorOutput: AnyObject {
  func showMainScreen()
  func showCart()
  func showDiscountCard()
}

class ProfileCoordinator: Coordinator {
  
  // MARK: - Private varialbes
  private weak var profileViewController: ProfileViewController?
  private weak var profieDataViewController: ProfileDataViewController?
  private weak var authCoordinator: AuthCoordinator?

  // MARK: - Public variables

  public weak var output: ProfileCoordinatorOutput?
  
  // MARK: - Life cycle
  override func start(completion: (() -> Void)? = nil) {
    showProfile()
  }
  
  // MARK: - Private
  private func showProfile() {
    let profileVC = ProfileViewController(shouldDisplayOnFullScreen: false)
    profileVC.output = self
    navigationController.pushViewController(profileVC, animated: true)
    self.profileViewController = profileVC
  }
  
}

// MARK: - ProfileViewControllerOutput
extension ProfileCoordinator: ProfileViewControllerOutput {
  func showDiscountCard() {
    self.output?.showDiscountCard()
  }

  func didTapOnSignIn(from vc: ProfileViewController) {
    let navController = ColoredNavigationController(style: .green)
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start()
    authCoordinator.output = self
    navigationController.present(navController, animated: true)
    self.authCoordinator = authCoordinator
  }
  
  func didTapOnBack(from: ProfileViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func didTapOnShowProfileData(from: ProfileViewController) {
    let vc = ProfileDataViewController(shouldDisplayOnFullScreen: true)
    vc.output = self
    vc.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(vc, animated: true)
  }

  func didTapOnShowFavorites(from vc: ProfileViewController) {
    
    EventService.shared.logViewWishlist()
    
    let vc = FavoritesViewController(shouldDisplayOnFullScreen: true)
    vc.output = self
    vc.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showDiscountAgreement(from viewController: ProfileViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .discount,
            keyLocalizator: KeyLocalizator(key: "Дисконтная программа")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
  func showSite(from viewController: ProfileViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .site,
            keyLocalizator: KeyLocalizator(key: "Укрзолото")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
  func showAgreement(from vc: ProfileViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .agreement,
            keyLocalizator: KeyLocalizator(key: "Пользовательское соглашение")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }

  func showDeleteAccountAgreement(from vc: ProfileViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .deleteAccountAgreement,
            keyLocalizator: KeyLocalizator(key: "Политика удаления аккаунта")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
  func showDeliveryInfo(from vc: ProfileViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .delivery,
            keyLocalizator: KeyLocalizator(key: "Доставка и оплата")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
  func showOffer(from vc: ProfileViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .offer,
            keyLocalizator: KeyLocalizator(key: "Публичная оферта")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
  func showRefundInfo(from vc: ProfileViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .refund,
            keyLocalizator: KeyLocalizator(key: "Возврат и обмен")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
}

extension ProfileCoordinator: ProfileDataViewControllerOutput {
  func didTapOnBack(from vc: ProfileDataViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func didTapOnAddEvent(from vc: ProfileDataViewController) {
    let addEvenVC = AddEventViewController(shouldDisplayOnFullScreen: true)
    addEvenVC.output = self
    navigationController.pushViewController(addEvenVC, animated: true)
  }
}

// MARK: - AddEventViewControllerOutput
extension ProfileCoordinator: AddEventViewControllerOutput {
  func didTapOnSave(event: UkrZolotoInternalEvent) {
    profieDataViewController?.events.append(event)
    profieDataViewController?.updateEvents()
    navigationController.popViewController(animated: true)
  }
  
  func didTapOnBack(from vc: AddEventViewController) {
    navigationController.popViewController(animated: true)
  }
}

// MARK: - WebViewControllerOutput
extension ProfileCoordinator: WebViewControllerOutput {
  func back(from: WebViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func successRedirect(from: WebViewController) { }
}

// MARK: - FavoritesViewControllerOutput
extension ProfileCoordinator: FavoritesViewControllerOutput {
  func didTapOnBack(from vc: FavoritesViewController) {
    navigationController.popViewController(animated: true)
  }

  func showMainScreen(from vc: FavoritesViewController) {
    output?.showMainScreen()
    navigationController.popViewController(animated: false)
  }

  func didTapOnProduct(productId: String, from vc: FavoritesViewController) {
    let mainCoordinator = MainCoordinator(navigationController: navigationController,
                                          shouldDisplayContentOnFullScreen: true)
    mainCoordinator.output = self
    mainCoordinator.showProduct(productId: productId, fullscreen: true)
  }
}

// MARK: - AuthCoordinatorOutput
extension ProfileCoordinator: AuthCoordinatorOutput {
  
  func didAuthorize() {
    ProfileFormService.shared.displayProfileDataIfNeeded(context: navigationController)
  }
}

// MARK: - MainCoordinatorOutput
extension ProfileCoordinator: MainCoordinatorOutput {
  func showCatalog() {}
  
  func showCart() {
    output?.showCart()
  }
}

// MARK: - Deeplinks
extension ProfileCoordinator {

  public func showProfileDataController() {
    let vc = ProfileDataViewController(shouldDisplayOnFullScreen: true)
    vc.output = self
    vc.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(vc, animated: true)
  }

  public func showFavoritesProductsController() {
    
    EventService.shared.logViewWishlist()
    
    let vc = FavoritesViewController(shouldDisplayOnFullScreen: true)
    vc.output = self
    vc.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(vc, animated: true)
  }
}

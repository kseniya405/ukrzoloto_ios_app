//
//  AppCoordinator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
  
  private var mainCoordinator: TabBarCoordinator?
  private var options: [AnyHashable: Any]?
  
  init(navigationController: UINavigationController,
       options: [AnyHashable: Any]? = nil) {
    self.options = options
    super.init(navigationController: navigationController)
  }
  
  override func start(completion: (() -> Void)? = nil) {
    showMain(with: navigationController)
    showAdServicesPopupIfNeeded()
    EventService.shared.logAppStart()
  }
  
  func showUpdatePopup() {
    let popupView = PopupView()
    popupView.setImage(.image(#imageLiteral(resourceName: "update")))
    popupView.setTitle(Localizator.standard.localizedString("Эта версия больше не работает. Пожалуйста, обновите приложение"))
    popupView.setButtonTitle(Localizator.standard.localizedString("Обновить").uppercased())
    popupView.addButtonTarget(self, action: #selector(goToAppStore))
    let viewController = BlurPopupController(blurPopupView: BlurPopupView(contentView: popupView))
    navigationController.present(viewController, animated: true)
  }
  
  private func showMain(with navigationController: UINavigationController) {
    let coordinator = TabBarCoordinator(navigationController: navigationController,
                                        options: options)
    mainCoordinator = coordinator
    coordinator.start()
    self.navigationController = navigationController
  }

  func showAdServicesPopupIfNeeded() {
    AdvertisingService.shared.displayAdRequestDialogue(viewContext: navigationController)
  }
  
  @objc
  private func goToAppStore() {
    if let url = URL(string: Constants.appStoreURL),
    UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
  }
}

// MARK: - Deeplinks

extension AppCoordinator {
  
  public func showMainController() {
    mainCoordinator?.showMainController()
  }
  
  public func showShopsController() {
    mainCoordinator?.showShopsController()
  }

  public func showCartController() {
    mainCoordinator?.showCartController()
  }

  public func showCatalogController() {
    mainCoordinator?.showCatalogController()
  }

  public func showCategoryController(with identifier: Int) {
    mainCoordinator?.showCategoryController(with: identifier)
  }

  public func showProductController(with identifier: String) {
    mainCoordinator?.showProductController(with: identifier)
  }

  public func showProfileController() {
    mainCoordinator?.showProfileController()
  }

  public func showProfileDataController() {
    mainCoordinator?.showProfileDataController()
  }

  public func showFavoritesProductsController() {
    mainCoordinator?.showFavoritesProductsController()
  }
  
  public func showAuthorizationController() {
    mainCoordinator?.showAuthorizationController()
  }

  public func showSearchController(text: String) {
    mainCoordinator?.showSearchController(text: text)
  }
}

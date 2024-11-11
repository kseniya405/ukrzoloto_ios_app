//
//  DeeplinkService.swift
//  UkrZoloto
//
//  Created by user on 13.04.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

private enum DeeplinkScreens: String, CaseIterable {
  case main
  case profile
  case auth
  case cart
  case shops
  case category
  case product
  case search
  case catalog
}

private enum ProfileScreens: String {
  case data
  case favorites
}

protocol DeeplinkServiceOutput: AnyObject {
  func showMainController()
  func showAuthorizationController()
  func showCartController()
  func showCategoryController(with identifier: Int)
  func showProductController(with identifier: String)
  func showProfileController()
  func showProfileDataController()
  func showFavoritesProductsController()
  func showShopsController()
  func showSearchController(text: String)
  func showCatalogController()
}

final class DeeplinkService {
  
  // MARK: - Deeplink service output
  public weak var output: DeeplinkServiceOutput?
  
  // MARK: - Public constants
  public static let shared = DeeplinkService()
  
  // MARK: - Private variables
  private var host: String?
  private var path: String?
	private var deepLinkWasUsed = false
  private var isUserAuthorized: Bool {
    return ProfileService.shared.user != nil
  }
  
  // MARK: - Constructors
  private init() { }
  
  // MARK: - Public methods
  public func handleScreen(with host: String?, and path: String) {
    self.host = host
    self.path = path.removeBackslashes
  }
  
  public func handleScreen(with url: URL) {
//    guard !deepLinkWasUsed,
//						let urlString = url.absoluteString.removingPercentEncoding else { return }
//		deepLinkWasUsed = true
		if let urlString = url.absoluteString.removingPercentEncoding, urlString.contains("catalog") {
			self.output?.showCatalogController()
			return
		}
		self.output?.showMainController()
//    EventService.shared.logUniversalLinkEvent(urlPath: urlString)
  }
  
  public func handleScreen(with data:  [String : Any]) {
//		guard !deepLinkWasUsed else { return }
//    var data = data
    if let path = data["path"] as? String, path.contains("catalog") {
      output?.showCatalogController()
    } else {
      output?.showMainController()
    }
//    data.removeValue(forKey: "path")
//    EventService.shared.logUniversalLinkEvent(data: data)
  }
  
  public func openHandledScreenIfNeeded() {
    guard let host = host, let screen = DeeplinkScreens(rawValue: host) else { return }
    
    switch screen {
    case .main:
      showMainController()
    case .auth:
      showAuthorizationController()
    case .cart:
      showCartController()
    case .category:
      showCategoryController()
    case .product:
      showProductController()
    case .profile:
      showProfileController()
    case .shops:
      showShopsController()
    case .search:
      showSearchController()
    case .catalog:
      showCatalog()
    }
    
    self.host = nil
    self.path = nil
  }
  
  // MARK: - Private methods
  private func showAuthorizationController() {
    guard !isUserAuthorized else {
      output?.showProfileController()
      return
    }
    output?.showAuthorizationController()
  }
  
  private func showMainController() {
    output?.showMainController()
  }
  
  private func showCartController() {
    output?.showCartController()
  }
  
  private func showCategoryController() {
    guard let path = path, let identifier = Int(path) else { return }
    output?.showCategoryController(with: identifier)
  }
  
  private func showProductController() {
    guard let path = path else { return }
    output?.showProductController(with: path)
  }
  
  private func showProfileController() {
    guard let path = path,
          isUserAuthorized,
          let profileScreen = ProfileScreens(rawValue: path) else {
      output?.showProfileController()
      return
    }
    
    switch profileScreen {
    case .data:
      output?.showProfileDataController()
    case .favorites:
      output?.showFavoritesProductsController()
    }
  }
  
  private func showShopsController() {
    output?.showShopsController()
  }
  
  private func showSearchController() {
    guard let searchText = path else { return }
    output?.showSearchController(text: searchText)
  }
  
  private func showCatalog() {
    output?.showCatalogController()
  }
}

//
//  MainCoordinator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/19/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol MainCoordinatorOutput: AnyObject {
  func showCart()
  func showDiscountCard()
  func showCatalog()
}

class MainCoordinator: Coordinator {
  
  // MARK: - Public variables
  weak var output: MainCoordinatorOutput?
  private var categoryPush: CategoryPush?
  
  // MARK: - Private variables
  private weak var mainViewController: MainViewController?
  
  private weak var authCoordinator: AuthCoordinator?

  private var listingWrappers = [ListingVCWrapper]()
  private weak var productSearchViewController: ProductSearchViewController?

  // MARK: - Private constants
  private let shouldDisplayContentOnFullScreen: Bool
  
  // MARK: - Life cycle
  init(navigationController: UINavigationController,
       shouldDisplayContentOnFullScreen: Bool,
       options: [AnyHashable: Any]? = nil) {
    self.shouldDisplayContentOnFullScreen = shouldDisplayContentOnFullScreen
    if let options = options,
      let categoryPush = CategoryPush(options) {
      self.categoryPush = categoryPush
    } else {
      categoryPush = nil
    }
    super.init(navigationController: navigationController)
  }
  
  override func start(completion: (() -> Void)? = nil) {
    addObservers()
    showMain()
  }
  
  // MARK: - Private
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(showCategory(notification:)),
      name: .showCategory, object: nil)
    NotificationCenter.default.addObserver(
    self, selector: #selector(showProduct(notification:)),
    name: .showProduct, object: nil)
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func showMain() {
    let mainVC = MainViewController(shouldDisplayOnFullScreen: false)
    mainVC.output = self
    navigationController.pushViewController(mainVC, animated: true)
    self.mainViewController = mainVC
  }
  
  // MARK: - Interface
  
  func showProduct(productId: String, fullscreen: Bool) {
    let productVC = ProductViewController(productId: productId, shouldDisplayOnFullScreen: fullscreen)
    productVC.output = self
    productVC.hidesBottomBarWhenPushed = fullscreen
    navigationController.pushViewController(productVC, animated: true)
  }

  func showCategory(id: Int) {
    let vc = ListingViewController(categoryId: id,
                                   header: "",
                                   shouldDisplayOnFullScreen: false)
    vc.output = self
    self.navigationController.pushViewController(vc, animated: true)
    listingWrappers.append(ListingVCWrapper(listingVC: vc))
  }

  func showSearchController(text: String) {
    let productSearchVC = ProductSearchViewController(searchText: text, shouldDisplayOnFullScreen: true)
    productSearchVC.output = self
    productSearchVC.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(productSearchVC, animated: true)
    productSearchViewController = productSearchVC
  }
  
  // MARK: - Actions
  @objc
  private func showCategory(notification: NSNotification) {
    guard let categoryPush = notification.userInfo?[Notification.Key.categoryPush] as? CategoryPush else {
      return
    }
    let vc = ListingViewController(categoryId: categoryPush.id,
                                   header: categoryPush.name ?? "",
                                   shouldDisplayOnFullScreen: shouldDisplayContentOnFullScreen)
    vc.output = self
    self.navigationController.pushViewController(vc, animated: true)
    listingWrappers.append(ListingVCWrapper(listingVC: vc))
  }

  @objc
  private func showProduct(notification: NSNotification) {
    guard let productPush = notification.userInfo?[Notification.Key.productPush] as? ProductPush else {
      return
    }
    showProduct(productId: "\(productPush.id)", fullscreen: false)
  }
  
}

// MARK: - MainViewControllerOutput
extension MainCoordinator: MainViewControllerOutput {
  func showCatalog() {
    self.output?.showCatalog()
  }

  func showDiscontHintFor(product: Product) {
//    self.output?.
  }

  func showDiscountCard() {
    self.output?.showDiscountCard()
  }

  func showCategory(_ category: Category) {
    let categoryVC = CategoryViewController(category: category,
                                            shouldDisplayOnFullScreen: shouldDisplayContentOnFullScreen)
    categoryVC.output = self
    navigationController.pushViewController(categoryVC, animated: true)
  }
  
  func showProductDetails(for product: Product) {
    showProduct(productId: "\(product.id)", fullscreen: false)
  }
  
  func didTapOnSearch(in vc: MainViewController) {
    let productSearchVC = ProductSearchViewController(shouldDisplayOnFullScreen: true)
    productSearchVC.output = self
    productSearchVC.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(productSearchVC, animated: true)
    self.productSearchViewController = productSearchVC
  }
  
  func showListing(for categoryId: Int, categoryExternalId: Int?, title: String, from vc: MainViewController) {
    if let categoryExternalId = categoryExternalId {
//      print("++++ logViewCategory -> \(categoryExternalId)")
      RetenoAnalyticsService.logViewCategory(String(categoryExternalId))
    }

    let vc = ListingViewController(categoryId: categoryId,
                                   header: title,
                                   shouldDisplayOnFullScreen: shouldDisplayContentOnFullScreen)
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
    listingWrappers.append(ListingVCWrapper(listingVC: vc))
  }
  
  func showHits(ofType type: HitsType) {
    let vc = HitsViewController(type: type,
                                shouldDisplayOnFullScreen: shouldDisplayContentOnFullScreen)
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showLogin(from vc: MainViewController) {
    let navController = ColoredNavigationController(style: .green)
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start()
    navigationController.present(navController, animated: true)
    self.authCoordinator = authCoordinator
  }
}

// MARK: - CategoryViewControllerOutput
extension MainCoordinator: CategoryViewControllerOutput {
  func didTapOnBack(from: CategoryViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func didTapOnSearch(from: CategoryViewController) {
    let productSearchVC = ProductSearchViewController(shouldDisplayOnFullScreen: true)
    productSearchVC.output = self
    productSearchVC.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(productSearchVC, animated: true)
    self.productSearchViewController = productSearchVC
  }
  
  func showListing(for categoryId: Int, categoryExternalId: Int?, title: String, from viewController: CategoryViewController) {
    if let categoryExternalId = categoryExternalId {
//      print("++++ logViewCategory -> \(categoryExternalId)")
      RetenoAnalyticsService.logViewCategory(String(categoryExternalId))
    }

    let vc = ListingViewController(categoryId: categoryId,
                                   header: title,
                                   shouldDisplayOnFullScreen: false)
    vc.output = self
    self.navigationController.pushViewController(vc, animated: true)
    listingWrappers.append(ListingVCWrapper(listingVC: vc))
  }

  func showLogin(from vc: CategoryViewController) {
    let navController = ColoredNavigationController(style: .green)
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start()
    navigationController.present(navController, animated: true)
    self.authCoordinator = authCoordinator
  }
}

// MARK: - ProductViewControllerOutput
extension MainCoordinator: ProductViewControllerOutput {
  func didTapOnShare(with product: Product) {
    
    EventService.shared.logShareProduct(productSKU: product.sku)
    
    guard let url = URL(string: product.slug.cyrillic()) else { return }
    let items: [Any] = [product.name, url]
    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    navigationController.present(activityVC, animated: true)
  }
  
  func didTapOnBack(from: ProductViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func didTapOnAssociatedProduct(_ product: Product) {
    showProduct(productId: "\(product.id)", fullscreen: shouldDisplayContentOnFullScreen)
  }
  
  func didTapOnBanner(_ banner: Banner) {
    let vc = ListingViewController(categoryId: banner.categoryId,
                                   header: banner.title,
                                   shouldDisplayOnFullScreen: shouldDisplayContentOnFullScreen)
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
    listingWrappers.append(ListingVCWrapper(listingVC: vc))
  }
  
  func didTapOnShowCart(from: ProductViewController) {
    self.output?.showCart()
  }
  
  func didTapOnShowGift(with product: Product, from: ProductViewController) {
    let giftVC = GiftViewController(product: product, shouldDisplayOnFullScreen: true)
    giftVC.output = self
    giftVC.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(giftVC, animated: true)
  }
  
  func didTapOnCredit(with product: Product, variant: Variant, from vc: ProductViewController) {
    
    let creditVC = CreditOptionsViewController(product: product, variant: variant)
    creditVC.output = self
    creditVC.hidesBottomBarWhenPushed = true
    vc.navigationController?.pushViewController(creditVC, animated: true)
  }

  func showLogin(from vc: ProductViewController) {
    let navController = ColoredNavigationController(style: .green)
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start()
    authCoordinator.output = self
    navigationController.present(navController, animated: true)
    self.authCoordinator = authCoordinator
  }
}

// MARK: - ListingViewControllerOutput
extension MainCoordinator: ListingViewControllerOutput {
  func didTapOnProduct(productId: Int, from: ListingViewController) {
    showProduct(productId: "\(productId)", fullscreen: shouldDisplayContentOnFullScreen)
  }
  
  func didTapOnAllCategories() {
    navigationController.popToRootViewController(animated: true)
  }
  
  func didTapOnBack() {
    navigationController.popViewController(animated: true)
  }
  
  func didTapOnSearch() {
    let productSearchVC = ProductSearchViewController(shouldDisplayOnFullScreen: true)
    productSearchVC.output = self
    productSearchVC.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(productSearchVC, animated: true)
    self.productSearchViewController = productSearchVC
  }
  
  func didTapOnFilter(categoryId: Int, sortKind: SortKind, rangeFilters: [RangeFilter], selectFilters: [SelectFilter]) {
    let filterVC = FilterViewController(categoryId: categoryId,
                                        sortKind: sortKind,
                                        rangeFilters: rangeFilters,
                                        selectFilters: selectFilters,
                                        shouldDisplayOnFullScreen: true)
    filterVC.output = self
    let navController = TopToBottomNavigationController(rootViewController: filterVC,
                                                        style: .green)
    navigationController.present(navController,
                                 animated: true)
  }
  
  func showListing(for categoryId: Int, categoryExternalId: Int?, title: String, from vc: ListingViewController) {
    if let categoryExternalId = categoryExternalId {
//      print("++++ logViewCategory -> \(categoryExternalId)")
      RetenoAnalyticsService.logViewCategory(String(categoryExternalId))
    }

    let vc = ListingViewController(categoryId: categoryId,
                                   header: title,
                                   shouldDisplayOnFullScreen: shouldDisplayContentOnFullScreen)
    vc.output = self
    self.navigationController.pushViewController(vc, animated: true)
    listingWrappers.append(ListingVCWrapper(listingVC: vc))
  }
  
  func listingWasDeinit(from vc: ListingViewController) {
    listingWrappers.removeLast()
  }

  func showLogin(from vc: ListingViewController) {
    let navController = ColoredNavigationController(style: .green)
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start()
    navigationController.present(navController, animated: true)
    self.authCoordinator = authCoordinator
  }
}

// MARK: - FilterViewControllerOutput
extension MainCoordinator: FilterViewControllerOutput {
  func didTapOnManyOptions(with filter: SelectFilter, from vc: FilterViewController) {
    let optionsVC = OptionsViewController(filter: filter, shouldDisplayOnFullScreen: true)
    optionsVC.output = self
    vc.navigationController?.pushViewController(optionsVC, animated: true)
  }
  
  func didTapOnCloseFilter() {
    navigationController.dismiss(animated: true)
  }
  
  func didTapOnShowProducts(rangeFilters: [RangeFilter], selectFilters: [SelectFilter]) {
    listingWrappers.last?.listingVC?.setFilters(rangeFilters: rangeFilters,
                                                selectFilters: selectFilters)
    navigationController.dismiss(animated: true)
  }
  
}

// MARK: - OptionsViewControllerOutput
extension MainCoordinator: OptionsViewControllerOutput {
  func didTapOnBack(from optionsVC: OptionsViewController) {
    optionsVC.navigationController?.popViewController(animated: true)
  }
  
  func chooseVariants(for filter: SelectFilter, from optionsVC: OptionsViewController) {
    if let searchResultVC = optionsVC.navigationController?.viewControllers.first as? SearchResultFilterViewController {
      searchResultVC.selectVariants(for: filter)
      optionsVC.navigationController?.popViewController(animated: true)

      return
    }

    if let filterVC = optionsVC.navigationController?.viewControllers.first as? FilterViewController {
      filterVC.selectVariants(for: filter)
      optionsVC.navigationController?.popViewController(animated: true)

      return
    }

    optionsVC.navigationController?.popViewController(animated: true)
  }
}

//MARK: - AuthCoordinatorOutput
extension MainCoordinator: AuthCoordinatorOutput {
  
  func didAuthorize() {
    ProfileFormService.shared.displayProfileDataIfNeeded(context: navigationController)
  }
}

// MARK: - ProductSearchViewControllerOutput
extension MainCoordinator: ProductSearchViewControllerOutput {
  func didTapOnProduct(_ product: Product, in vc: ProductSearchViewController) {
    showProduct(productId: "\(product.id)", fullscreen: shouldDisplayContentOnFullScreen)
  }
  
  func didTapOnBack(from: ProductSearchViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func didTapOnFilter(searchText: String, rangeFilters: [RangeFilter], selectFilters: [SelectFilter], from vc: ProductSearchViewController, initialSearchPageData: SearchPageData) {
    let searchFilterVC = SearchResultFilterViewController(
      searchText: searchText,
      rangeFilters: rangeFilters,
      selectFilters: selectFilters,
      shouldDisplayOnFullScreen: true,
      initialSearchPageData: initialSearchPageData)
    
    searchFilterVC.output = self
    let navController = TopToBottomNavigationController(rootViewController: searchFilterVC,
                                                        style: .green)
    navigationController.present(navController,
                                 animated: true)
  }

  func showLogin(from vc: ProductSearchViewController) {
    let navController = ColoredNavigationController(style: .green)
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start()
    navigationController.present(navController, animated: true)
    self.authCoordinator = authCoordinator
  }
}

// MARK: - SearchResultFilterViewControllerOutput
extension MainCoordinator: SearchResultFilterViewControllerOutput {
  func didTapOnManyOptions(with filter: SelectFilter, from vc: SearchResultFilterViewController) {
    let optionsVC = OptionsViewController(filter: filter, shouldDisplayOnFullScreen: true)
    optionsVC.output = self
    vc.navigationController?.pushViewController(optionsVC, animated: true)
  }
  
  func didTapOnCloseFilter(from vc: SearchResultFilterViewController) {
    navigationController.dismiss(animated: true)
  }
  
  func didTapOnShowProducts(
    rangeFilters: [RangeFilter],
    selectFilters: [SelectFilter],
    from vc: SearchResultFilterViewController,
    searchResult: SearchPageData) {
    productSearchViewController?.setFilters(
      rangeFilters: rangeFilters,
      selectFilters: selectFilters,
      searchResult: searchResult)

    navigationController.dismiss(animated: true)
  }
}

// MARK: - HitsViewControllerOutput
extension MainCoordinator: HitsViewControllerOutput {
  func didTapOnBack(from: HitsViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func didTapOnSearch(from: HitsViewController) {
    let productSearchVC = ProductSearchViewController(shouldDisplayOnFullScreen: true)
    productSearchVC.output = self
    productSearchVC.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(productSearchVC, animated: true)
    self.productSearchViewController = productSearchVC
  }

  func showLogin(from vc: HitsViewController) {
    let navController = ColoredNavigationController(style: .green)
    let authCoordinator = AuthCoordinator(navigationController: navController)
    authCoordinator.start()
    navigationController.present(navController, animated: true)
    self.authCoordinator = authCoordinator
  }
}

// MARK: - GiftViewControllerOutput
extension MainCoordinator: GiftViewControllerOutput {
  func didTapOnBack(from viewController: GiftViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func didSendGift(from viewController: GiftViewController) {
    navigationController.popViewController(animated: true)
  }  
}

//MARK: - CreditOptionsViewControllerOutput

extension MainCoordinator: CreditOptionsViewControllerOutput {

  func creditOptionsViewControllerSelectedCreditOption(viewController: UIViewController) {
    output?.showCart()
    navigationController.popViewController(animated: true)
  }
  
  func creditOptionsViewControllerTappedBack() {
    navigationController.popViewController(animated: true)
  }
}

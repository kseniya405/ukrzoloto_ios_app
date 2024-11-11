//
//  CatalogCoordinator.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 17.04.2022.
//  Copyright © 2022 Brander. All rights reserved.
//

import Foundation

class CatalogCoordinator: Coordinator {

  // MARK: - Private variables
  private weak var catatlogViewController: ListingViewController?

  private var listingWrappers = [ListingVCWrapper]()
  weak var output: MainCoordinatorOutput?

  private weak var authCoordinator: AuthCoordinator?
  private weak var productSearchViewController: ProductSearchViewController?

  private let shouldDisplayContentOnFullScreen = false

  // MARK: - Life cycle
  override func start(completion: (() -> Void)? = nil) {
    showCatalog()
  }

  private func showCatalog() {
    let catatlogVC = ListingViewController(
      categoryId: 112,
      header: Localizator.standard.localizedString("Каталог"),
      shouldDisplayOnFullScreen: false,
      leftNavigationBatItemsType: .discountCard)

    catatlogVC.output = self

    navigationController.pushViewController(catatlogVC, animated: true)
    self.catatlogViewController = catatlogVC
  }

  func showProduct(productId: String, fullscreen: Bool) {
    let productVC = ProductViewController(productId: productId, shouldDisplayOnFullScreen: fullscreen)
    productVC.output = self
    productVC.hidesBottomBarWhenPushed = fullscreen
    navigationController.pushViewController(productVC, animated: true)
  }
}

// MARK: - ListingViewControllerOutput
extension CatalogCoordinator: ListingViewControllerOutput {
  func showDiscountCard() {
    output?.showDiscountCard()
  }

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

    self.productSearchViewController = productSearchVC
    navigationController.pushViewController(productSearchVC, animated: true)
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
      debugPrint("logViewCategory -> \(categoryExternalId)")
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

// MARK: - ProductSearchViewControllerOutput
extension CatalogCoordinator: ProductSearchViewControllerOutput {
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

// MARK: - AuthCoordinatorOutput
extension CatalogCoordinator: AuthCoordinatorOutput {
  func didAuthorize() {
    ProfileFormService.shared.displayProfileDataIfNeeded(context: navigationController)
  }
}

// MARK: - FilterViewControllerOutput
extension CatalogCoordinator: FilterViewControllerOutput {
  func didTapOnManyOptions(with filter: SelectFilter, from vc: FilterViewController) {
    let optionsVC = OptionsViewController(filter: filter, shouldDisplayOnFullScreen: true)
    optionsVC.output = self
    vc.navigationController?.pushViewController(optionsVC, animated: true)
  }

  func didTapOnCloseFilter() {
    navigationController.dismiss(animated: true)
  }

  func didTapOnShowProducts(rangeFilters: [RangeFilter], selectFilters: [SelectFilter]) {
    if let listingVC = navigationController.viewControllers.last as? ListingViewController {
      listingVC.setFilters(rangeFilters: rangeFilters, selectFilters: selectFilters)
    }

    if let productSearchVC = navigationController.viewControllers.last as? ProductSearchViewController {
      productSearchVC.setFilters(rangeFilters: rangeFilters, selectFilters: selectFilters)
    }

    navigationController.dismiss(animated: true)
  }
}

// MARK: - OptionsViewControllerOutput
extension CatalogCoordinator: OptionsViewControllerOutput {
  func didTapOnBack(from optionsVC: OptionsViewController) {
    optionsVC.navigationController?.popViewController(animated: true)
  }

  func chooseVariants(for filter: SelectFilter, from optionsVC: OptionsViewController) {
    guard let filterVC = optionsVC.navigationController?.viewControllers.first as? FilterViewController else {
      optionsVC.navigationController?.popViewController(animated: true)
      return
    }
    filterVC.selectVariants(for: filter)
    optionsVC.navigationController?.popViewController(animated: true)
  }
}

// MARK: - ProductViewControllerOutput
extension CatalogCoordinator: ProductViewControllerOutput {
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

// MARK: - SearchResultFilterViewControllerOutput
extension CatalogCoordinator: SearchResultFilterViewControllerOutput {
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
    productSearchViewController?.setFilters(rangeFilters: rangeFilters,
                                            selectFilters: selectFilters)
    navigationController.dismiss(animated: true)
  }
}

// MARK: - GiftViewControllerOutput
extension CatalogCoordinator: GiftViewControllerOutput {
  func didTapOnBack(from viewController: GiftViewController) {
    navigationController.popViewController(animated: true)
  }

  func didSendGift(from viewController: GiftViewController) {
    navigationController.popViewController(animated: true)
  }
}

// MARK: - CreditOptionsViewControllerOutput
extension CatalogCoordinator: CreditOptionsViewControllerOutput {
  func creditOptionsViewControllerSelectedCreditOption(viewController: UIViewController) {
    output?.showCart()
    navigationController.popViewController(animated: true)
  }

  func creditOptionsViewControllerTappedBack() {
    navigationController.popViewController(animated: true)
  }
}

//
//  ListingViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 06.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit
import PKHUD

enum SortKind: String {
  case success = "default"
  case priceLow = "price_low"
  case priceHigh = "price_high"
  case newHigh = "new_high"
  case saleHigh = "sale_high"
}

enum LoadingState {
  case readyForLoading
  case loading
  case failed
  case finished
}

enum ListingItem {
  case sort(SortCellController)
  case products(ProductsGroupCellController)
  case banner(ImageViewCellController)
  case errorReload(description: String, buttonTitle: String)
  case space(height: CGFloat)
}

protocol ListingViewControllerOutput: AnyObject {
  func didTapOnBack()
  func didTapOnSearch()
  func didTapOnFilter(categoryId: Int, sortKind: SortKind, rangeFilters: [RangeFilter], selectFilters: [SelectFilter])
  func didTapOnAllCategories()
  func didTapOnProduct(productId: Int, from: ListingViewController)
  func showListing(for categoryId: Int, categoryExternalId: Int?, title: String, from viewController: ListingViewController)
  func listingWasDeinit(from vc: ListingViewController)
  func showLogin(from vc: ListingViewController)
  func showDiscountCard()
}

class ListingViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: ListingViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = ListingView()
  
  private var dataSource = [ListingItem]()
  private let categoryId: Int
  private let header: String
  
  private var associatedBanners: [ASTHashedReference: Banner] = [:]
  private var associatedProducts: [ASTHashedReference: [Product]] = [:]
  
  private var isFiltered: Bool = false {
    didSet {
      filterButton.setImage(isFiltered ? #imageLiteral(resourceName: "activeFilterIcon") : #imageLiteral(resourceName: "filterIcon"),
                            for: .normal)
    }
  }
  private let filterButton = ButtonsFactory.filterButtonForNavItem()
  
  private var sortKind: SortKind = .success {
    didSet {
      updateSortKind()
    }
  }
  
  private var state: LoadingState = .readyForLoading
  private var pageForLoading: Int = 1
  
  private var rangeFilters = [RangeFilter]()
  private var selectFilters = [SelectFilter]()

  private var leftNavigationBatItemsType: NavigationBatItemsType = .backButton
  
  // MARK: - Life cycle
  init(categoryId: Int,
       header: String,
       shouldDisplayOnFullScreen: Bool,
       leftNavigationBatItemsType: NavigationBatItemsType = .backButton) {
    self.categoryId = categoryId
    self.header = header
    self.leftNavigationBatItemsType = leftNavigationBatItemsType
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateNavigationBarColor()
  }
  
  deinit {
    output?.listingWasDeinit(from: self)
  }
  
  // MARK: - Setup
  override func initConfigure() {
    super.initConfigure()
    setupView()
    addObservers()
    loadNextPage()
    logViewItemsList()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
    localizeLabels()
  }

  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateProductFavoritesStatus(notification:)),
      name: .didUpdateProductFavoriteStatus,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userWasUpdated),
      name: .userWasUpdated,
      object: nil)
  }
  
  private func setupNavigationBar() {
    navigationItem.title = header
    updateNavigationButtons(isFilterShown: false)
  }
  
  private func updateNavigationButtons(isFilterShown: Bool = true) {
    filterButton.setImage(isFiltered ? #imageLiteral(resourceName: "activeFilterIcon") : #imageLiteral(resourceName: "filterIcon"),
                          for: .normal)
    switch leftNavigationBatItemsType {
    case .backButton:
      addBackNavBarItem()
    case .discountCard:
      addDiscountCardNavBarItem()
    }

    if isFilterShown {
      setNavigationButton(#selector(didTapOnFilter),
                          button: filterButton,
                          side: .right)
      addNavigationButton(#selector(didTapOnSearch),
                          button: ButtonsFactory.searchButtonForNavigationItem(),
                          side: .right)
    } else {
      setNavigationButton(#selector(didTapOnSearch),
                          button: ButtonsFactory.searchButtonForNavigationItem(),
                          side: .right)
    }
  }

  private func addBackNavBarItem() {
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
  }

  private func addDiscountCardNavBarItem() {
    setNavigationButton(#selector(didTapOnDiscountCard),
                        button: ButtonsFactory.discountCardButtonForNavItem(),
                        side: .left)
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  private func logViewItemsList() {
    EventService.shared.logViewItemList(itemCategory: categoryId)
  }
  
  private func setupSelfView() {
    selfView.getRefreshControl().addTarget(self,
                                           action: #selector(refresh),
                                           for: .valueChanged)
    setupTableView()
    setEmptyViewHidden(true)
    selfView.addEmptyViewButtonTarget(self,
                                      action: #selector(didTapOnAllCategories),
                                      for: .touchUpInside)
  }
  
  private func setupTableView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
  
  private func loadNextPage(silently: Bool = false) {
    configureView(state: .loading)
    if !silently {
      HUD.showProgress()
    }
    ProductService.shared.getFilterProducts(for: getFilterKey(for: pageForLoading)) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        self.selfView.getRefreshControl().endRefreshing()
        switch result {
        case .failure:
          self.configureView(state: .failed)
        case .success(let filterData):
          self.setupDataSource(filterData)
        }
      }
    }
  }
  
  private func getFilterKey(for page: Int) -> FilterResponseKey {
    return (page: page,
            categoryId: categoryId,
            sort: sortKind,
            rangeFilters: rangeFilters,
            selectFilters: selectFilters)
  }
  
  private func configureView(state: LoadingState) {
    switch state {
    case .loading,
         .readyForLoading:
      selfView.getTableView().tableFooterView = !dataSource.isEmpty ? selfView.getIndicatorView() : nil
      selfView.getIndicatorView().animatedView.startAnimating()
    case .failed:
      selfView.getTableView().tableFooterView = nil
      selfView.getIndicatorView().animatedView.stopAnimating()
      setError()
    case .finished:
      selfView.getTableView().tableFooterView = nil
      selfView.getIndicatorView().animatedView.stopAnimating()
    }
    self.state = state
  }
  
  override func localize() {
    localizeLabels()
    pageForLoading = 1
    loadNextPage()
  }
  
  private func localizeLabels() {
    let title = Localizator.standard.localizedString("В этой категории пока что нет товаров")
    let subtitle = Localizator.standard.localizedString("Посмотрите наши другие\nтовары")
    let buttonTitle = Localizator.standard.localizedString("Все категории").uppercased()
    selfView.setEmptyView(image: #imageLiteral(resourceName: "emptyProductsIcon"),
                          title: title,
                          subtitle: subtitle,
                          buttonTitle: buttonTitle)
  }
  
  private func setError() {
    guard !isErrorExist() else { return }
    dataSource.append(.space(height: 50))
    dataSource.append(.errorReload(
      description: Localizator.standard.localizedString("Соединение с интернетом\nотсутствует, проверьте соединение\nи попробуйте еще раз"),
      buttonTitle: Localizator.standard.localizedString("Обновить").uppercased()))
    let indexes = [
      IndexPath(row: dataSource.count - 2, section: 0),
      IndexPath(row: dataSource.count - 1, section: 0)]
    selfView.getTableView().insertRows(at: indexes,
                                       with: .automatic)
  }
  
  private func isErrorExist() -> Bool {
    var isExist = false
    for item in dataSource.enumerated() {
      if case ListingItem.errorReload = item.element {
        isExist = true
      }
    }
    return isExist
  }
  
  private func removeErrorRange() -> ClosedRange<Int>? {
    guard isErrorExist() else { return nil }
    for (index, item) in dataSource.enumerated() {
      if case ListingItem.errorReload = item {
        return (index - 1...index)
      }
    }
    return nil
  }
  
  // MARK: - Interface
  func setFilters(rangeFilters: [RangeFilter], selectFilters: [SelectFilter]) {
    self.rangeFilters = rangeFilters
    self.selectFilters = selectFilters
    
    pageForLoading = 1
    loadNextPage()
  }
  
  // MARK: - Private methods
  private func setupDataSource(_ filterData: FilterPageData = .zero) {
    if pageForLoading == 1 && filterData.products.isEmpty {
      setEmptyViewHidden(false)
      dataSource = []
      selfView.getTableView().reloadData()
      configureView(state: .finished)
      return
    }
    setEmptyViewHidden(true)
    if pageForLoading == 1 {
      dataSource.removeAll()
      let sortCellController = sortController(with: Localizator.standard.localizedString("Сортировка"))
      dataSource.append(.sort(sortCellController))
    }
    var newItems = [ListingItem]()
    var groupsCount = filterData.products.count / UIConstants.productsGroupLimit
    if filterData.products.count % UIConstants.productsGroupLimit != 0 {
      groupsCount += 1
    }
    for index in 0..<groupsCount {
      let maxRange = min((index + 1) * UIConstants.productsGroupLimit,
                         filterData.products.count)
      let range = (index * UIConstants.productsGroupLimit ..< maxRange)
      let products = Array(filterData.products[range])
      let groupController = productsGroupController(from: products)
      newItems.append(.products(groupController))
      associatedProducts[ASTHashedReference(groupController)] = products
      if filterData.banners.indices.contains(index) {
        newItems.append(.space(height: 35))
        let banner = filterData.banners[index]
        let imageController = imageCellController(from: banner)
        newItems.append(.banner(imageController))
        newItems.append(.space(height: 50))
        associatedBanners[ASTHashedReference(imageController)] = banner
      }
    }
    
    configureView(state: filterData.products.isEmpty ? .finished : .readyForLoading)
    updateNewItems(newItems)
  }
  
  private func setEmptyViewHidden(_ isHidden: Bool) {
    updateNavigationButtons(isFilterShown: isHidden)
    if isHidden {
      updateIsFiltered()
    }
    selfView.setEmptyViewHidden(isHidden)
  }
  
  private func updateNewItems(_ newItems: [ListingItem]) {
    let removedRange = removeErrorRange()
    let removedIndexes = removedRange?.compactMap { IndexPath(row: $0, section: 0) }
    if let removedRange = removedRange {
      dataSource.removeSubrange(removedRange)
    }
    
    let insertedIndexes = (0..<newItems.count).map { IndexPath(row: self.dataSource.count + $0, section: 0) }
    dataSource.append(contentsOf: newItems)

    let loadedPage = pageForLoading
    pageForLoading += 1
    if loadedPage == 1 {
      selfView.getTableView().reloadData()
    } else {
      selfView.getTableView().performBatchUpdates({
        if let removedIndexes = removedIndexes {
          self.selfView.getTableView().deleteRows(at: removedIndexes, with: .none)
        }
        self.selfView.getTableView().insertRows(at: insertedIndexes, with: .none)
      })
    }
  }
  
  private func updateIsFiltered() {
    let hasSelectedActive = selectFilters.contains { selectFilter -> Bool in
      return selectFilter.variants.contains(where: { $0.status })
    }
    let hasRangeActive = rangeFilters.contains { rangeFilter -> Bool in
      return rangeFilter.maxPrice != rangeFilter.max || rangeFilter.minPrice != rangeFilter.min
    }
    isFiltered = hasSelectedActive || hasRangeActive
  }
  
  private func imageCellController(from banner: Banner) -> ImageViewCellController {
    let imageController = ImageViewCellController()
    imageController.imageViewModel = .url(banner.url, placeholder: #imageLiteral(resourceName: "shopPlaceholder"))
    imageController.delegate = self
    return imageController
  }
  
  private func productsGroupController(from products: [Product]) -> ProductsGroupCellController {
    let productsVM = products.map { ProductTileViewModel(product: $0) }
    let groupController = ProductsGroupCellController()
    groupController.delegate = self
    groupController.setTitle(nil)
    groupController.setShowMoreTitle(nil)
    groupController.setProducts(productsVM)
    return groupController
  }
  
  private func sortController(with title: String) -> SortCellController {
    let sortController = SortCellController()
    sortController.delegate = self
    sortController.setTitle(title)
    return sortController
  }
  
  private func updateSortKind() {
    pageForLoading = 1
    loadNextPage()
  }

  private func updateFavoriteStatus(productId: String, sku: String, isInFavorite: Bool, price: Decimal) {
    guard ProfileService.shared.user != nil else {
      presentCantAddToFavoriteAlert()
      return
    }

    if isInFavorite {
      deleteProductFromFavorites(productId: productId)
    } else {
      addProductToFavorites(productId: productId, sku: sku, price: price)
    }
  }

  private func deleteProductFromFavorites(productId: String) {
    HUD.showProgress()

    ProductService.shared.deleteProductFromFavorites(with: productId) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .success(let items):
          let _ = items

          return

          //TODO: - Replace MindBoxService with new service integration
          //MindBoxService.shared.didEditFavorites(favoritesItems: items)
        case .failure(let error):
          self.handleError(error)
        }
      }
    }
  }

  private func addProductToFavorites(productId: String, sku: String, price: Decimal) {
    HUD.showProgress()

    ProductService.shared.addProductToFavorites(with: productId, sku: sku) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .success(let items):
          let _ = items

          RetenoAnalyticsService.logItemAddedToWishlist(sku, price: price)

          return
        case .failure(let error):
          self.handleError(error)
        }
      }
    }
  }

  private func changeProductFavoritesStatus(productId: String, isInFavorite: Bool) {
    associatedProducts.enumerated().forEach { _, dictionary in
      var products = dictionary.value
      guard let productIndex = products.firstIndex(where: { "\($0.id)" == productId }),
            products[productIndex].isInFavorite != isInFavorite else { return }
      products[productIndex].isInFavorite = isInFavorite
      associatedProducts[dictionary.key] = products

      dataSource.forEach { listingItem in
        switch listingItem {
        case .products(let controller):
          if ASTHashedReference(controller) == dictionary.key {
            controller.setProducts(products.map { ProductTileViewModel(product: $0) })
          }
        case .banner,
             .errorReload,
             .sort,
             .space:
          break
        }
      }
    }
  }

  private func presentCantAddToFavoriteAlert() {
    cantAddToFavorite { [weak self] in
      self?.dismiss(animated: true)
    } onSuccess: { [weak self] in
      guard let self = self else { return }
      self.output?.showLogin(from: self)
    }
  }
  
  // MARK: - Actions
  @objc
  private func refresh() {
    guard state != .loading else { return }
    pageForLoading = 1
    loadNextPage(silently: true)
  }
  
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack()
  }

  @objc
  private func didTapOnDiscountCard() {
    output?.showDiscountCard()
  }
  
  @objc
  private func didTapOnSearch() {
    output?.didTapOnSearch()
  }
  
  @objc
  private func didTapOnFilter() {
    EventService.shared.filterWasOpened()
    output?.didTapOnFilter(categoryId: categoryId,
                           sortKind: sortKind,
                           rangeFilters: rangeFilters,
                           selectFilters: selectFilters)
  }
  
  @objc
  private func didTapOnAllCategories() {
    output?.didTapOnAllCategories()
  }

  @objc
  private func updateProductFavoritesStatus(notification: NSNotification) {
    guard
      let userInfo = notification.userInfo,
      let productId = userInfo[Notification.Key.productId] as? String,
      let isInFavorite = userInfo[Notification.Key.newFavoriteStatus] as? Bool
    else {
      return
    }
    changeProductFavoritesStatus(productId: productId, isInFavorite: isInFavorite)
  }

  @objc
  private func userWasUpdated() {
    pageForLoading = 1
    loadNextPage()
  }
}

// MARK: - UIConstants
private enum UIConstants {
  static let productsGroupLimit = 6
}

// MARK: - UITableViewDataSource
extension ListingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .sort(let controller):
      let cell = selfView.createSortCell(tableView: tableView,
                                         indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    case .products(let controller):
      let cell = selfView.createProductsGroupCell(tableView: tableView,
                                                  indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    case .banner(let controller):
      let cell = selfView.createBannerCell(tableView: tableView,
                                           indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    case .errorReload(let description, let buttonTitle):
      let cell: ErrorReloadingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      cell.configure(description: description, buttonTitle: buttonTitle)
      return cell
    case .space(let height):
      let cell: SpaceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(space: height)
      return cell
    }
  }
  
}

// MARK: - UITableViewDelegate
extension ListingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if case let ListingItem.banner(controller) = dataSource[indexPath.row],
      let banner = associatedBanners[ASTHashedReference(controller)] {
      output?.showListing(
        for: banner.categoryId,
        categoryExternalId: banner.categoryExternalId,
        title: banner.title,
        from: self)
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    guard dataSource.indices.contains(indexPath.row) else { return }
//    switch dataSource[indexPath.row] {
//    case .sort(let controller):
//      controller.view = nil
//    case .products(let controller):
//      controller.view = nil
//    case .banner(let controller):
//      controller.view = nil
//    case .errorReload: break
//    case .space: break
//    }
  }
  
  func tableView(_ tableView: UITableView,
                 willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    if indexPath.row == dataSource.count - 1,
      state == .readyForLoading {
      loadNextPage(silently: true)
    }
  }
  
}

// MARK: - ProductsGroupCellControllerDelegate
extension ListingViewController: ProductsGroupCellControllerDelegate {
  func productCellController(_ controller: ProductsGroupCellController, didSelectProductAt index: Int) {
    guard controller.products.indices.contains(index) else { return }
    output?.didTapOnProduct(productId: controller.products[index].id, from: self)
  }
  
  func productCellController(_ controller: ProductsGroupCellController, didTapOnFavoriteAt index: Int) {
    guard controller.products.indices.contains(index) else { return }
    let product = controller.products[index]
    updateFavoriteStatus(
      productId: "\(product.id)",
      sku: product.sku,
      isInFavorite: product.isInFavorite,
      price: product.price.current)
  }

  func productCellController(_ controller: ProductsGroupCellController, didTapOnDiscountHint index: Int) {
    guard controller.products.indices.contains(index) else { return }

    let product = controller.products[index]
    
    didTapOnDiscountHintFor(product.price)
    //TODO: Implement SHOW DISCOUNT HINT
  }
  
  func didTapOnShowMore(at controller: ProductsGroupCellController) {
    // TODO: Implement
  }

  func didTapOnDiscountHintFor(_ price: Price) {
    EventService.shared.trackDiscountHintAppearing()

    let isAuthorized = ProfileService.shared.user != nil

    let title = isAuthorized ?
    Localizator.standard.localizedString("Ваша Скидка") :
    Localizator.standard.localizedString("Скидка сразу после регистрации")

    var subTitle: String? = nil
    var bottomTitle: String? = nil

    if isAuthorized {
      bottomTitle = Localizator.standard.localizedString("Цена со скидкой")
    } else {
      subTitle = Localizator.standard.localizedString("Зарегистрируйтесь и получите дополнительную скидку и кешбэк на этот товар")
    }

    var alertActions = [AlertAction]()

    if !isAuthorized {
      alertActions.append(AlertAction(
        style: .filled,
        title: Localizator.standard.localizedString("Зарегистрироваться").uppercased(),
        isEmphasized: true) { [weak self] in
          guard let self = self else { return }

          EventService.shared.trackDiscountHintAuthAction()

          self.output?.showLogin(from: self)
        })
    }

    alertActions.append(AlertAction(
      style: .unfilledGreen,
      title: Localizator.standard.localizedString("Закрыть").uppercased(),
      isEmphasized: true) { [weak self] in
        EventService.shared.trackDiscountHintCloaseAction()
        
        self?.dismiss(animated: true)
      })

    showDiscountHintAlert(
      title: title,
      subtitle: subTitle,
      bottomTitle: bottomTitle,
      price: price,
      actions: alertActions)
  }
}

// MARK: - SortCellControllerDelegate
extension ListingViewController: SortCellControllerDelegate {
  func didTapOnSort(at controller: SortCellController) {
    showSortAlert()
  }
  
  private func showSortAlert() {
    let success = AlertAction(
      style: sortKind.rawValue == SortKind.success.rawValue ? .filled : .unfilled,
      title: Localizator.standard.localizedString("По популярности"),
      isEmphasized: false) {
        self.sortKind = .success
    }
    let priceLow = AlertAction(
      style: sortKind.rawValue == SortKind.priceLow.rawValue ? .filled : .unfilled,
      title: Localizator.standard.localizedString("Сначала подешевле"),
      isEmphasized: false) {
        self.sortKind = .priceLow
    }
    let priceHigh = AlertAction(
      style: sortKind.rawValue == SortKind.priceHigh.rawValue ? .filled : .unfilled,
      title: Localizator.standard.localizedString("Сначала подороже"),
      isEmphasized: false) {
        self.sortKind = .priceHigh
      }
    let newHigh = AlertAction(
      style: sortKind.rawValue == SortKind.newHigh.rawValue ? .filled : .unfilled,
      title: Localizator.standard.localizedString("Новинки"),
      isEmphasized: false) {
        self.sortKind = .newHigh
      }
    let saleHigh = AlertAction(
      style: sortKind.rawValue == SortKind.saleHigh.rawValue ? .filled : .unfilled,
      title: Localizator.standard.localizedString("По размеру скидки"),
      isEmphasized: false) {
        self.sortKind = .saleHigh
      }

    showAlert(
      title: Localizator.standard.localizedString("Сортировать как"),
      actions: [success, priceLow, priceHigh, newHigh, saleHigh])
  }
}

// MARK: - ErrorReloadingTableViewCellDelegate
extension ListingViewController: ErrorReloadingTableViewCellDelegate {
  func didTapOnReload() {
    switch state {
    case .loading: break
    case .readyForLoading,
         .failed,
         .finished:
      loadNextPage(silently: true)
    }
  }
  
}

// MARK: - ImageViewCellControllerDelegate
extension ListingViewController: ImageViewCellControllerDelegate {
  func didTapOnImageView(from controller: ImageViewCellController) {
    if let banner = associatedBanners[ASTHashedReference(controller)] {
      output?.showListing(
        for: banner.categoryId,
        categoryExternalId: banner.categoryExternalId,
        title: banner.title,
        from: self)
    }
    
  }
}

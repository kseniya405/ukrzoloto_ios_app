//
//  SearchResultViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 8/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit
import PKHUD

enum SearchResultItem {
  case title(TitleViewCellController)
  case products(ProductsGroupCellController)
}

protocol SearchResultViewControllerOutput: AnyObject {
  func didTapOnBack(from: SearchResultViewController)
  func didTapOnProduct(_ productId: Int, from: SearchResultViewController)
  func didTapOnFilter(searchText: String, rangeFilters: [RangeFilter], selectFilters: [SelectFilter])
  func showLogin(from vc: SearchResultViewController)
}

class SearchResultViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: SearchResultViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = SearchResultView()
  
  private let searchText: String
  private var products = [Product]()
  
  private var state: LoadingState = .readyForLoading
  private var pageForLoading = 1
  
  private var dataSource = [SearchResultItem]()
  
  private var rangeFilters = [RangeFilter]()
  private var selectFilters = [SelectFilter]()
  
  private var isFiltered: Bool = false {
    didSet {
      filterButton.setImage(isFiltered ? #imageLiteral(resourceName: "activeFilterIcon") : #imageLiteral(resourceName: "filterIcon"),
                            for: .normal)
    }
  }
  private let filterButton = ButtonsFactory.filterButtonForNavItem()
  
  // MARK: - Life cycle
  init(searchText: String,
       shouldDisplayOnFullScreen: Bool) {
    self.searchText = searchText
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateNavigationBarColor()
  }
  
  // MARK: - Setup
  override func initConfigure() {
    super.initConfigure()
    setupView()
    logViewSearchResult()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupTableView()
    localize()
  }
  
  private func setupNavigationBar() {
    filterButton.setImage(isFiltered ? #imageLiteral(resourceName: "activeFilterIcon") : #imageLiteral(resourceName: "filterIcon"),
                          for: .normal)
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
    setNavigationButton(#selector(didTapOnFilter),
                        button: filterButton,
                        side: .right)
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  private func setupTableView() {
    selfView.getRefreshControl().addTarget(self,
                                           action: #selector(refresh),
                                           for: .valueChanged)
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
  
  private func logViewSearchResult() {
    EventService.shared.logSearchResults(search: searchText)
  }
  
  private func loadSearch(silently: Bool = false) {
    configureView(state: .loading)
    if !silently {
      HUD.showProgress()
    }
    SearchService.shared.search(for: getSearchResponseInfo()) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        self.selfView.getRefreshControl().endRefreshing()
        switch result {
        case .failure(let error):
          self.configureView(state: .failed)
          self.handleError(error)
        case .success(let searchData):
          self.setDataSource(searchData: searchData)
        }
      }
    }
  }
  
  private func getSearchResponseInfo() -> SearchResponseInfo {
    return (searchText: searchText,
            page: pageForLoading,
            rangeFilters: rangeFilters,
            selectFilters: selectFilters)
  }
  
  private func configureView(state: LoadingState) {
    switch state {
    case .readyForLoading,
         .loading:
      selfView.getTableView().tableFooterView = !dataSource.isEmpty ? selfView.getIndicatorView() : nil
      selfView.getIndicatorView().animatedView.startAnimating()
    case .failed:
      selfView.getTableView().tableFooterView = nil
      selfView.getIndicatorView().animatedView.stopAnimating()
    case .finished:
      selfView.getTableView().tableFooterView = nil
      selfView.getIndicatorView().animatedView.stopAnimating()
    }
    self.state = state
  }
  
  private func configureFilterButton(for searchData: SearchPageData) {
    if pageForLoading == 1,
      rangeFilters.isEmpty,
      selectFilters.isEmpty,
      searchData.products.isEmpty {
      filterButton.isHidden = true
    } else {
      filterButton.isHidden = false
      updateIsFiltered()
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
  
  private func setDataSource(searchData: SearchPageData = .zero) {
    products = searchData.products
    configureFilterButton(for: searchData)
    if pageForLoading == 1 {
      dataSource.removeAll()
      let title = StringComposer.shared.getSearchResultTitle(
        searchText: searchText,
        productsCount: searchData.pagination.total)
      dataSource.append(.title(titleController(with: title)))
    }
    var newItems = [SearchResultItem]()
    let groupController = productsGroupController(from: searchData.products)
    newItems.append(.products(groupController))
    
    let inseredIndexes = (0..<newItems.count).map { IndexPath(row: dataSource.count + $0, section: 0) }
    dataSource.append(contentsOf: newItems)
    
    configureView(state: searchData.products.isEmpty ? .finished : .readyForLoading)
    let loadedPage = pageForLoading
    pageForLoading += 1
    if loadedPage == 1 {
      selfView.getTableView().reloadData()
    } else {
      selfView.getTableView().insertRows(at: inseredIndexes, with: .fade)
    }
  }
  
  private func titleController(with title: String) -> TitleViewCellController {
    let titleController = TitleViewCellController(title: title)
    return titleController
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

  private func presentCantAddToFavoriteAlert() {
    cantAddToFavorite { [weak self] in
      self?.dismiss(animated: true)
    } onSuccess: { [weak self] in
      guard let self = self else { return }
      self.output?.showLogin(from: self)
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
  
  // MARK: - Localization
  override func localize() {
    navigationItem.title = Localizator.standard.localizedString("Результаты поиска")
    pageForLoading = 1
    loadSearch()
  }
  
  // MARK: - Interface
  func setFilters(rangeFilters: [RangeFilter], selectFilters: [SelectFilter]) {
    self.rangeFilters = rangeFilters
    self.selectFilters = selectFilters
    
    pageForLoading = 1
    loadSearch()
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func refresh() {
    guard state != .loading else { return }
    pageForLoading = 1
    loadSearch(silently: true)
  }
  
  @objc
  private func didTapOnFilter() {
    output?.didTapOnFilter(searchText: searchText,
                           rangeFilters: rangeFilters,
                           selectFilters: selectFilters)
  }
}

// MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .title(let controller):
      let cell = selfView.createTitleCell(tableView: tableView,
                                          indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    case .products(let controller):
      let cell = selfView.createProductsGroupCell(tableView: tableView,
                                                  indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    }
  }
  
}

// MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard dataSource.indices.contains(indexPath.row) else { return }
    switch dataSource[indexPath.row] {
    case .title(let controller):
      controller.view = nil
    case .products(let controller):
      controller.view = nil
    }
  }
  
  func tableView(_ tableView: UITableView,
                 willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    if indexPath.row == dataSource.count - 1,
      state == .readyForLoading {
      loadSearch(silently: true)
    }
  }
}

// MARK: - ProductsGroupCellControllerDelegate
extension SearchResultViewController: ProductsGroupCellControllerDelegate {
  func productCellController(_ controller: ProductsGroupCellController, didSelectProductAt index: Int) {
    guard controller.products.indices.contains(index) else { return }
    output?.didTapOnProduct(controller.products[index].id, from: self)
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
  
  func didTapOnShowMore(at controller: ProductsGroupCellController) {
    // TODO: Implement
  }
}

//
//  ProductSearchViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 8/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol ProductSearchViewControllerOutput: AnyObject {
  func didTapOnProduct(_ product: Product, in vc: ProductSearchViewController)
  func didTapOnBack(from: ProductSearchViewController)
  func didTapOnFilter(searchText: String, rangeFilters: [RangeFilter], selectFilters: [SelectFilter], from vc: ProductSearchViewController, initialSearchPageData: SearchPageData)
  func showLogin(from vc: ProductSearchViewController)
}

enum ErrorState {
  case notFound
  case oneDigit
  case initial
  case notError
}

enum ProductSearchItem {
  case title(TitleViewCellController)
  case products(ProductsGroupCellController)
}

class ProductSearchViewController: SearchViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: ProductSearchViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = ProductSearchView(errorView: ProductSearchErrorView())
  
  private var dataSource = [ProductSearchItem]()
  private var associatedProducts: [ASTHashedReference: [Product]] = [:]
  private var searchText: String

  private var initialSearchPageData: SearchPageData = .zero
  
  private var state: LoadingState = .readyForLoading
  private var pageForLoading: Int = 1
  private var errorState: ErrorState = .initial
  
  private var rangeFilters = [RangeFilter]()
  private var selectFilters = [SelectFilter]()
  
  private var isFiltered: Bool = false {
    didSet {
      filterButton.setImage(isFiltered ? #imageLiteral(resourceName: "activeFilterIcon") : #imageLiteral(resourceName: "filterIcon"),
                            for: .normal)
    }
  }
  private let filterButton = ButtonsFactory.filterButtonForNavItem()

  private var isSearchingNow = false
  
  // MARK: - Life cycle
  override init(searchText: String = "", shouldDisplayOnFullScreen: Bool) {
    self.searchText = searchText
    super.init(searchText: searchText,
               shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }

  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateNavigationBarColor()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    HUD.hide()
    view.endEditing(true)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Configuration
  override func initConfigure() {
    setupNavigationBar()
    addObserver()
    setupView()
    localize()
    setInitialView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    loadProductsIfNeeded()
  }

  private func setupView() {
    setupSelfView()
    setupSearchBar()
  }
  
  private func setupNavigationBar() {
    filterButton.setImage(isFiltered ? #imageLiteral(resourceName: "activeFilterIcon") : #imageLiteral(resourceName: "filterIcon"),
                          for: .normal)
    addNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
  }

  private func showFilterNavBarButton() {
    setNavigationButton(#selector(didTapOnFilter),
                        button: filterButton,
                        side: .right)
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  private func addObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
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
  
  private func setupSelfView() {
    view.backgroundColor = UIConstants.SelfView.backgroundColor
    setupTableView()
    selfView.setErrorViewHidden(true)
  }
  
  private func setupTableView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
    selfView.getTableView().keyboardDismissMode = .onDrag
  }
  
  private func setupSearchBar() {
    searchBarDelegate = self
  }
  
  // MARK: - Private func
  private func setDataSource(searchData: SearchPageData = .zero) {
    configureFilterButton(for: searchData)
    if searchData.products.isEmpty,
       (dataSource.isEmpty || pageForLoading == 1) {
      self.dataSource.removeAll()
      setNoFoundView()
      self.removeButtonItemOn(.right)

      return
    }

    errorState = .notError
    self.showFilterNavBarButton()

    if pageForLoading == 1 {
      self.dataSource.removeAll()
      let title = StringComposer.shared.getSearchResultTitle(
        searchText: searchText,
        productsCount: searchData.pagination.total)
      dataSource.append(.title(titleController(with: title)))
    }
    
    var newItems = [ProductSearchItem]()
    var groupsCount = searchData.products.count / UIConstants.productsGroupLimit
    if searchData.products.count % UIConstants.productsGroupLimit != 0 {
      groupsCount += 1
    }
    for index in 0 ..< groupsCount {
      let maxRange = min((index + 1) * UIConstants.productsGroupLimit,
                         searchData.products.count)
      let range = (index * UIConstants.productsGroupLimit ..< maxRange)
      let products = Array(searchData.products[range])
      let groupController = productsGroupController(from: products)
      newItems.append(.products(groupController))
      associatedProducts[ASTHashedReference(groupController)] = products
    }
    
    let insertedIndexes = (0..<newItems.count).map { IndexPath(row: dataSource.count + $0, section: 0) }
    dataSource.append(contentsOf: newItems)
    selfView.setErrorViewHidden(true)
    
    configureView(state: searchData.products.isEmpty ? .finished : .readyForLoading)
    let loadedPage = pageForLoading
    pageForLoading += 1
    if loadedPage == 1 {
      selfView.getTableView().reloadData()
    } else {
      selfView.getTableView().insertRows(at: insertedIndexes, with: .bottom)
    }
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
  
  private func removeFilters() {
    rangeFilters = []
    selectFilters = []
    isFiltered = false
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
  
  private func setInitialView() {
    let text = Localizator.standard.localizedString("Ищем по любому слову в названии товара")
    selfView.setSearchError(text: text,
                            image: #imageLiteral(resourceName: "bigLoopaSearch"))
    configureView(state: .finished)
    errorState = .initial
  }
  
  private func setOneDigitView() {
    let text = Localizator.standard.localizedString("Для поиска введите больше двух символов")
    selfView.setSearchError(text: text,
                            image: #imageLiteral(resourceName: "searchErrorNotFoundImage"))
    configureView(state: .finished)
    errorState = .oneDigit
  }
  
  private func setNoFoundView() {
    let text = Localizator.standard.localizedString("Результатов не найдено\nПроверьте правильность ввода")
    selfView.setSearchError(text: text,
                            image: #imageLiteral(resourceName: "searchErrorNotFoundImage"))
    configureView(state: .finished)
    errorState = .notFound
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

      dataSource.forEach { productSearchItem in
        switch productSearchItem {
        case .products(let controller):
          if ASTHashedReference(controller) == dictionary.key {
            controller.setProducts(products.map { ProductTileViewModel(product: $0) })
          }
        case .title:
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

  private func loadProductsIfNeeded() {
    guard !searchText.isEmpty else { return }
    pageForLoading = 1
    loadSearch(isSilent: false)
  }
  
  // MARK: - Interface
  func setFilters(
    rangeFilters: [RangeFilter],
    selectFilters: [SelectFilter],
    searchResult: SearchPageData = .zero) {
      self.rangeFilters = rangeFilters
      self.selectFilters = selectFilters
      self.pageForLoading = 1

      self.selectFilters.forEach { filterCategory in
        filterCategory.variants.forEach { filter in
          if filter.status == true {
						debugPrint("  ☄️  ********* SHOW RESULT -> \(filter.slug)")
          }
        }
      }

      if !searchResult.products.isEmpty {
        self.initialSearchPageData = searchResult
        self.setDataSource(searchData: searchResult)
      }
    }
  
  // MARK: - Localization
  override func localize() {
    pageForLoading = 1
    navigationItem.title = Localizator.standard.localizedString("Поиск")
    switch errorState {
    case .initial:
      setInitialView()
    case .oneDigit:
      setOneDigitView()
    case .notFound:
      setNoFoundView()
    case .notError:
      loadSearch()
    }
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func didTapOnFilter() {
    EventService.shared.filterWasOpened()

    self.selectFilters.forEach { filterCategory in
      filterCategory.variants.forEach { filter in
        if filter.status == true {
					debugPrint("  ☄️  ********* didTapOnFilter -> \(filter.slug)")
        }
      }
    }

    let copySearchText = self.searchText
    let copyRangeFilters = self.rangeFilters
    let copySelectFilters = self.selectFilters
    let copyInitialSearchPageData = initialSearchPageData

    self.output?.didTapOnFilter(
      searchText: copySearchText,
      rangeFilters: copyRangeFilters,
      selectFilters: copySelectFilters,
      from: self,
      initialSearchPageData: copyInitialSearchPageData)
  }
  
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    guard let kbDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
    animateToBottomOffset(kbSizeValue.cgRectValue.height,
                          duration: kbDuration.doubleValue)
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    animateToBottomOffset(0, duration: 0)
  }
  
  private func animateToBottomOffset(_ offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.selfView.setTableBottomInset(offset)
    }
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
    loadSearch()
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  static let productsGroupLimit = 6
}

// MARK: - UISearchBarDelegate
extension ProductSearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchText = searchText
    removeFilters()
    guard searchText.count > 2 else {
      searchText.count >= 1 ? setOneDigitView() : setInitialView()

      removeButtonItemOn(.right)

      return
    }

    cancelActiveSearch()

    perform(#selector(checkSearchBarText), with: nil, afterDelay: TimeInterval(Constants.searchTimeInterval))
  }
  
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text, searchText.count > 2 else {
      return
    }

    if !isSearchingNow {
      cancelActiveSearch()

      checkSearchBarText()
    }

    view.endEditing(true)
  }

  private func cancelActiveSearch() {
    NSObject.cancelPreviousPerformRequests(
      withTarget: self,
      selector: #selector(checkSearchBarText),
      object: nil)
  }
  
  // MARK: - Private methods
  @objc
  private func checkSearchBarText() {
    pageForLoading = 1
    loadSearch(isSilent: false)
  }
  
  @objc
  private func loadSearch(isSilent: Bool = true) {
    guard self.searchText.count > 2 else {
      self.searchText.count >= 1 ? self.setOneDigitView() : self.setInitialView()
      return
    }
    if !isSilent {
      HUD.showProgress()
    }

    isSearchingNow = true

    configureView(state: .loading)
    SearchService.shared.search(for: getSearchResponseInfo()) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        self.isSearchingNow = false
        HUD.hide()
        
        switch result {
        case .failure(let error):
          self.initialSearchPageData = .zero
          self.configureView(state: .failed)
          self.handleError(error)
        case .success(let searchData):
          self.initialSearchPageData = searchData
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
  
}

// MARK: - UITableViewDataSource
extension ProductSearchViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
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
extension ProductSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
		debugPrint("indexPath.row -> \(indexPath.row)")
    if indexPath.row == dataSource.count - 1, state == .readyForLoading {
      switch dataSource.last {
      case .products(let item):
        if item.products.count == 6 {
          loadSearch()
        } else {
          self.configureView(state: .finished)
        }
      case .title, .none:
        return
      }
    }
  }

}

// MARK: - ProductsGroupCellControllerDelegate
extension ProductSearchViewController: ProductsGroupCellControllerDelegate {
  func productCellController(_ controller: ProductsGroupCellController, didSelectProductAt index: Int) {
    guard let products = associatedProducts[ASTHashedReference(controller)],
    products.indices.contains(index) else { return }
    output?.didTapOnProduct(products[index], in: self)
  }
  
  func productCellController(_ controller: ProductsGroupCellController, didTapOnFavoriteAt index: Int) {
    guard let products = associatedProducts[ASTHashedReference(controller)],
    products.indices.contains(index) else { return }
    let product = products[index]
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

  private func didTapOnDiscountHintFor(_ price: Price) {
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
        self?.dismiss(animated: true)

        EventService.shared.trackDiscountHintCloaseAction()
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

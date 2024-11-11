//
//  CategoryViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/29/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit
import PKHUD

private enum CategoriesItem {
  case subcategories(SubcategoriesCellController)
  case products(ProductsGroupCellController)
  case banner(ImageViewCellController)
}

protocol CategoryViewControllerOutput: ProductDetailsPresentable {
  func didTapOnBack(from: CategoryViewController)
  func didTapOnSearch(from: CategoryViewController)
  func showListing(for categoryId: Int, categoryExternalId: Int?, title: String, from viewController: CategoryViewController)
  func showLogin(from vc: CategoryViewController)
}

class CategoryViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  weak var output: CategoryViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = CategoryView()
  private var dataSource = [CategoriesItem]()
  private var category: Category
  
  // MARK: - Оптимізація даних
  private struct CachedData {
    static let defaultGroupSize = UIConstants.productsGroupLimit
    static let maxSubcategories = UIConstants.maxSubcategoriesCount
    
    var products: [ASTHashedReference: [Product]] = [:]
    var banners: [ASTHashedReference: Banner] = [:]
    
    mutating func clear() {
      products.removeAll(keepingCapacity: true)
      banners.removeAll(keepingCapacity: true)
    }
  }
  
  private var cachedData = CachedData()
  
  // MARK: - Life cycle
  init(category: Category, shouldDisplayOnFullScreen: Bool) {
    self.category = category
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    transitionCoordinator?.animate(alongsideTransition: { _ in
      self.configureNavigationBarColor()
    })
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configureNavigationBarColor()
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
    addObservers()
    setupDataSource()
    loadSaleHits()
    logViewItemsList()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateProductFavoritesStatus(notification:)),
      name: .didUpdateProductFavoriteStatus,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userWasUpdated),
      name: .userWasUpdated,
      object: nil
    )
  }
  
  private func setupNavigationBar() {
    navigationItem.title = category.name
    addNavigationButton(
      #selector(didTapOnBack),
      button: ButtonsFactory.backButtonForNavigationItem(),
      side: .left
    )
    addNavigationButton(
      #selector(didTapOnSearch),
      button: ButtonsFactory.searchButtonForNavigationItem(),
      side: .right
    )
  }
  
  private func configureNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  private func setupSelfView() {
    edgesForExtendedLayout = [.bottom]
    selfView.getRefreshControl().addTarget(
      self,
      action: #selector(refresh),
      for: .valueChanged
    )
    setupTableView()
  }
  
  private func setupTableView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
  
  private func logViewItemsList() {
    EventService.shared.logViewItemList(itemCategory: category.id)
  }
  
  override func localize() {
    loadSaleHits()
  }
  
  // MARK: - Private methods
  private func setupDataSource(_ productsBanners: ProductsBanners = ([], [])) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    dataSource.removeAll(keepingCapacity: true)
    cachedData.clear()
    
    // Додаємо підкатегорії
    let subcategoriesController = createSubcategoriesController()
    dataSource = [.subcategories(subcategoriesController)]
    
    // Додаємо продукти та банери
    setupProductsAndBanners(productsBanners)
    
    CATransaction.commit()
    
    selfView.getTableView().reloadData()
  }
  
  private func createSubcategoriesController() -> SubcategoriesCellController {
    let controller = SubcategoriesCellController(maxCount: CachedData.maxSubcategories)
    controller.delegate = self
    controller.setSubcategories(category.subcategories)
    return controller
  }
  
  private func setupProductsAndBanners(_ data: ProductsBanners) {
    let groupsCount = data.products.count / CachedData.defaultGroupSize
    
    for index in 0..<groupsCount {
      let range = (index * CachedData.defaultGroupSize..<(index + 1) * CachedData.defaultGroupSize)
      let products = Array(data.products[range])
      
      // Додаємо групу продуктів
      let groupController = createProductsGroupController(
        products: products,
        showTitle: index == 0
      )
      dataSource.append(.products(groupController))
      cachedData.products[ASTHashedReference(groupController)] = products
      
      // Додаємо банер якщо є
      let banner = data.banners[index]
        let imageController = createImageController(from: banner)
        dataSource.append(.banner(imageController))
        cachedData.banners[ASTHashedReference(imageController)] = banner
      
    }
  }
  
  private func createImageController(from banner: Banner) -> ImageViewCellController {
    let imageController = ImageViewCellController()
    imageController.imageViewModel = .url(banner.url, placeholder: #imageLiteral(resourceName: "shopPlaceholder"))
    imageController.delegate = self
    return imageController
  }
  
  private func createProductsGroupController(products: [Product], showTitle: Bool) -> ProductsGroupCellController {
    let productsVM = products.map { ProductTileViewModel(product: $0) }
    let groupController = ProductsGroupCellController()
    groupController.delegate = self
    groupController.setTitle(showTitle ? Localizator.standard.localizedString("Хиты продаж") : nil)
    groupController.setShowMoreTitle(nil)
    groupController.setProducts(productsVM)
    return groupController
  }
  
  private func loadSaleHits(silently: Bool = false) {
    if !silently {
      HUD.showProgress()
    }
    
    ProductService.shared.getSaleHits(for: category.id) { [weak self] response in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        
        HUD.hide()
        self.selfView.getRefreshControl().endRefreshing()
        
        switch response {
        case .failure(let error):
          self.handleError(error)
        case .success(let data):
          self.setupDataSource(data)
        }
      }
    }
  }
  
  private func updateFavoriteStatus(productId: String, sku: String, isInFavorite: Bool, price: Decimal) {
    guard ProfileService.shared.user != nil else {
      presentCantAddToFavoriteAlert()
      return
    }
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    isInFavorite ?
    deleteProductFromFavorites(productId: productId) :
    addProductToFavorites(productId: productId, sku: sku, price: price)
    
    CATransaction.commit()
  }
  
  private func deleteProductFromFavorites(productId: String) {
    HUD.showProgress()
    
    ProductService.shared.deleteProductFromFavorites(with: productId) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        
        if case .failure(let error) = result {
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
        
        if case .failure(let error) = result {
          self.handleError(error)
        }
      }
    }
  }
  
  private func changeProductFavoritesStatus(productId: String, isInFavorite: Bool) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    for (key, products) in cachedData.products {
      guard let productIndex = products.firstIndex(where: { "\($0.id)" == productId }),
            products[productIndex].isInFavorite != isInFavorite else { continue }
      
      var updatedProducts = products
      updatedProducts[productIndex].isInFavorite = isInFavorite
      cachedData.products[key] = updatedProducts
      
      updateProductController(for: key, with: updatedProducts)
    }
    
    CATransaction.commit()
  }
  
  private func updateProductController(for key: ASTHashedReference, with products: [Product]) {
    if case let .products(controller) = dataSource.first(where: {
      if case .products(let ctrl) = $0 {
        return ASTHashedReference(ctrl) == key
      }
      return false
    }) {
      controller.setProducts(products.map { ProductTileViewModel(product: $0) })
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
  @objc private func refresh() {
    loadSaleHits(silently: true)
  }
  
  @objc private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc private func didTapOnSearch() {
    output?.didTapOnSearch(from: self)
  }
  
  @objc private func updateProductFavoritesStatus(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let productId = userInfo["productId"] as? String,
          let isInFavorite = userInfo["isInFavorite"] as? Bool else { return }
    
    changeProductFavoritesStatus(productId: productId, isInFavorite: isInFavorite)
  }
  
  @objc private func userWasUpdated() {
    loadSaleHits()
  }
}

// MARK: - Constants
private enum UIConstants {
  static let maxSubcategoriesCount = 6
  static let productsGroupLimit = 6
}

// MARK: - Array Extension
private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let item = dataSource[safe: indexPath.row] else {
      return UITableViewCell()
    }
    
    let cell: AUIReusableTableViewCell
    
    switch item {
    case .subcategories(let controller):
      cell = selfView.createSubcategoriesCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
      
    case .products(let controller):
      cell = selfView.createProductsGroupCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
      
    case .banner(let controller):
      cell = selfView.createBannerCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
    }
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = dataSource[safe: indexPath.row],
          case let .banner(controller) = item,
          let banner = cachedData.banners[ASTHashedReference(controller)] else { return }
    
    output?.showListing(
      for: banner.categoryId,
      categoryExternalId: banner.categoryExternalId,
      title: banner.title,
      from: self
    )
  }
}

// MARK: - SubcategoriesCellControllerDelegate
extension CategoryViewController: SubcategoriesCellControllerDelegate {
  func subcategoriesCellControllerDidChangedState(_ controller: SubcategoriesCellController) {
    let isExpanding = controller.state == .expanded
    
    if let index = dataSource.firstIndex(where: {
      if case .subcategories(let ctrl) = $0 { return ctrl == controller }
      return false
    }) {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      selfView.getTableView().reloadRows(
        at: [IndexPath(row: index, section: 0)],
        with: isExpanding ? .bottom : .top
      )
      CATransaction.commit()
    }
  }
  
  func subcategoriesCellController(_ controller: SubcategoriesCellController,
                                   didSelectCategoryAt index: Int) {
    guard let subcategory = category.subcategories[safe: index] else { return }
    
    output?.showListing(
      for: subcategory.id,
      categoryExternalId: subcategory.categoryExternalId,
      title: subcategory.name,
      from: self
    )
  }
}

// MARK: - ProductsGroupCellControllerDelegate
extension CategoryViewController: ProductsGroupCellControllerDelegate {
  func productCellController(_ controller: ProductsGroupCellController, didSelectProductAt index: Int) {
    guard let products = cachedData.products[ASTHashedReference(controller)],
          let product = products[safe: index] else { return }
    
    output?.showProductDetails(for: product)
  }
  
  func productCellController(_ controller: ProductsGroupCellController, didTapOnFavoriteAt index: Int) {
    guard let products = cachedData.products[ASTHashedReference(controller)],
          let product = products[safe: index] else { return }
    
    updateFavoriteStatus(
      productId: "\(product.id)",
      sku: product.sku,
      isInFavorite: product.isInFavorite,
      price: product.price.current
    )
  }
  
  func productCellController(_ controller: ProductsGroupCellController, didTapOnDiscountHint index: Int) {
    guard let product = controller.products[safe: index] else { return }
    didTapOnDiscountHintFor(product.price)
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

// MARK: - ImageViewCellControllerDelegate
extension CategoryViewController: ImageViewCellControllerDelegate {
  func didTapOnImageView(from controller: ImageViewCellController) {
    guard let banner = cachedData.banners[ASTHashedReference(controller)] else { return }
    
    output?.showListing(
      for: banner.categoryId,
      categoryExternalId: banner.categoryExternalId,
      title: banner.title,
      from: self
    )
  }
}

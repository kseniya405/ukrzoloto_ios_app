//
//  HitsViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 9/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

private enum HitsItem {
  case products(ProductsGroupCellController)
}

protocol HitsViewControllerOutput: ProductDetailsPresentable {
  func didTapOnBack(from: HitsViewController)
  func didTapOnSearch(from: HitsViewController)
  func showLogin(from vc: HitsViewController)
}

class HitsViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  weak var output: HitsViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = CategoryView()
  
  private var dataSource = [HitsItem]()
  private var type: HitsType
  
  private var associatedProducts: [ASTHashedReference: [Product]] = [:]
  
  // MARK: - Life cycle
  init(type: HitsType, shouldDisplayOnFullScreen: Bool) {
    self.type = type
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureNavigationBarColor()
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
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
  }

  private func addObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateProductFavoritesStatus(notification:)),
                                           name: .didUpdateProductFavoriteStatus,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(userWasUpdated),
                                           name: .userWasUpdated,
                                           object: nil)
  }
  
  private func setupNavigationBar() {
    let title: String
    switch type {
    case .discounts:
      title = Localizator.standard.localizedString("Товары со скидками")
    case .novelties:
      title = Localizator.standard.localizedString("Новинки")
    case .saleHits:
      title = Localizator.standard.localizedString("Хиты продаж")
    }
    navigationItem.title = title
    addNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
    addNavigationButton(#selector(didTapOnSearch),
                        button: ButtonsFactory.searchButtonForNavigationItem(),
                        side: .right)
  }
  
  private func configureNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  private func setupSelfView() {
    selfView.getRefreshControl().addTarget(self,
                                           action: #selector(refresh),
                                           for: .valueChanged)
    setupTableView()
  }
  
  private func setupTableView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
  
  override func localize() {
    loadSaleHits()
  }
  
  // MARK: - Private methods
  
  private func setupDataSource(_ products: [Product] = []) {
    dataSource = []
    associatedProducts = [:]
    
    let groupController = productsGroupController(from: products)
    dataSource.append(.products(groupController))
    associatedProducts[ASTHashedReference(groupController)] = products
    selfView.getTableView().reloadData()
  }
  
  private func productsGroupController(from products: [Product]) -> ProductsGroupCellController {
    let productsVM = products.map { ProductTileViewModel(product: $0) }
    let groupController = ProductsGroupCellController()
    groupController.delegate = self
    groupController.setTitle("")
    groupController.setShowMoreTitle(nil)
    groupController.setProducts(productsVM)
    return groupController
  }
  
  private func loadSaleHits(silently: Bool = false) {
    if !silently {
      HUD.showProgress()
    }
    
    ProductService.shared.getHits(ofType: type) { [weak self] response in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
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

      dataSource.forEach { hitItem in
        switch hitItem {
        case .products(let controller):
          if ASTHashedReference(controller) == dictionary.key {
            controller.setProducts(products.map { ProductTileViewModel(product: $0) })
          }
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
    loadSaleHits(silently: true)
  }
  
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func didTapOnSearch() {
    output?.didTapOnSearch(from: self)
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
    loadSaleHits()
  }
}

// MARK: - UIConstants
private enum UIConstants {
  static let maxSubcategoriesCount = 6
  static let productsGroupLimit = 6
}

// MARK: - UITableViewDataSource
extension HitsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .products(let controller):
      let cell = selfView.createProductsGroupCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    }
  }
}

// MARK: - UITableViewDelegate
extension HitsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didEndDisplaying cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    guard dataSource.indices.contains(indexPath.row) else { return }
    switch dataSource[indexPath.row] {
    case .products(let controller):
      controller.view = nil
    }
  }
}

// MARK: - ProductsGroupCellControllerDelegate
extension HitsViewController: ProductsGroupCellControllerDelegate {
  func productCellController(_ controller: ProductsGroupCellController, didSelectProductAt index: Int) {
    guard let products = associatedProducts[ASTHashedReference(controller)],
      products.indices.contains(index) else { return }
    output?.showProductDetails(for: products[index])
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
    //TODO: Implement
  }
}

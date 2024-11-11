//
//  FavoritesViewController.swift
//  UkrZoloto
//
//  Created by user on 23.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol FavoritesViewControllerOutput {
  func didTapOnBack(from vc: FavoritesViewController)
  func showMainScreen(from vc: FavoritesViewController)
  func didTapOnProduct(productId: String, from vc: FavoritesViewController)
}

enum FavoritesItem {
  case products(ProductsGroupCellController)
}

class FavoritesViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  
  var output: FavoritesViewControllerOutput?
  
  // MARK: - Private variables

  private var shouldLoadFavoritesProducts = true
  private var dataSource: [FavoritesItem] = []
  private var associatedProducts: [ASTHashedReference: [Product]] = [:]
  
  // MARK: Private constants
  
  private let selfView = FavoritesView()
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = selfView
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateNavigationBarColor()
    guard shouldLoadFavoritesProducts else { return }
    loadFavoritesProducts()
    shouldLoadFavoritesProducts = false
  }
  
  // MARK: - Overrides methods
  
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  override func localize() {
    localizeLabels()
  }
  
  // MARK: - Private methods
  
  private func configureSelf() {
    setupNavigationBar()
    setupTableView()
    setupView()
    addObservers()
    localizeLabels()
  }
  
  private func setupNavigationBar() {
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem())
  }
  
  private func setupTableView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
  
  private func setupView() {
    selfView.getRefreshControl().addTarget(self,
                                           action: #selector(refresh),
                                           for: .valueChanged)
    selfView.addEmptyViewButtonTarget(self,
                                      action: #selector(backToProducts),
                                      for: .touchUpInside)
  }

  private func addObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateProductFavoritesStatus(notification:)),
                                           name: .didUpdateProductFavoriteStatus,
                                           object: nil)
  }
  
  private func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Избранное")
    let emptyViewTitle = Localizator.standard.localizedString("Нет избранных товаров")
    let emptyViewSubtitle = Localizator.standard.localizedString("Создайте список товаров, которые\nВы желаете купить")
    let emptyViewButtonTitle = Localizator.standard.localizedString("Вернуться к покупкам").uppercased()
    
    selfView.setupEmptyView(image: #imageLiteral(resourceName: "emptyFavoritesIcon"),
                            title: emptyViewTitle,
                            subtitle: emptyViewSubtitle,
                            buttonTitle: emptyViewButtonTitle)
  }

  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  private func loadFavoritesProducts(silently: Bool = false) {
    if !silently {
      HUD.showProgress()
    }
    
    ProductService.shared.getFavoritesProducts { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        self.selfView.getRefreshControl().endRefreshing()
        switch result {
        case .success(let products):
          self.setupDataSource(products)
        case .failure(let error):
          self.handleError(error)
        }
      }
    }
  }
  
  private func setupDataSource(_ products: [Product]) {
    dataSource = []
    associatedProducts = [:]
    
    guard !products.isEmpty else {
      selfView.setEmptyViewHidden(false)
      selfView.getTableView().reloadData()
      return
    }
    
    let productsController = productsGroupController(from: products)
    dataSource.append(.products(productsController))
    associatedProducts[ASTHashedReference(productsController)] = products
    selfView.getTableView().reloadData()
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
        case .failure(let error):
          self.handleError(error)
        }
      }
    }
  }

  private func changeProductFavoritesStatus(productId: String, isInFavorite: Bool) {
    associatedProducts.enumerated().forEach { _, dictionary in
      var products = dictionary.value

      guard !isInFavorite else {
        shouldLoadFavoritesProducts = true
        return
      }

      guard let productIndex = products.firstIndex(where: { "\($0.id)" == productId }) else { return }
      products.remove(at: productIndex)
      associatedProducts[dictionary.key] = products

      dataSource.enumerated().forEach { index, favoritesItem in
        switch favoritesItem {
        case .products(let controller):
          if ASTHashedReference(controller) == dictionary.key {
            controller.setProducts(products.map { ProductTileViewModel(product: $0) })
          }
          selfView.getTableView().reloadSections([index], with: .none)
        }
      }

      if products.isEmpty {
        selfView.setEmptyViewHidden(false)
      }
    }
  }
  
  // MARK: Actions
  
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func refresh() {
    loadFavoritesProducts(silently: true)
  }
  
  @objc
  private func backToProducts() {
    output?.showMainScreen(from: self)
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
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
  
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .products(let productsController):
      let cell = selfView.createProductsGroupCell(tableView: tableView,
                                                  indexPath: indexPath)
      productsController.view = cell.containerView
      return cell
    }
  }
}

// MARK: - ProductsGroupCellControllerDelegate
extension FavoritesViewController: ProductsGroupCellControllerDelegate {
  func productCellController(_ controller: ProductsGroupCellController, didSelectProductAt index: Int) {
    guard let products = associatedProducts[ASTHashedReference(controller)],
          products.indices.contains(index) else { return }
    output?.didTapOnProduct(productId: "\(products[index].id)", from: self)
  }
  
  func productCellController(_ controller: ProductsGroupCellController, didTapOnFavoriteAt index: Int) {
    guard let products = associatedProducts[ASTHashedReference(controller)],
          products.indices.contains(index) else { return }
    deleteProductFromFavorites(productId: "\(products[index].id)")
  }

  func productCellController(_ controller: ProductsGroupCellController, didTapOnDiscountHint index: Int) {
    guard controller.products.indices.contains(index) else { return }

    let product = controller.products[index]

    didTapOnDiscountHintFor(product.price)
    // TODO: Implement SHOW DISCOUNT HINT
  }

  func didTapOnDiscountHintFor(_ price: Price) {
    EventService.shared.trackDiscountHintAppearing()

    let isAuthorized = ProfileService.shared.user != nil

    let title = isAuthorized ?
    Localizator.standard.localizedString("Ваша Скидка") :
    Localizator.standard.localizedString("Скидка сразу после регистрации")

    var subTitle: String?
    var bottomTitle: String?

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
        isEmphasized: true) {})
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
    
  }
}

//
//  MainViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit
import PKHUD

protocol ProductDetailsPresentable: AnyObject {
  func showProductDetails(for product: Product)
}

protocol MainViewControllerOutput: ProductDetailsPresentable {
  func showCategory(_ category: Category)
  func showDiscountCard()
  func didTapOnSearch(in vc: MainViewController)
  func showListing(for categoryId: Int, categoryExternalId: Int?, title: String, from vc: MainViewController)
  func showHits(ofType type: HitsType)
  func showLogin(from vc: MainViewController)
  func showCatalog()
  func showDiscontHintFor(product: Product)
}

class MainViewController: AnimationViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: MainViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = MainView()
  
  private let tableViewController = ScrollableTableViewController()
  private let categoriesController = CategoriesCellController()
  private let bannersController = BannersCellController(cornerRadius: UIConstants.bannerCornerRadius)
  private let compilationsController = CompilationsCellController()
  private let noveltiesController = ProductsGroupCellController()
  private let certsController = BannersCellController()
  private let saleHitsController = ProductsGroupCellController()
  private let superPriceController = CompilationsCellController()
  private let discountsController = ProductsGroupCellController()
  private let contactPhoneController = ContactPhoneCellController()
  private let weekdaysController = AvalibleTimeCellController()
  private let weekendController = AvalibleTimeCellController()
  private let socialsController = SocialsCellController()
  private let contactsController = ContactsViewController()
  
  private var data: MainPageData?
  
  private var socials = ContactsHelper().socials
  
  // MARK: - Life cycle
  override init(shouldDisplayOnFullScreen: Bool) {
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
    let mainNavBarView = MainNavBarView()
    mainNavBarView.addSearchBarDelegate(self)
    subview = mainNavBarView
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    hidePopup()
  }
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    updateTopInset()
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
    loadData()
    addObservers()
  }
  
  private func setupView() {
    setupNavigationBarButtons(shown: false)
    setupBusinessChatButton()
    setupSelfView()
    localizeLabels()
  }
  
  private func setupNavigationBarButtons(shown: Bool) {
    setNavigationButton(#selector(didTapOnDiscountCard),
                        button: ButtonsFactory.discountCardButtonForNavItem(),
                        side: .left)

    if shown {
      setNavigationButton(#selector(search),
                          button: ButtonsFactory.searchButtonForNavigationItem(),
                          side: .right)
    } else {
      navigationItem.rightBarButtonItem = nil
    }
  }

  private func setupBusinessChatButton() {
      let appleChat = ContactsHelper().getSocialModel(socialType: .businessChat)
      socials.insert(appleChat, at: socials.startIndex)
  }
  
  private func setupSelfView() {
    selfView.getRefreshControl().addTarget(self,
                                           action: #selector(refresh),
                                           for: .valueChanged)
    selfView.setEmptyViewHidden(true)
    selfView.addEmptyViewButtonTarget(self,
                                      action: #selector(refresh),
                                      for: .touchUpInside)
    tableViewController.view = selfView.getTableView()
    tableViewController.delegate = self
    bannersController.delegate = self
    categoriesController.delegate = self
    compilationsController.delegate = self
    noveltiesController.delegate = self
    certsController.delegate = self
    saleHitsController.delegate = self
    superPriceController.delegate = self
    discountsController.delegate = self
    contactPhoneController.delegate = self
    socialsController.delegate = self
    contactsController.delegate = self

    reloadCellControllers()
    updateTopInset()
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(hidePopup))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  override func localize() {
    localizeLabels()
    loadData()
  }
  
  private func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Укрзолото")
    let title = Localizator.standard.localizedString("Нет соединения с интернетом")
    let subtitle = Localizator.standard.localizedString("Проверьте Ваше соединение и попробуйте еще раз ...")
    let buttonTitle = Localizator.standard.localizedString("Попробовать еще раз").uppercased()
    selfView.setEmptyView(image: #imageLiteral(resourceName: "noInternet"),
                          title: title,
                          subtitle: subtitle,
                          buttonTitle: buttonTitle)
  }
  
  private func configurePopup() {
    if let lastTimePresented = UserDefaults.standard.object(forKey: UIConstants.userDefaultsLastTimePopupPresented) as? Date {
      if abs(Int(lastTimePresented.timeIntervalSinceNow / 3600)) > 24 {
        presentPopup()
        UserDefaults.standard.set(Date(), forKey: UIConstants.userDefaultsLastTimePopupPresented)
      }
    } else {
      presentPopup()
      UserDefaults.standard.set(Date(), forKey: UIConstants.userDefaultsLastTimePopupPresented)
    }
  }
  
  private func presentPopup() {
    let popupView = selfView.getPopupView()
    if ProfileService.shared.user != nil {
      popupView.changeType(to: .registered)
      popupView.titleLabel.text = Localizator.standard.localizedString("Покупайте с учетом Вашей скидки по дисконтной программе.")
      popupView.actionButton.setTitle(Localizator.standard.localizedString("Перейти в каталог").uppercased(), for: .normal)
      popupView.actionButton.addTarget(self, action: #selector(moveToCategory), for: .touchUpInside)
    } else {
      popupView.changeType(to: .unregistered)
      popupView.titleLabel.text = Localizator.standard.localizedString("Зарегистрируйтесь и станьте участником бонусной программы!")
      popupView.actionButton.setTitle(Localizator.standard.localizedString("Войти / Зарегистрироваться").uppercased(), for: .normal)
      popupView.secondActionButton.setTitle(Localizator.standard.localizedString("Закрыть").uppercased(), for: .normal)
      popupView.actionButton.addTarget(self, action: #selector(moveToLogin), for: .touchUpInside)
      popupView.secondActionButton.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
    }
    popupView.isHidden = false
    UIView.animate(withDuration: 1, animations: {
      self.selfView.showPopupView()
      self.selfView.layoutIfNeeded()
    }, completion: nil)
  }

  private func presentCantAddToFavoriteAlert() {
    cantAddToFavorite { [weak self] in
      self?.dismiss(animated: true)
    } onSuccess: { [weak self] in
      guard let self = self else { return }
      self.output?.showLogin(from: self)
    }
  }

  // MARK: - Private methods
  
  private func loadData(silently: Bool = false) {
    if !silently {
      HUD.showProgress()
    }
    ProductService.shared.getMainPage { [weak self] response in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        self.selfView.getRefreshControl().endRefreshing()
        switch response {
        case .failure(let error):
          self.selfView.setEmptyViewHidden(self.data != nil)
          self.handleError(error)
        case .success(let data):
          self.selfView.setEmptyViewHidden(true)
          let correctedData = MainPageData(banners: data.banners,
                                           cateogries: data.cateogries,
                                           compilations: data.compilations,
                                           novelties: data.novelties.dropLastOdd(),
                                           certs: data.certs,
                                           saleHits: data.saleHits.dropLastOdd(),
                                           superPrice: data.superPrice.dropLastOdd(),
                                           discounts: data.discounts.dropLastOdd())
          self.setupDataSource(correctedData)
          self.configurePopup()
        }
      }
    }
  }
  
  private func setupDataSource(_ data: MainPageData) {
    self.data = data
    let bannersVM = data.banners.map { BannerViewModel(id: $0.id,
                                                       image: ImageViewModel.url($0.url,
                                                                                 placeholder: #imageLiteral(resourceName: "placeholderBanners")))
    }
    self.bannersController.setBanners(bannersVM, currentIndex: 0)
    categoriesController.setCategories(data.cateogries)
    categoriesController.setTitle(Localizator.standard.localizedString("Категории"))
    let compilationsVM = data.compilations.map { BannerViewModel(id: $0.id,
                                                                 image: ImageViewModel.url($0.url,
                                                                                           placeholder: #imageLiteral(resourceName: "placeholderBanners")))
    }
    self.compilationsController.setTitleAndBanners(title: Localizator.standard.localizedString("Наши подборки"), banners: compilationsVM, currentIndex: 0)
    let noveltiesVM = data.novelties.prefix(UIConstants.productsGroupLimit).map { ProductTileViewModel(product: $0) }
    self.noveltiesController.setTitle(Localizator.standard.localizedString("Новинки"))
    self.noveltiesController.setProducts(noveltiesVM)
    self.noveltiesController.setShowMoreTitle(Localizator.standard.localizedString("Смотреть все").uppercased())
    let certsVM = data.certs.map { BannerViewModel(id: $0.id,
                                                   image: ImageViewModel.url($0.image,
                                                                             placeholder: #imageLiteral(resourceName: "placeholderBanners")))
    }
    self.certsController.setBanners(certsVM, currentIndex: 0)
    let saleHitsVM = data.saleHits.prefix(UIConstants.productsGroupLimit).map { ProductTileViewModel(product: $0) }
    self.saleHitsController.setTitle(Localizator.standard.localizedString("Хиты продаж"))
    self.saleHitsController.setProducts(saleHitsVM)
    self.saleHitsController.setShowMoreTitle(Localizator.standard.localizedString("Смотреть все").uppercased())
    let superPriceVM = data.superPrice.map { BannerViewModel(id: $0.id,
                                                             image: ImageViewModel.url($0.url,
                                                                                       placeholder: #imageLiteral(resourceName: "placeholderBanners")))
    }
    self.superPriceController.setTitleAndBanners(title: Localizator.standard.localizedString("Суперцена"), banners: superPriceVM, currentIndex: 0)
    let discountsVM = data.discounts.prefix(UIConstants.productsGroupLimit).map { ProductTileViewModel(product: $0) }
    self.discountsController.setTitle(Localizator.standard.localizedString("Товары со скидками"))
    self.discountsController.setProducts(discountsVM)
    self.discountsController.setShowMoreTitle(Localizator.standard.localizedString("Смотреть все").uppercased())

//    contactsUpdated()
    self.socials = ContactsHelper().socials
    setupBusinessChatButton()
    contactsController.setInfo(socials)

//    let phoneVM = ImageTitleSubtitleViewModel(
//      title: ContactsHelper().formattedPhone,
//      subtitle: Localizator.standard.localizedString("бесплатно по Украине"),
//      image: ImageViewModel.image(#imageLiteral(resourceName: "iconsInfo")))
//    contactPhoneController.setInfo(phoneVM)
//    let workDaysVM = ImageTitleSubtitleViewModel(
//      title: Localizator.standard.localizedString("Пн-Пт"),
//      subtitle: Localizator.standard.localizedString(ContactsHelper().workdayHrs),
//      image: ImageViewModel.image(#imageLiteral(resourceName: "iconsWorkingTime")))
//    weekdaysController.setInfo(workDaysVM)
//    let weekendVM = ImageTitleSubtitleViewModel(
//      title: Localizator.standard.localizedString("Сб-Вс"),
//      subtitle: Localizator.standard.localizedString(ContactsHelper().weekendHrs),
//      image: nil)
//    weekendController.setInfo(weekendVM)
//    socialsController.setInfo(setSupportContent())
    
    self.reloadCellControllers()
  }

  private func addObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateProductFavoritesStatus),
                                           name: .didUpdateProductFavoriteStatus,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(userWasUpdated),
                                           name: .userWasUpdated,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(contactsUpdated),
                                           name: Notification.Name.contactsUpdated,
                                           object: nil)
  }
  
  private func updateTopInset() {
    let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
    selfView.topInset = UIConstants.TableView.top - navBarHeight
  }
  
  private func reloadCellControllers() {
    var cellControllers: [AUITableViewCellController] = []
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    if !bannersController.banners.isEmpty {
      let bannersCellController = AUIElementTableViewCellController(controller: bannersController,
                                                                    cell: selfView.createBannersCell)
      cellControllers.append(bannersCellController)
    }
    if !categoriesController.categoryViewModels.isEmpty {
      let categoryCellController = AUIElementTableViewCellController(controller: categoriesController,
                                                                     cell: selfView.createCategoriesCell)
      cellControllers.append(categoryCellController)
    }
    if !compilationsController.banners.isEmpty {
      let compilationsCellController = AUIElementTableViewCellController(controller: compilationsController,
                                                                         cell: selfView.createCompilationsCell)
      cellControllers.append(compilationsCellController)
    }
    if !noveltiesController.products.isEmpty {
      let noveltiesCellController = AUIElementTableViewCellController(controller: noveltiesController,
                                                                      cell: selfView.createProductsGroupCell)
      cellControllers.append(noveltiesCellController)
    }
    if !certsController.banners.isEmpty {
      let certsCellController = AUIElementTableViewCellController(controller: certsController,
                                                                  cell: selfView.createCertsCell)
      cellControllers.append(certsCellController)
    }
    if !saleHitsController.products.isEmpty {
      let saleHitsCellController = AUIElementTableViewCellController(controller: saleHitsController,
                                                                     cell: selfView.createProductsGroupCell)
      cellControllers.append(saleHitsCellController)
    }
    if !superPriceController.banners.isEmpty {
      let superPriceCellController = AUIElementTableViewCellController(controller: superPriceController,
                                                                       cell: selfView.createCompilationsCell)
      cellControllers.append(superPriceCellController)
    }
    if !discountsController.products.isEmpty {
      let discountsCellController = AUIElementTableViewCellController(controller: discountsController,
                                                                      cell: selfView.createProductsGroupCell)
      cellControllers.append(discountsCellController)
    }

    cellControllers.append(AUIElementTableViewCellController(controller: contactsController,
                                                             cell: selfView.createContactsCell))

//    cellControllers.append(AUIElementTableViewCellController(controller: contactPhoneController,
//                                                             cell: selfView.createPhoneNumberCell))
    cellControllers.append(AUIElementTableViewCellController(controller: weekdaysController,
                                                             cell: selfView.createTimeCell))
//    cellControllers.append(AUIElementTableViewCellController(controller: weekendController,
//                                                             cell: selfView.createTimeCell))
//    cellControllers.append(AUIElementTableViewCellController(controller: socialsController,
//                                                             cell: selfView.createImageTitleImagesCell))
    
    let sectionController = AUIDefaultTableViewSectionController()
    sectionController.cellControllers = cellControllers
    tableViewController.sectionControllers = [sectionController]
    tableViewController.reload()
    CATransaction.commit()

  }
  
  private func setSupportContent() -> ImageTitleImagesViewModel {
    let viewModel = ImageTitleImagesViewModel(
      title: Localizator.standard.localizedString("Поддержка"),
      image: ImageViewModel.image(#imageLiteral(resourceName: "iconsSupport")),
      images: socials.compactMap { ImageViewModel.image($0.image) })
    
    return viewModel
  }

  private func updateFavoriteStatus(
    productId: String,
    sku: String,
    isInFavorite: Bool,
    price: Decimal) {
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

  // MARK: - Actions
  
  @objc
  private func refresh() {
    loadData(silently: true)
  }

  @objc
  private func didTapOnDiscountCard() {
    output?.showDiscountCard()
  }
  
  @objc
  private func search() {
    output?.didTapOnSearch(in: self)
  }
  
  @objc
  private func hidePopup(sender: Any? = nil) {
    if let sender = sender as? UIGestureRecognizer,
       selfView.getPopupView().frame.contains(sender.location(in: view)) {
      return
    }
    guard !selfView.getPopupView().isHidden else { return }
    UIView.animate(
      withDuration: 1,
      delay: 0,
      options: .beginFromCurrentState,
      animations: { [weak self] in
      self?.selfView.hidePopupView()
      self?.selfView.layoutIfNeeded()
    }, completion: { _ in
      self.selfView.getPopupView().isHidden = true
    })
  }
  
  @objc
  private func moveToCategory(sender: Any? = nil) {
    output?.showCatalog()
    hidePopup()
  }
  
  @objc
  private func moveToLogin() {
    output?.showLogin(from: self)
    hidePopup()
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

    let productsControllers = [noveltiesController, saleHitsController, discountsController]

    productsControllers.forEach { productController in
      var products = productController.products
      guard let productIndex = products.firstIndex(where: { "\($0.id)" == productId }),
            products[productIndex].isInFavorite != isInFavorite else { return }
      products[productIndex].isInFavorite = isInFavorite
      productController.setProducts(products)
    }
  }

  @objc
  private func userWasUpdated() {
    loadData()
  }
  
  @objc private func contactsUpdated() {
//    self.socials = ContactsHelper().socials
//    setupBusinessChatButton()
//    contactsController.setInfo(socials)
  }
}

private enum UIConstants {
  enum TableView {
    static let top: CGFloat = 157
  }
  
  static let productsGroupLimit = 6
  static let bannerCornerRadius: CGFloat = 0
  static let userDefaultsLastTimePopupPresented = "MainScreenLastTimePopupPresented"
}

// MARK: - ScrollableTableViewControllerDelegate
extension MainViewController: ScrollableTableViewControllerDelegate {
  func tableViewDidScroll() {
    let tableView = selfView.getTableView()
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    let offset = UIConstants.TableView.top + tableView.contentOffset.y + height
    animate(to: offset)
    setupNavigationBarButtons(shown: offset > 0)
    hidePopup()
  }
}

// MARK: - BannersCellControllerDelegate
extension MainViewController: BannersCellControllerDelegate {
  func bannerCellController(_ controller: BannersCellController, didSelectBannerAt index: Int) {
    if controller === bannersController {
      guard controller.banners.indices.contains(index),
        let banner = data?.banners.first(where: { $0.id == controller.banners[index].id }) else {
          return
      }
      output?.showListing(for: banner.categoryId, categoryExternalId: banner.categoryExternalId, title: banner.title, from: self)
    } else if controller === certsController {
      guard let product = data?.certs.first(where: { $0.id == controller.banners[index].id }) else {
        return
      }
      output?.showProductDetails(for: product)
    }
  }
}

// MARK: - CompilationsCellControllerDelegate
extension MainViewController: CompilationsCellControllerDelegate {
  func compilationsCellController(_ controller: CompilationsCellController, didSelectCompilationAt index: Int) {
    if controller === compilationsController {
      guard controller.banners.indices.contains(index),
        let banner = data?.compilations.first(where: { $0.id == controller.banners[index].id }) else {
          return
      }
      output?.showListing(for: banner.categoryId, categoryExternalId: banner.categoryExternalId, title: banner.title, from: self)
    }
    
    if controller === superPriceController {
      guard controller.banners.indices.contains(index),
        let banner = data?.superPrice.first(where: { $0.id == controller.banners[index].id }) else {
          return
      }
      output?.showListing(for: banner.categoryId, categoryExternalId: banner.categoryExternalId, title: banner.title, from: self)
    }
  }
}

// MARK: - ProductsGroupCellControllerDelegate
extension MainViewController: ProductsGroupCellControllerDelegate {
  func productCellController(_ controller: ProductsGroupCellController, didSelectProductAt index: Int) {
    guard controller.products.indices.contains(index) else { return }
    var product: Product?
    if controller === noveltiesController {
      product = data?.novelties.first(where: { $0.id == controller.products[index].id })
    } else if controller === saleHitsController {
      product = data?.saleHits.first(where: { $0.id == controller.products[index].id })
    } else if controller === discountsController {
      product = data?.discounts.first(where: { $0.id == controller.products[index].id })
    }
    guard let unwrappedProduct = product else { return }
    output?.showProductDetails(for: unwrappedProduct)
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
  
  func didTapOnShowMore(at controller: ProductsGroupCellController) {
    if controller === noveltiesController {
      output?.showHits(ofType: .novelties)
    } else if controller === saleHitsController {
      output?.showHits(ofType: .saleHits)
    } else if controller === discountsController {
      output?.showHits(ofType: .discounts)
    }
  }

  func productCellController(_ controller: ProductsGroupCellController, didTapOnDiscountHint index: Int) {
    guard controller.products.indices.contains(index) else { return }

    let product = controller.products[index]

    didTapOnDiscountHintFor(product.price)
//    TODO: Implement SHOW DISCOUNT HINT
  }

  private func didTapOnDiscountHintFor(_ price: Price) {
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

// MARK: - CategoriesCellControllerDelegate
extension MainViewController: CategoriesCellControllerDelegate {
  func categoriesCellController(_ controller: CategoriesCellController, didSelectCategorytAt index: Int) {
    guard let categories = data?.cateogries,
      categories.indices.contains(index) else { return }
    output?.showCategory(categories[index])
  }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    output?.didTapOnSearch(in: self)
    searchBar.endEditing(true)
  }
}

// MARK: - ContactPhoneCellControllerDelegate
extension MainViewController: ContactPhoneCellControllerDelegate {
  func didTapOnPhone() {
    if let url = URL(string: "tel://\(ContactsHelper().phone)"), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
  }
}

// MARK: - SocialsCellControllerDelegate
extension MainViewController: SocialsCellControllerDelegate, ContactsCellControllerDelegate {
  func didTapOnImage(with index: Int) {
    guard socials.count > index else { return }
    let selectedSocial = socials[index]
    openSocial(selectedSocial)
  }

  private func openSocial(_ social: Social) {
    guard let socialWebURL = URL(string: social.webUrl),
          UIApplication.shared.canOpenURL(socialWebURL) else { return }
    UIApplication.shared.open(socialWebURL, options: [:], completionHandler: nil)
  }
}

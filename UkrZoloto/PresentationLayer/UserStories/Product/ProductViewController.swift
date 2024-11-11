//
//  ProductViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 24.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD
import Lightbox

protocol ProductViewControllerOutput: AnyObject {
  func didTapOnBack(from: ProductViewController)
  func didTapOnShare(with product: Product)
  func didTapOnAssociatedProduct(_ product: Product)
  func didTapOnBanner(_ banner: Banner)
  func didTapOnShowCart(from: ProductViewController)
  func didTapOnShowGift(with product: Product, from: ProductViewController)
  func showLogin(from vc: ProductViewController)
  func didTapOnCredit(with product: Product, variant: Variant, from vc: ProductViewController)
}

class ProductViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  // MARK: - Public variables
  var output: ProductViewControllerOutput?

  // MARK: - Private variables
  private var productId: String
  private var product: Product? {
    didSet {
      selfView.product = product
    }
  }
  private var variant: Variant? {
    didSet {
      selfView.variant = variant
    }
  }
  private var associatedProducts = [Product]() {
    didSet {
      selfView.associatedProducts = associatedProducts
    }
  }
  private var banner: Banner? {
    didSet {
      selfView.banner = banner
    }
  }
  private let selfView: ProductView
  
  private let shareButton = ButtonsFactory.shareButtonForNavItem()
  private let favouriteButton = ButtonsFactory.favouriteButtonForNavItem()
  private let cartButton = ButtonsFactory.cartButtonForNavigationItem()
  private let bannersController = BannersCellController()
  private var lightboxController: LightboxController?
  
  private weak var popupView: UIView?
  
  private var dataSource = [String]()
  private var socials = ContactsHelper().socials
  
  private var analyticsWasSent = false
  
  // MARK: - Life cycle
  init(productId: String,
       shouldDisplayOnFullScreen: Bool) {
    self.productId = productId
    self.selfView = ProductView()
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
    self.selfView.sizeCollectionViewController = self
    self.selfView.delegate = self
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    edgesForExtendedLayout = [.top, .bottom]
    extendedLayoutIncludesOpaqueBars = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    transitionCoordinator?.animate(alongsideTransition: { _ in
      self.updateNavigationBarColor()
    })
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateNavigationBarColor()
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
    loadData()
    setupObservers()
  }
  
  private func setupView() {
    setupNavigationBar()
    setClearNavBar()
    setupBusinessChatButton()
    selfView.getKnowSizeButton().addTarget(self,
                                           action: #selector(showSizeHelp),
                                           for: .touchUpInside)
  }
  
  private func setupNavigationBar() {
    favouriteButton.setImage(#imageLiteral(resourceName: "favoriteImageDeselected"),
                             for: .normal)
    setNavigationButton(#selector(didTapOnFavourite),
                        button: favouriteButton,
                        side: .right)
    addNavigationButton(#selector(didTapOnCart),
                        button: cartButton,
                        side: .right)
    addNavigationButton(#selector(didTapOnShare),
                        button: shareButton,
                        side: .right)
  }
  
  private func setClearNavBar() {
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.greenBackButtonForNavItem(),
                        side: .left)
    shareButton.setImage(#imageLiteral(resourceName: "blackShare"), for: .normal)
    navigationItem.title = nil
    updateCartButtonIcon(isGreenNavBar: false)
  }

  private func setGreenNavBar() {
    guard let product = product else { return }
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
    shareButton.setImage(#imageLiteral(resourceName: "whiteShare"), for: .normal)
    navigationItem.title = product.name
    updateCartButtonIcon(isGreenNavBar: true)
  }

  private func setupBusinessChatButton() {
      let appleChat = ContactsHelper().getSocialModel(socialType: .businessChat)
      socials.insert(appleChat, at: socials.startIndex)
  }
  
  private func updateCartButtonIcon(isGreenNavBar: Bool) {
    let isEmpty: Bool = CartService.shared.cart?.cartItems.isEmpty ?? true
    if isGreenNavBar {
      cartButton.setImage(isEmpty ? #imageLiteral(resourceName: "iconsBasket") : #imageLiteral(resourceName: "basketWhiteDot"), for: .normal)
      cartButton.tintColor = UIColor.white
    } else {
      cartButton.setImage(isEmpty ? #imageLiteral(resourceName: "iconsBasket") : #imageLiteral(resourceName: "CartFull"), for: .normal)
      cartButton.tintColor = UIColor.black
    }
  }
  
  private func updateNavigationBarColor() {
    update(with: selfView.getCurrentOffset())
  }
  
  private func logViewProductEvent() {
    EventService.shared.logViewItem(itemId: productId)

    if let product = product {
      RetenoAnalyticsService.logViewItem(product)
    }
  }
  
  private func setupBanners() {
    bannersController.delegate = self
    bannersController.bannersView = selfView.getBannersView()
    bannersController.setBanners(getBannersViewModel(), currentIndex: 0)
    configureLightboxController()
  }
  
  private func getBannersViewModel() -> [BannerViewModel] {
    return product?.imagesURL.compactMap { BannerViewModel(id: UUID().hashValue,
                                                           image: ImageViewModel.url($0, placeholder: #imageLiteral(resourceName: "placeholderProduct"))) } ?? []
  }
  
  private func configureLightboxController(at index: Int = 0) {
    configureLightboxAppearance()
    
    let images = product?.imagesURL.compactMap { LightboxImage(imageURL: $0) } ?? []
    let controller = LightboxController(images: images, startIndex: index)
    controller.modalPresentationStyle = .fullScreen
    controller.pageDelegate = self
    controller.dismissalDelegate = self
    controller.dynamicBackground = true
    self.lightboxController = controller
  }
  
  private func configureLightboxAppearance() {
    LightboxConfig.CloseButton.image = #imageLiteral(resourceName: "controlsClose")
    LightboxConfig.CloseButton.text = ""
  }
  
  private func setupDataSource() {
    dataSource = product?.availableVariants.filter { $0.quantity != 0 }.compactMap { $0.size?.title } ?? []
    selfView.getSizeCollectionView().reloadData()
  }
  
  private func loadData(completion: (() -> Void)? = nil) {
    HUD.showProgress()
    ProductService.shared.getProduct(productId: productId) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let receivedProduct):
          self.product = receivedProduct

          if let variantFromMultiSizedProduct = receivedProduct.availableVariants.first(where: { $0.price.current == receivedProduct.price.current }) {
            self.variant = variantFromMultiSizedProduct
          } else {
            guard let oneSizedProductVariant = receivedProduct.variants.first else {
              return
            }

            self.variant = oneSizedProductVariant
          }
          
          self.selfView.loadView()
          self.configureSelfView()
          self.updateFavoritesButton()
          
          self.setupBanners()
          self.setupDataSource()

          self.localize()

          if receivedProduct.hasSize {
            let row = receivedProduct.availableVariants.firstIndex(where: { $0.price.current == receivedProduct.price.current }) ?? 0

            self.selfView.getSizeCollectionView().selectItem(at: IndexPath(row: row, section: 0),
                                                             animated: false,
                                                             scrollPosition: .top)
          }
          
          if !self.analyticsWasSent {
            self.analyticsWasSent = true
            self.logViewProductEvent()
          }
          completion?()
        }
        
        ProductService.shared.getAssociatedProducts(productId: self.productId) { [weak self] associatedResult in
          DispatchQueue.main.async {
            guard let self = self else { return }
            switch associatedResult {
            case .failure(let error):
              print(error)
            case .success(let associatedData):
              self.associatedProducts = associatedData.products
              self.banner = associatedData.banners.first
            }
          }
        }
      }
    }
    
  }
  
  private func configureSelfView() {
    selfView.addHotLineTarget(self, action: #selector(makeCall))
    selfView.addHintViewTarget(self, action: #selector(showGift))
    selfView.addCartTarget(self, action: #selector(addToCart))
    selfView.addUserRegistrationTarget(self, action: #selector(registerNewUser))
    selfView.addCreditTarget(self, action: #selector(openCreditOptions))
    selfView.addSupportSocialDelegate(self)
  }

  private func updateFavoritesButton() {
    guard let product = product else { return }
    favouriteButton.setImage(product.isInFavorite ? #imageLiteral(resourceName: "iconsFavoriteFull") : #imageLiteral(resourceName: "favoriteImageDeselected"), for: .normal)
  }

  private func setupObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(cartDidChange),
                                           name: .cartWasUpdated,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateProductFavoritesStatus(notification:)),
                                           name: .didUpdateProductFavoriteStatus,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(userWasUpdated),
                                           name: .userWasUpdated,
                                           object: nil)
  }
  
  // MARK: - Localization
  override func localize() {
    guard let variant = variant else { return }
    selfView.setupValues(for: variant,
                         socials: socials)
  }

  private func update(with offset: CGFloat) {
    if offset > 0 {
      setGreenNavBar()
      (navigationController as? ColoredNavigationController)?.configure(with: .green)
    } else {
      setClearNavBar()
      (navigationController as? ColoredNavigationController)?.configure(with: .clear)
    }
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

  private func changeProductFavoritesStatus(productId: String, isInFavorite: Bool) {
    guard var product = product,
          "\(product.id)" == productId,
          product.isInFavorite != isInFavorite else { return }
    product.isInFavorite = isInFavorite
    self.product = product
    updateFavoritesButton()
  }

  private func changeAssociatedProductsFavoritesStatus(productId: String, isInFavorite: Bool) {
    guard let productIndex = associatedProducts.firstIndex(where: { "\($0.id)" == productId }) else { return }
    var updatedAssociatedProducts = associatedProducts
    updatedAssociatedProducts[productIndex].isInFavorite = isInFavorite
    self.associatedProducts = updatedAssociatedProducts
  }

  private func presentCantAddToFavoriteAlert() {
    cantAddToFavorite { [weak self] in
      self?.dismiss(animated: true)
    } onSuccess: { [weak self] in
      guard let self = self else { return }
      self.output?.showLogin(from: self)
    }
  }

  private func isInCart() -> Bool {
    guard let currentVariant = self.variant else { return false }

    let variantInCart = CartService.shared.cart?.cartItems.first(where: { $0.id == currentVariant.id })

    return variantInCart != nil
  }

  // MARK: - Actions
  
  @objc
  private func addToCart() {

    guard let variant = variant else { return }
    
    HUD.showProgress()
    if isInCart() {
      output?.didTapOnShowCart(from: self)
    } else {
      CartService.shared.addToCartVariantBy(variantId: variant.id, sku: variant.sku) { [weak self] result in
        DispatchQueue.main.async {
          HUD.hide()
          guard let self = self else { return }
          switch result {
          case .failure(let error):
            self.handleError(error)
          case .success:
            EventService.shared.logAddToCart(productId: variant.id,
                                             name: variant.name,
                                             price: variant.price.current)

            self.popupView = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?
              .showAddedToCartPopup(with: Localizator.standard.localizedString("Товар добавлен в корзину"))
          }
        }
      }
    }
  }

  @objc
  private func registerNewUser() {
    self.output?.showLogin(from: self)
  }
  
  @objc private func openCreditOptions() {
    
    guard let variant = variant else { return }
    output?.didTapOnCredit(with: product!, variant: variant, from: self)
    
    EventService.shared.logCreditBuyButtonTapped()
  }
  
  @objc
  private func didTapOnBack() {
    output?.didTapOnBack(from: self)
  }
  
  @objc
  private func didTapOnShare() {
    guard let product = product else { return }
    output?.didTapOnShare(with: product)
  }
  
  @objc
  private func didTapOnFavourite() {
    guard let product = product else { return }
    updateFavoriteStatus(
      productId: "\(product.id)",
      sku: product.sku,
      isInFavorite: product.isInFavorite,
      price: product.price.current)
  }
  
  @objc
  private func makeCall() {
    if let url = URL(string: "tel://" + ContactsHelper().formattedPhone.withoutWhitespaces()), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
  
  @objc
  private func showSizeHelp() {
    let okAlert = AlertAction(style: .filled,
                              title: Localizator.standard.localizedString("ОК"),
                              isEmphasized: true) { [weak self] in
      self?.dismiss(animated: true)
    }
    
    showAlert(
      title: Localizator.standard.localizedString("Узнать свой размер"),
      subtitle: Localizator.standard.localizedString("Измерьте рулеткой окружность пальца, на котором будете носить кольцо (или замерьте ниткой и приложите к линейке). Полученую цифру разделите на 3 и узнаете Ваш размер для кольца."),
      actions: [okAlert])
  }
  
  @objc
  private func showGift() {
    guard let product = product else { return }
    output?.didTapOnShowGift(with: product, from: self)
  }
  
  @objc
  private func didTapOnCart() {
    output?.didTapOnShowCart(from: self)
  }
  
  @objc
  private func cartDidChange() {
    updateNavigationBarColor()
    localize()
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
    changeAssociatedProductsFavoritesStatus(productId: productId, isInFavorite: isInFavorite)
  }

  @objc
  private func userWasUpdated() {
    loadData()
  }
}

// MARK: - BannersCellControllerDelegate
extension ProductViewController: BannersCellControllerDelegate {
  func bannerCellController(_ controller: BannersCellController, didSelectBannerAt index: Int) {
    guard let lightboxController = lightboxController else { return }
    self.lightboxController?.goTo(bannersController.currentIndex)
    present(lightboxController, animated: true) {
      if let popupView = self.popupView {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.bringSubviewToFront(popupView)
      }
    }
  }
}

// MARK: - UICollectionViewDelegate
extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: SizeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeCollectionViewCell.reuseID,
                                                                          for: indexPath)
    cell.configure(title: dataSource[indexPath.row],
                   isSelected: false)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let product = product, product.availableVariants.indices.contains(indexPath.row) else {
      return
    }

    variant = product.availableVariants[indexPath.row]

    selfView.setupValues(for: product.availableVariants[indexPath.row],
                         socials: socials)
  }
}

// MARK: - ProductViewDelegate
extension ProductViewController: ProductViewDelegate {
  func isFullScreen() -> Bool {
    return self.hidesBottomBarWhenPushed
  }

  func shouldScroll(to offset: CGFloat) {
    update(with: offset)
  }
  
  func didTapOnAssociatedProduct(_ product: Product) {
    output?.didTapOnAssociatedProduct(product)
  }
  
  func didTapOnBanner(_ banner: Banner) {
    output?.didTapOnBanner(banner)
  }

  func didTapOnFavoriteAtAssociatedProduct(_ product: Product) {
    updateFavoriteStatus(
      productId: "\(product.id)",
      sku: product.sku,
      isInFavorite: product.isInFavorite,
      price: product.price.current
    )
  }

  func didTapOnDiscountHintFor(_ product: Product) {
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
      price: product.price,
      actions: alertActions)
  }
}

// MARK: - LightboxControllerPageDelegate
extension ProductViewController: LightboxControllerPageDelegate {
  func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
    bannersController.currentIndex = page
  }

}

// MARK: - LightboxControllerDismissalDelegate
extension ProductViewController: LightboxControllerDismissalDelegate {
  func lightboxControllerWillDismiss(_ controller: LightboxController) {
    configureLightboxController(at: bannersController.currentIndex)
  }
  
}

// MARK: - SupportSocialViewDelegate
extension ProductViewController: SupportSocialViewDelegate {
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

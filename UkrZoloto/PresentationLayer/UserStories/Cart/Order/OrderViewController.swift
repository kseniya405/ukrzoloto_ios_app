//
//  OrderViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/6/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import PKHUD

protocol OrderViewControllerOutput: AnyObject {
  func didTapOnBack(from viewController: OrderViewController)
  func showSelectLocationDialog(for deliveryCode: String,
                                location: Location?,
                                withShops: Bool,
                                from viewController: OrderViewController)
  func showOrderResult(ofType type: ResultType,
                       from viewController: OrderViewController)
  func showWayForPayResult(order: Order, from viewController: OrderViewController)
  func showPublicOffer(from viewController: OrderViewController)
  func showTermsOfUse(from viewController: OrderViewController)
}

class OrderViewController: LocalizableViewController, NavigationButtoned, AlertDisplayable {
  private enum OrderPage: Int {
    case recipient = 0
    case delivery
    case payment
  }
  
  // MARK: - Public variables
  var output: OrderViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = OrderView()
  
  private let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                        navigationOrientation: .horizontal,
                                                        options: nil)
  private let recipientDataVC = RecipientDataViewController(shouldDisplayOnFullScreen: true)
  private let deliveryVC = DeliveryViewController(shouldDisplayOnFullScreen: true)
  private let paymentVC = PaymentViewController(shouldDisplayOnFullScreen: true)
  
  private var recipient: Recipient?
  private var delivery: DeliveryMethod?
  private var payment: PaymentMethod?
  private var promocode: String?
  private var bonusesDiscount: BonusesDiscount?
  private var didAddMarkToPerson = false
  private var comment: String?

  private var currentPageIndex = OrderPage.recipient.rawValue
  
  // MARK: - Life cycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    disableSwipeToBack()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    enableSwipeToBack()
  }

  override func loadView() {
    view = selfView
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
  }

  override func localize() {
    localizeLabels()
  }
  
  private func setupView() {
    setupNavigationBar()
    setupSelfView()
    localizeLabels()

    selfView.setSelectedTabIndex(OrderPage.recipient.rawValue)
    moveTo(recipientDataVC, withForwardingAnimation: true)
    updateCheckMarksStateFor(selectedIndex: OrderPage.recipient.rawValue)

    if let cart = CartService.shared.cart {
      paymentVC.setPrice(Price(cart.totalPrice))
    }
  }
  
  private func setupNavigationBar() {
    addNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem(),
                        side: .left)
  }
  
  private func setupSelfView() {
    setupPageViewController()
    recipientDataVC.output = self
    deliveryVC.output = self
    paymentVC.output = self
    selfView.getSegmentedControl().addTarget(self,
                                             action: #selector(didChangeSegmentIndex),
                                             for: .valueChanged)

    overrideSegmentedControlTapGesture()
  }

  private func overrideSegmentedControlTapGesture() {
    if let tapGestureRecognizer = selfView.getSegmentedControl().gestureRecognizers?.first as? UITapGestureRecognizer {
      selfView.removeGestureRecognizer(tapGestureRecognizer)
    }

    selfView.getSegmentedControl().addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
  }
  
  private func setupPageViewController() {
    addChild(pageViewController)
    pageViewController.didMove(toParent: self)
    selfView.addPageView(pageViewController.view)
  }
  
  private func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Оформление заказа")
    let viewModels = [ImageTitleViewModel(title: Localizator.standard.localizedString("Данные"),
                                         image: .image(#imageLiteral(resourceName: "iconsProfileDeselected"))),
                      ImageTitleViewModel(title: Localizator.standard.localizedString("Доставка"),
                                          image: .image(#imageLiteral(resourceName: "iconsShopsDeselected"))),
                      ImageTitleViewModel(title: Localizator.standard.localizedString("Оплата"),
                                          image: .image(#imageLiteral(resourceName: "iconsPaymentMethodDeselected")))]
    let selectedViewModels = [ImageTitleViewModel(title: Localizator.standard.localizedString("Данные"),
                                                  image: .image(#imageLiteral(resourceName: "selectedPerson"))),
                              ImageTitleViewModel(title: Localizator.standard.localizedString("Доставка"),
                                                  image: .image(#imageLiteral(resourceName: "shopSelected"))),
                              ImageTitleViewModel(title: Localizator.standard.localizedString("Оплата"),
                                                  image: .image(#imageLiteral(resourceName: "selectedMoneyPouch")))]
    selfView.setTabItems(viewModels,
                         selectedViewModels: selectedViewModels)
  }
  
  // MARK: - Interface
	func selectLocation(_ location: Location, parentLocation: Location?, shop: NewShopsItem?) {
    deliveryVC.selectLocation(location, parentLocation: parentLocation, shop: shop)
  }

  func continueOrder() {
    deliveryVC.continueOrder()
  }
  
  // MARK: - Actions
  private func setPage(vc: UIViewController, direction: UIPageViewController.NavigationDirection) {
    pageViewController.setViewControllers([vc],
                                          direction: direction,
                                          animated: true,
                                          completion: nil)
  }
  
  private func openPreviousPage() {
    let currentIndex = selfView.getSegmentedControl().index

    if currentIndex == OrderPage.recipient.rawValue {
      showAbortOrderDialog()
    } else if currentIndex == OrderPage.delivery.rawValue {
      selfView.setSelectedTabIndex(OrderPage.recipient.rawValue)
    } else if currentIndex == OrderPage.payment.rawValue {
      selfView.setSelectedTabIndex(OrderPage.delivery.rawValue)
    }
  }

  private func showAbortOrderDialog() {
    let cancelAlert = AlertAction(
      style: .unfilled,
      title: Localizator.standard.localizedString("Прервать").uppercased(),
      isEmphasized: true) { [weak self] in
        guard let self = self else { return }

        self.output?.didTapOnBack(from: self)
    }

    let continueAlert = AlertAction(
      style: .filled,
      title: Localizator.standard.localizedString("Продолжить оформление").uppercased(),
      isEmphasized: true) { [weak self] in
        self?.dismiss(animated: true)
    }

    showAlert(
      title: Localizator.standard.localizedString("Прервать оформление?"),
      subtitle: Localizator.standard.localizedString("Вы уверены, что хотите прервать оформление заказа? Введенные данные будут утеряны."),
      actions: [cancelAlert, continueAlert])
  }
  
  @objc
  private func didTapOnBack() {
    openPreviousPage()
  }
  
  @objc
  private func didChangeSegmentIndex() {
    switch selfView.getSegmentedControl().index {
    case 0: moveTo(recipientDataVC, withForwardingAnimation: currentPageIndex == OrderPage.recipient.rawValue)
    case 1: moveTo(deliveryVC, withForwardingAnimation: currentPageIndex == OrderPage.recipient.rawValue)
    case 2: moveTo(paymentVC, withForwardingAnimation: currentPageIndex != OrderPage.payment.rawValue)
    default:
      break
    }

    self.updateCheckMarksStateFor(selectedIndex: selfView.getSegmentedControl().index)

    self.currentPageIndex = selfView.getSegmentedControl().index
  }

  private func moveTo(_ viewController: UIViewController, withForwardingAnimation: Bool) {
    pageViewController.setViewControllers(
      [viewController],
      direction: withForwardingAnimation ? .forward : .reverse,
      animated: true)
  }

  private func updateCheckMarksStateFor(selectedIndex: Int) {
    if let recipientSegmentedView = findSegmentedViewNormalView(by: UIConstants.SegmentView.personUnselected) {
      if recipient == nil || selectedIndex == OrderPage.recipient.rawValue {
        removeMarkFromSegmentedView(segmentedView: recipientSegmentedView)
      } else {
        addMarkToSegmentedView(segmentedView: recipientSegmentedView)
      }
    }

    if let deliverySegmentedView = findSegmentedViewNormalView(by: UIConstants.SegmentView.placeUnselected) {
      if delivery == nil || selectedIndex == OrderPage.delivery.rawValue {
        removeMarkFromSegmentedView(segmentedView: deliverySegmentedView)
      } else {
        addMarkToSegmentedView(segmentedView: deliverySegmentedView)
      }
    }
  }

  private func createOrder() {
    guard let recipient = recipient,
      let delivery = delivery,
      let payment = payment,
      let appInstanceId = GoogleAnalyticsService.getAppInstanceId() else { return }
		let sessionId = "\(EventService.shared.sessionId)"
    HUD.showProgress()
    CartService.shared.createOrder(
      recipient: recipient,
      delivery: delivery,
      payment: payment,
      promocode: promocode,
      bonusesDiscount: bonusesDiscount,
      comment: comment,
      appInstanceId: appInstanceId,
			sessionId: sessionId) { [weak self] result in
        HUD.hide()
        guard let self = self else { return }
      DispatchQueue.main.async { [self] in
          switch result {
          case.failure(let error):
            print(error)
            self.output?.showOrderResult(ofType: .error, from: self)
          case .success(let order):

            CartService.shared.clearCreditData()
            CartService.shared.removeAllVariantAndCreditsFromCart()

            switch order.paymentInfo.type {
            case .wayforpay,
                 .liqpay:
              if self.bonusesDiscount?.totalSum == 0 {
                self.output?.showOrderResult(ofType: .success(order), from: self)
              } else {
                self.output?.showWayForPayResult(order: order, from: self)
              }
            case .cash,
                 .cashless:
              self.output?.showOrderResult(ofType: .success(order), from: self)

            case .credit:

              guard let credit = payment as? InstallmentPaymentMethod,
                    let bank = Bank(rawValue: credit.providerCode) else { return }

              switch bank {
              case .privat, .privatInstallment:
                self.output?.showWayForPayResult(order: order, from: self)
              default:
                self.output?.showOrderResult(ofType: .success(order), from: self)
              }
            }
          }
        }
    }
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum MarkView {
    static let image = #imageLiteral(resourceName: "goldenDoneMark")
    static let width: CGFloat = 11
    static let height: CGFloat = 8
  }
  
  enum SegmentView {
    static let placeUnselected = #imageLiteral(resourceName: "iconsShopsDeselected")
    static let personUnselected = #imageLiteral(resourceName: "iconsProfileDeselected")
  }
}

// MARK: - RecipientDataViewControllerOutput
extension OrderViewController: RecipientDataViewControllerOutput {
  func didSelectRecipient(_ recipient: Recipient?) {
    self.recipient = recipient
  }

  func proceedToDelivery() {
    selfView.setSelectedTabIndex(OrderPage.delivery.rawValue)
  }
}

// MARK: - DeliveryViewControllerOutput
extension OrderViewController: DeliveryViewControllerOutput {
  func showSelectLocationDialog(for deliveryCode: String,
                                location: Location?,
                                withShops: Bool,
                                from viewController: DeliveryViewController) {
    output?.showSelectLocationDialog(for: deliveryCode, location: location, withShops: withShops, from: self)
  }
  
  func didSelectDelivery(_ delivery: DeliveryMethod, shouldProceedToOrder: Bool) {
    self.delivery = delivery

    paymentVC.reset()
    paymentVC.setDeliveryMethod(delivery)

    if shouldProceedToOrder {
      selfView.setSelectedTabIndex(OrderPage.payment.rawValue)
    }
  }
}

// MARK: - PaymentViewControllerOutput
extension OrderViewController: PaymentViewControllerOutput {
  func showPublicOffer(from viewController: PaymentViewController) {
    output?.showPublicOffer(from: self)
  }
  
  func showTermsOfUse(from viewController: PaymentViewController) {
    output?.showTermsOfUse(from: self)
  }
  
  func didSelectPayment(_ payment: PaymentMethod,
                        promocode: String?,
                        bonusesDiscount: BonusesDiscount?,
                        comment: String?,
                        in viewController: PaymentViewController) {
    self.payment = payment
    self.promocode = promocode
    self.bonusesDiscount = bonusesDiscount
    self.comment = comment

    createOrder()
  }

  func showHintAboutCardNumber(from viewController: PaymentViewController) {
    let okAlert = AlertAction(style: .filled,
                              title: Localizator.standard.localizedString("ОК"),
                              isEmphasized: true) { [weak self] in
      self?.dismiss(animated: true)
    }

    showAlert(
      title: Localizator.standard.localizedString("Ошибка"),
      subtitle: Localizator.standard.localizedString("Введите последние 4 цифры..."),
      actions: [okAlert])
  }
}

extension OrderViewController {
  private func addMarkToSegmentedView(segmentedView: UIView) {
    guard let subview = segmentedView.subviews.first(where: { $0 is UILabel }) else { return }
    let imageView = UIImageView()
    imageView.image = UIConstants.MarkView.image
    imageView.contentMode = .scaleToFill
    segmentedView.addSubview(imageView)
    imageView.frame = CGRect(x: subview.frame.maxX, y: subview.frame.minY - UIConstants.MarkView.height,
                             width: UIConstants.MarkView.width, height: UIConstants.MarkView.height)
    selfView.layoutSubviews()
  }

  private func removeMarkFromSegmentedView(segmentedView: UIView) {
    for subview in segmentedView.subviews {
      if let imageView = subview as? UIImageView,
         imageView.image == UIConstants.MarkView.image {
        subview.removeFromSuperview()
        return
      }
    }
  }

  private func findSegmentedViewNormalView(by image: UIImage) -> UIView? {
    let segments = selfView.getSegmentedControl().segments
    let foundSegmentedView = segments.first(where: { segment in
      for subview in segment.normalView.subviews {
        if let imageView = subview as? UIImageView,
        imageView.image == image {
          return true
        }
      }
      return false
    })

    return foundSegmentedView?.normalView
  }
}

extension OrderViewController {
  private func closestIndex(toPoint point: CGPoint) -> Int {
    let normalSegmentViews = selfView.getSegmentedControl().segments.map { $0.normalView }

    let distances = normalSegmentViews.map { abs(point.x - $0.center.x) }

    return Int(distances.firstIndex(of: distances.min()!)!)
  }

  @objc private func tapped(_ gestureRecognizer: UITapGestureRecognizer!) {
    let location = gestureRecognizer.location(in: selfView.getSegmentedControl())
    let closestIndex = closestIndex(toPoint: location)

    guard closestIndex < 3, let tappedOrderPage = OrderPage(rawValue: closestIndex) else {
      return
    }

    switch tappedOrderPage {
    case .recipient: selfView.setSelectedTabIndex(OrderPage.recipient.rawValue)
    case .delivery:
      if recipient != nil {
        selfView.setSelectedTabIndex(OrderPage.delivery.rawValue)
      }
    case .payment:
      if deliveryVC.isDeliverySelected() && recipient != nil {
        if let delivery = delivery {
          paymentVC.reset()
          paymentVC.setDeliveryMethod(delivery)
        }

        selfView.setSelectedTabIndex(OrderPage.payment.rawValue)
      }
    }
  }
}

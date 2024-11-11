//
//  PaymentViewController.swift
//  UkrZoloto
//
//  Created by Andrew on 8/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol PaymentViewControllerOutput: AnyObject {
  func didSelectPayment(_ payment: PaymentMethod,
                        promocode: String?,
                        bonusesDiscount: BonusesDiscount?,
                        comment: String?,
                        in viewController: PaymentViewController)
  func showPublicOffer(from viewController: PaymentViewController)
  func showTermsOfUse(from viewController: PaymentViewController)
  func showHintAboutCardNumber(from viewController: PaymentViewController)
}

private enum PaymentItem {
  case title(String)
  case full(FullPaymentController)
  case installment(InstallmentPaymentController)
  case promocode(PaymentPromocodeController)
  case bonuses(PaymentBonusesController)
  case promoBonuses(PromoBonusesController)
  case priceBlock(PriceBlockController)
  case comment(PlaceholderTextViewController)
  case space(height: CGFloat)
  case credit(creditDTO: CreditDTO)
}

class PaymentViewController: LocalizableViewController, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: PaymentViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = PaymentView()
  
  private var payments = [PaymentMethod]()
  private var loadingState = LoadingState.readyForLoading
  private var associatedPayments: [ASTHashedReference: PaymentMethod] = [:]
  private var promocodeController = PaymentPromocodeController()
  private var bonusesController = PaymentBonusesController()
  private var promoBonusesController = PromoBonusesController()
  private var commentController = PlaceholderTextViewController(maxCharacters: PaymentConstants.maxCommentLength)
  private var priceBlockController = PriceBlockController()
  
  private var paymentControllers = [PaymentController]()
  private var shouldSkipPaymentEventSend: Bool = true
  private var selectedPayment: PaymentMethod? {
    didSet {
      if let paymentMethod = selectedPayment, !shouldSkipPaymentEventSend {
        
        let months: Int? = (paymentMethod as? InstallmentPaymentMethod)?.selectedMonth
        
        EventService.shared.logAddPaymentInfo(paymentCode: paymentMethod.code.rawValue, months: months)
      }
      shouldSkipPaymentEventSend = false
    }
  }
  private var selectedPayments = [PaymentMethod]()
  
  private var priceDetails = CartPriceDetails(totalPrice: CartService.shared.cart?.totalPrice ?? 0) {
    didSet {
      updateViewState()
//      updateCreditPaymentControllers()
    }
  }
  
  private var totalPrice: Decimal {
    return priceDetails.totalPrice!
  }
	
	private var amountExchange: Decimal {
		return priceDetails.amountExchange
	}
  
  private var currentBonuses: Int {
    return NSDecimalNumber(decimal: priceDetails.personalBonuses).intValue
  }
  private var deliveryMethod: DeliveryMethod?
  
  private var isPromocodeWriteOffVisible = false {
    didSet {
      reloadPromocode()
    }
  }
  
  private var promocode: String? {
    get {
      return promocodeController.promocodeViewModel?.promocodeInfo?.promocode
    }
    set {
      promocodeController.promocodeViewModel?.promocodeInfo = getPromocodeInfo(for: newValue)
    }
  }
  private var promoBonus: Int {
    NSDecimalNumber(decimal: priceDetails.actionBonuses).intValue
  }
  private var isPromoBonusesWrittenOff: Bool {
    priceDetails.actionBonuses > 0
  }
  
  private var isBonusesWriteOffVisible: Bool = false
  private var isBonusesWrittenOff: Bool {
    priceDetails.personalBonuses > 0
  }
  
  private var isFreezedBonuses: Bool {
    return priceDetails.promocodeWasApplied && !priceDetails.canApplyPersonalBonuses
  }
  
  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    switch loadingState {
    case .readyForLoading,
        .failed:
      loadData()
    case .loading,
        .finished:
      break
    }
  }
  
  // MARK: - Setup
  override func initConfigure() {
    setupView()
  }
  
  private func setupView() {
    setupSelfView()
    addObservers()
    updateContinueButtonState()
  }
  
  private func setupSelfView() {
    setupControllers()
  }
  
  private func setupControllers() {
    promocodeController.delegate = self
    promocodeController.paymentPromocodeView = selfView.paymentPromocodeView
    
    bonusesController.delegate = self
    bonusesController.paymentBonusesView = selfView.paymentBonusesView
    
    promoBonusesController.delegate = self
    promoBonusesController.promoBonusesView = selfView.promoBonusesView
    
    commentController.placeholderTextView = selfView.commentView
    
    priceBlockController.delegate = self
    priceBlockController.priceBlockView = selfView.priceBlockView
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  private func getPaymentPromocodeVM() -> PaymentPromocodeViewModel {
    
    let promocodeAllowed = priceDetails.promocodeWasApplied
    
    return PaymentPromocodeViewModel(
      title: Localizator.standard.localizedString("ввести промокод").uppercased(),
      placeholder: Localizator.standard.localizedString("Введите промокод"),
      writeOffButtonTitle: Localizator.standard.localizedString("применить").uppercased(),
      cancelButtonTitle: Localizator.standard.localizedString("отменить ввод"),
      discountTitle: Localizator.standard.localizedString("Скидка по промокоду:"),
      promocodeInfo: getPromocodeInfo(for: promocode),
      cancelDescription: Localizator.standard.localizedString("Отменив Скидку по промокоду Вы сможете использовать его в следующий раз."),
      isWriteOffVisible: isPromocodeWriteOffVisible && priceDetails.promocodeWasApplied && promocodeAllowed,
      appliedString: (!isPromocodeWriteOffVisible && promocode != nil) ? Localizator.standard.localizedString("Применен") : nil,
      isActive: promocodeAllowed)
  }
  
  private func getPaymentBonusesVM() -> PaymentBonusesViewModel {
    var bonusesBalanceString: String
    var isWriteOffActive = false
    
    let userBonuses = ProfileService.shared.user?.bonuses ?? 0
    if userBonuses == 0 {
      bonusesBalanceString = Localizator.standard.localizedString("У вас нет бонусов")
    } else if priceDetails.priceWithCatalogDiscount <= PaymentConstants.minPriceForDiscount {
      bonusesBalanceString = Localizator.standard.localizedString("По условиям дисконтной программы\nоплата бонусами распространяется\nтолько на заказы от 500 грн.")
    } else {
      bonusesBalanceString = Localizator.standard.localizedString("Баланс") + " - " + StringComposer.shared.getPriceCurrencyString(Price(Currency(userBonuses)))
      isWriteOffActive = priceDetails.canApplyPersonalBonuses
    }
    
    let bonusInfo = getBonuseInfo()
		let priceWithoutBonuses = getPriceWithDiscounts() + currentBonuses
    return PaymentBonusesViewModel(
      title: bonusesBalanceString,
      buttonTitle: Localizator.standard.localizedString("оплатить персональными бонусами").uppercased(),
      isWriteOffActive: isWriteOffActive,
      bonusInfo: bonusInfo,
      writeOffVM: getWriteOffVM(bonusInfo: bonusInfo),
      isWriteOffVisible: isBonusesWriteOffVisible && !isFreezedBonuses,
      isFreezedBonuses: isFreezedBonuses,
      maxBonusesCount: priceWithoutBonuses,
      isRestricted: !priceDetails.canApplyPersonalBonuses)
  }
  
  private func getWriteOffVM(bonusInfo: BonusInfo? = nil) -> WriteOffViewModel {
    let writeOffViewModel = WriteOffViewModel(
      placeholder: Localizator.standard.localizedString("Сколько бонусов списать"),
      writeOffButtonTitle: Localizator.standard.localizedString("списать бонусы").uppercased(),
      cancelButtonTitle: Localizator.standard.localizedString("отменить ввод"),
      bonusInfo: bonusInfo)
    return writeOffViewModel
  }
  
  private func getPromoBonusesVM() -> PromoBonusesViewModel {
    let title = StringComposer.shared.getPromoBonusString(
      text: Localizator.standard.localizedString("Вы можете использовать") + " \(priceDetails.availableActionBonus) " + Localizator.standard.localizedString("грн") + " " +
      Localizator.standard.localizedString("акционных бонусов в этом заказе"),
      emphasise: "\(priceDetails.availableActionBonus) " + Localizator.standard.localizedString("грн"))
    
    let resultVM = ResultPromoViewModel(
      title: Localizator.standard.localizedString("Акционные бонусы применены"),
      descriptionTitle: Localizator.standard.localizedString("Отменив Акционные бонусы Вы сможете использовать их в следующий раз."),
      cancelButton: Localizator.standard.localizedString("отменить ввод"))
    return PromoBonusesViewModel(
      title: title,
      writeOffButtonTitle: Localizator.standard.localizedString("применить").uppercased(),
      resultVM: priceDetails.actionBonuses > 0 ? resultVM : nil,
      isActive: priceDetails.availableActionBonus > 0)
  }
  
  override func localize() {
    loadData()
  }
  
  // MARK: - Interface
  func reset() {
    resetBonusesInput()
    resetPromocodeInput()
    
    priceDetails = CartPriceDetails(totalPrice: totalPrice)
  }
  
  func resetPromocodeInput() {
    isPromocodeWriteOffVisible = false
    promocode = nil
    promocodeController.clearTextField()
  }
  
  func resetBonusesInput() {
    
    isBonusesWriteOffVisible = false
    bonusesController.resetInputPriceIfNeeded()
  }
  
  func setPrice(_ price: Price) {
    let new = CartPriceDetails(totalPrice: price.current)
    if priceDetails != new {
      priceDetails = new
    }
  }
  
  func setDeliveryMethod(_ deliveryMethod: DeliveryMethod) {
    
    self.deliveryMethod = deliveryMethod
    loadingState = .readyForLoading
  }
  
  // MARK: - Actions
  private func loadData(silently: Bool = false) {
    guard let deliveryMethod = deliveryMethod else { return }
    loadingState = .loading
    if !silently {
      HUD.showProgress()
    }
		CartService.shared.getCart { _ in
			CartService.shared.calculateCart { _ in
				CartService.shared.getPaymentMethods(for: deliveryMethod.code) { [weak self] response in
					DispatchQueue.main.async {
						HUD.hide()
						guard let self = self else { return }
						self.updatePriceBlock()
						switch response {
						case .failure(let error):
							self.loadingState = .failed
							self.handleError(error)
						case .success(let payments):
							
							self.setupDataSource(payments)
							self.requestPriceDetails(promocode: nil, bonuses: 0, marketingBonuses: 0)
						}
					}
				}
				
			}
		}
  }
  
  private func requestPriceDetails(promocode: String?,
                                   bonuses: Int,
                                   marketingBonuses: Int) {
    
    guard let paymentMethod = selectedPayment else { return }
    
    HUD.showProgress()
    loadingState = .loading
    
    CartService.shared.getPriceFor(promocode: promocode,
                                   bonuses: bonuses,
                                   marketingBonuses: marketingBonuses,
                                   paymentCode: paymentMethod.rawRepresentation()) { [weak self] result in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.loadingState = .failed
          self.handleError(error)
        case .success(let details):
          if let error = details.error {
            self.promocodeController.setTextFieldError(error.title)
          } else {
            self.promocode = promocode
          }
					if details.changedResponse ?? false {
						self.handleError(ServerError.unknown)
					}
          self.priceDetails = details

          self.loadingState = .finished

          self.scrollToSelectedPaymentController()
        }
      }
    }
  }
  
  private func scrollToSelectedPaymentController() {
    guard let payment = selectedPayment else { return }
    if let controller = paymentControllers.filter({ $0.paymentMethodTitle == payment.title }).first {
      selfView.scrollToView(controller.view!)
    }
  }
  
  private func updateCreditPaymentControllers() {
    
    paymentControllers.filter({$0 is InstallmentPaymentController}).forEach { controller in
      
      guard let payment = payments.filter({ $0.title == controller.paymentMethodTitle}).first as? InstallmentPaymentMethod,
      let controller = controller as? InstallmentPaymentController else { return }
      
      let selected: Bool = {
        
        if let selectedPayment = selectedPayment {
          return selectedPayment.title == payment.title
        }
        return false
      }()
      
      let totalPrice = priceDetails.totalPrice
      
      let viewModel = InstallmentPaymentViewModel(providerName: payment.title,
                                                  allowedMonths: payment.allowedMonths,
                                                  description: payment.description,
                                                  selectedMonth: payment.selectedMonth,
                                                  isSelected: selected,
                                                  code: payment.providerCode,
                                                  icon: payment.icon,
                                                  totalPrice: totalPrice!,
                                                  comission: payment.comission)
      
      controller.paymentViewModel = viewModel
      controller.reload()
    }
  }
  
  private func getSelectedPaymentController() -> PaymentController? {
    
    guard let payment = selectedPayment else { return nil }

    return paymentControllers.filter({ $0.paymentMethodTitle == payment.title }).first
  }
  
  private func setupDataSource(_ payments: [PaymentMethod]) {
    associatedPayments = [:]
    selectedPayments = payments
    
    self.payments = payments
    
    commentController.placeholder = Localizator.standard.localizedString("Текст комментария")
    selfView.paymentsLabel.text = Localizator.standard.localizedString("Способ оплаты")
    
    let paymentViews = selfView.createPaymentViews(forPayments: payments)
    paymentControllers = []
    
    let preselectedCreditProvider = CartService.shared.selectedCreditOption
    
    for (index, payment) in payments.enumerated() {
      if let payment = payment as? FullPayment {
        let controller = FullPaymentController()
        let selected = index == 0 && preselectedCreditProvider == nil
        let viewModel = FullPaymentViewModel(payment: payment, isSelected: selected)
        controller.paymentViewModel = viewModel
        controller.delegate = self
        controller.paymentView = paymentViews[index]
        associatedPayments[ASTHashedReference(controller)] = payment
        paymentControllers.append(controller)
        if selected {
          selectedPayment = payment
        }
      } else if let payment = payment as? InstallmentPaymentMethod {
        
        var isSelected = false
        if let preselect = preselectedCreditProvider,
           preselect.bank.rawValue == payment.providerCode {
          
          payment.selectedMonth = preselect.months
          isSelected = true
          
          self.selectedPayment = payment
        }
        
        let controller = InstallmentPaymentController()

        let viewModel = InstallmentPaymentViewModel(providerName: payment.title,
                                                    allowedMonths: payment.allowedMonths,
                                                    description: payment.description,
                                                    selectedMonth: payment.selectedMonth,
                                                    isSelected: isSelected,
                                                    code: payment.providerCode,
                                                    icon: payment.icon,
                                                    totalPrice: totalPrice,
                                                    comission: payment.comission)
        
        controller.paymentViewModel = viewModel
        controller.delegate = self
        let view = paymentViews[index] as? InstallmentPaymentView
        controller.paymentView = view
        
        if let bank = Bank(rawValue: payment.providerCode), bank == .alpha {
          (view as? AlphabankPaymentView)?.delegate = self
        }
        
        associatedPayments[ASTHashedReference(controller)] = payment
        paymentControllers.append(controller)
      }
    }
    
    updateViewState()
  }
  
  private func deselectAll() {
    for controller in paymentControllers {
      
      controller.set(selected: false)
      controller.reload()
    }
  }
  
  private func setSelected(paymentController: PaymentController) {
    
    paymentController.set(selected: true)
  }
  
  private func updateViewState() {
    reloadPromocode()
    reloadBonuses()
    reloadPromoBonuses()
    updatePriceBlock()
    
    updateContinueButtonState()
  }
  
  private func reloadPromocode() {
    promocodeController.promocodeViewModel = getPaymentPromocodeVM()
  }
  
  private func updatePriceBlock() {
    priceBlockController.priceDetailsViewModel = getPriceBlockVM()
    
    guard let selectedPayment = selectedPayment else {
      return
    }

    paymentControllers
      .filter({ $0 is InstallmentPaymentController && $0.paymentMethodTitle == selectedPayment.title})
      .map({$0 as! InstallmentPaymentController})
      .forEach { controller in
        
        controller.setTotalPrice(price: totalPrice)
        controller.reload()
      }
  }
  
  private func updateContinueButtonState() {
    priceBlockController.updateContinueButtonState(isEnabled: selectedPayment != nil)
  }
  
  private func getPriceBlockVM() -> PriceDetailsViewModel? {

    typealias Item = PriceDetailsViewModel.Item
    
    let headerValue: Decimal = {
      if priceDetails.orderAmount > 0 {
        return priceDetails.orderAmount
      }
      return totalPrice
    }()
		guard let cart = CartService.shared.cart else { return nil }
    let header = Item.header(goodsNumber: cart.cartItems.count, price: headerValue)
    
    let discounts: [Item] = {
      
      var result = [Item]()
      
      if priceDetails.promoDiscount > 0 {
        result.append(.discount(.promocode, priceDetails.promoDiscount))
      }
      
      if priceDetails.personalBonuses > 0 {
        result.append(.discount(.bonusUsage, priceDetails.personalBonuses))
      }
      
      if priceDetails.actionBonuses > 0 {
        result.append(.discount(.promoBonus, priceDetails.actionBonuses))
      }
      
      // certificate
      
      if priceDetails.personalDiscount > 0 {
        result.append(.discount(.discount, priceDetails.personalDiscount))
      }
      
      if priceDetails.birthdayDiscountAmount > 0 {
        result.append(.discount(.birthday, priceDetails.birthdayDiscountAmount))
      }
      
      if priceDetails.marketingDiscountAmount > 0 {
        result.append(.discount(.additionalPromo, priceDetails.marketingDiscountAmount))
      }
      
      return result
    }()
    
    let cashback: Item? = {
      
      if priceDetails.cashback > 0 {
        return Item.cashback(priceDetails.cashback)
      }
      
      return nil
    }()
        
    let total = Item.total(totalPrice)
		
		var selectedExchanges = 0
		
		for item in CartService.shared.cart?.cartItems ?? [] {
			for service in item.services ?? [] {
				for option in service.options where option.selected {
          selectedExchanges += 1
				}
			}
		}
		
		let exchange = Item.exchange(amount: selectedExchanges, price: amountExchange)
    
    let delivery = Item.delivery(getDeliveryTitle())

		let priceVM = PriceDetailsViewModel(header: header,
																				exchange: amountExchange > 0 ? exchange : nil,
                                        discounts: discounts,
                                        delivery: delivery,
                                        cashback: cashback,
                                        total: total)
    
    return priceVM
  }
  
  private func getPromocodeContent() -> (title: String?, value: String?, promocodeDiscount: Decimal?) {
    guard priceDetails.promocodeWasApplied else {
      return (nil, nil, nil)
    }
    let promocodeTitle = Localizator.standard.localizedString("Промокод:")
    let promocodeDiscount = priceDetails.promoDiscount
    let promocodeValue = "-\(promocodeDiscount)" + " " + Localizator.standard.localizedString("грн")
    
    return (title: promocodeTitle, value: promocodeValue, promocodeDiscount: promocodeDiscount)
  }
  
  private func getPromoBonusContent() -> (title: String?, value: String?) {
    guard promoBonus > 0 else {
      return (nil, nil)
    }
    let title = Localizator.standard.localizedString("Акционные бонусы:")
    let value = "-\(promoBonus)" + " " + Localizator.standard.localizedString("грн")
    return (title: title, value: value)
  }
  
  private func getBonusContent() -> (title: String?, value: String?) {
    guard currentBonuses > 0 else {
      return (nil, nil)
    }
    let title = Localizator.standard.localizedString("Персональные\nбонусы:")
    let value = "-\(currentBonuses)" + " " + Localizator.standard.localizedString("грн")
    return (title: title, value: value)
  }
  
  private func getDeliveryTitle() -> String {
    let deliveryValue = Price(priceDetails.orderAmount - priceDetails.personalBonuses - priceDetails.actionBonuses) // Don't count personal or promotional bonuses
    
    let deliveryPriceValue: String

    if let deliveryTitle = deliveryMethod?.title {
      if let minPrice = deliveryMethod?.minPrice {
        let currentDeliveryValue = Int(truncating: NSDecimalNumber(decimal: deliveryValue.current))
        let currentMinPrice = Int(minPrice / 100)

        if currentDeliveryValue > currentMinPrice {
          deliveryPriceValue = "\(Localizator.standard.localizedString("Бесплатно"))"
        } else {
          if deliveryMethod?.code == NetworkResponseKey.Delivery.DeliveryCode.selfDelivery {
            deliveryPriceValue = "\(Localizator.standard.localizedString("Бесплатно"))"
          } else if deliveryMethod?.code == NetworkResponseKey.Delivery.DeliveryCode.novaPoshtaLocation {
            deliveryPriceValue = Localizator.standard.localizedString("Согласно тарифам \"Новой Почты\"")
          } else if deliveryMethod?.code == NetworkResponseKey.Delivery.DeliveryCode.novaPoshtaAddress {
            deliveryPriceValue = Localizator.standard.localizedString("Согласно тарифам \"Новой Почты\"")
          } else if deliveryMethod?.code == NetworkResponseKey.Delivery.DeliveryCode.novaPoshtaParcelLockers {
            deliveryPriceValue = Localizator.standard.localizedString("Согласно тарифам \"Новой Почты\"")
          } else {
            deliveryPriceValue = deliveryTitle
          }
        }
      } else {
        deliveryPriceValue = deliveryTitle
      }
    } else {
      deliveryPriceValue = ""
    }
    
    return deliveryPriceValue
  }
  
  private func reloadBonuses() {
    bonusesController.bonusesViewModel = getPaymentBonusesVM()
  }
  
  private func getBonusesDiscount() -> BonusesDiscount? {
    return BonusesDiscount(
      sumToPayFromBonus: Decimal(currentBonuses),
      marketingBonus: Decimal(promoBonus),
      totalSum: priceDetails.orderAmount)
  }
  
  private func reloadPromoBonuses() {
    selfView.promoBonusesView.isHidden = priceDetails.availableActionBonus == 0
    promoBonusesController.promoBonusesViewModel = getPromoBonusesVM()
  }
  
  // MARK: - Keyboard
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardHeight = kbSizeValue.cgRectValue.height
    selfView.setBottomOffset(keyboardHeight)
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    selfView.setBottomOffset(0)
  }
}

// MARK: - FullPaymentControllerDelegate
extension PaymentViewController: FullPaymentControllerDelegate {
  func didSelect(fullPaymentController: FullPaymentController) {
    guard let viewModel = fullPaymentController.paymentViewModel,
          !viewModel.isSelected else { return }
    deselectAll()
    setSelected(paymentController: fullPaymentController)
    fullPaymentController.reload()
    selectedPayment = associatedPayments[ASTHashedReference(fullPaymentController)]
    requestPriceDetails(promocode: promocode, bonuses: currentBonuses, marketingBonuses: promoBonus)
  }
}

// MARK: - InstallmentOaymentControllerDelegate
extension PaymentViewController: InstallmentPaymentControllerDelegate {
  
  func tappedOnMonths(installmentPaymentController: InstallmentPaymentController) {
    
    presentMonthPicker(paymentController: installmentPaymentController)
  }
  
  func didSelect(installmentPaymentController: InstallmentPaymentController) {
    
    guard let viewModel = installmentPaymentController.paymentViewModel,
          !viewModel.isSelected else { return }
    
    deselectAll()
    setSelected(paymentController: installmentPaymentController)
    installmentPaymentController.reload()
    selectedPayment = associatedPayments[ASTHashedReference(installmentPaymentController)]
    requestPriceDetails(promocode: promocode, bonuses: currentBonuses, marketingBonuses: promoBonus)
  }
  
  private func presentMonthPicker(paymentController: InstallmentPaymentController) {
    
    guard let payment = selectedPayment as? InstallmentPaymentMethod,
          let parentView = parent?.view  else {
            
            // month picker displaying is allowed only for credit payment methods
            return
          }
    
    let pickerView = CreditMonthPickerView(months: payment.allowedMonths, selectedMonth: payment.selectedMonth)
    
    pickerView.onDoneTap = { selectedMonth in
      
      payment.selectedMonth = selectedMonth
      paymentController.setPartsCount(selectedMonth)
      paymentController.reload()
    }
    
    pickerView.displayIn(container: parentView)
  }
}

// MARK: - PriceBlockViewDelegate
extension PaymentViewController: PriceBlockViewDelegate {
  func didTapOnPublicOffer(from view: PriceBlockView) {
    output?.showPublicOffer(from: self)
  }
  
  func didTapOnTermsOfUse(from view: PriceBlockView) {
    output?.showTermsOfUse(from: self)
  }
}

// MARK: - PriceBlockControllerDelegate
extension PaymentViewController: PriceBlockControllerDelegate {
  func didTapOnContinueOrder(from controller: PriceBlockController) {
    guard let selectedPayment = selectedPayment else { return }
    
    if let payment = selectedPayment as? InstallmentPaymentMethod,
       let bank = Bank(rawValue: payment.providerCode), bank == .alpha {
      
      if payment.cardNumbers == nil || payment.cardNumbers!.count < 4 {
        output?.showHintAboutCardNumber(from: self)

        return
      }
    }
    
    output?.didSelectPayment(selectedPayment,
                             promocode: promocode,
                             bonusesDiscount: getBonusesDiscount(),
                             comment: !commentController.isCollapsed ? commentController.text : nil,
                             in: self)
  }
  
}

// MARK: - UITextFieldDelegate
extension PaymentViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    
    let validatorType: Validator.ValidatorType =
    (textField as? ImageTextField)?.type == .bonuses ?
    Validator.ValidatorType.bonuses : Validator.ValidatorType.promocode
    
    if let newString = newString {
      let allowedSymbolsOnly = string.rangeOfCharacter(from: Validator.allowedCharacterSet(for: validatorType).inverted) == nil
      return newString.count <= Validator.maxSymbolsCount(for: validatorType) && allowedSymbolsOnly
    }
    return true
  }
}

// MARK: - PaymentPromocodeControllerDelegate
extension PaymentViewController: PaymentPromocodeControllerDelegate {
  func didTapOnPromocodeButton(isWriteOffVisible: Bool, from controller: PaymentPromocodeController) {
    self.isPromocodeWriteOffVisible = isWriteOffVisible
    view.endEditing(true)
  }
  
  func didTapOnCancelButton(from controller: PaymentPromocodeController) {
    if let promocode = controller.paymentPromocodeView?.promocodeView.textField.text,
       !promocode.isEmpty {
      isPromocodeWriteOffVisible = true
      promocodeController.clearTextField()
      requestPriceDetails(promocode: nil, bonuses: currentBonuses, marketingBonuses: promoBonus)
    } else {
      isPromocodeWriteOffVisible = false
    }
  }
  
  func didTapOnWriteOff(from controller: PaymentPromocodeController) {
    guard let promocode = controller.paymentPromocodeView?.promocodeView.textField.text,
          !promocode.isEmpty else { return }
    requestPriceDetails(promocode: promocode, bonuses: currentBonuses, marketingBonuses: promoBonus)
  }
  
  private func getPromocodeInfo(for promocode: String?) -> PromocodeInfo? {
    guard let promocode = promocode, priceDetails.promocodeWasApplied else {
      return nil
    }

    let promocodeDiscountString = "\(priceDetails.promoDiscount)" + " " + Localizator.standard.localizedString("грн")
    
    let promocodeInfo = PromocodeInfo(
      promocode: promocode,
      promocodeDiscount: promocodeDiscountString,
      statusBonusString: priceDetails.canApplyPersonalBonuses ? nil : Localizator.standard.localizedString("Применение промокода невозможно с бонусами. Списание бонусов было отменено"))
    
    return promocodeInfo
  }
  
}

// MARK: - PaymentBonusesControllerDelegate
extension PaymentViewController: PaymentBonusesControllerDelegate {
  func didTapOnBonusesButton(isWriteOffVisible: Bool, from controller: PaymentBonusesController) {
    if !isFreezedBonuses {
      self.isBonusesWriteOffVisible = isWriteOffVisible
      if isWriteOffVisible {
        bonusesController.resetInputPriceIfNeeded()
      }
      reloadBonuses()
      view.endEditing(true)
    }
  }
  
  func didTapOnWriteOff(from controller: PaymentBonusesController) {
    let bonuses = Int(controller.paymentBonusesView?.writeOffView.textField.text ?? "") ?? 0
    guard let user = ProfileService.shared.user,
          user.bonuses >= bonuses  else { return }
    requestPriceDetails(promocode: promocode, bonuses: bonuses, marketingBonuses: promoBonus)
  }
	
	private func getPriceWithDiscounts() -> Int {
		NSDecimalNumber(decimal: (priceDetails.orderAmount
															+ priceDetails.amountExchange
															- priceDetails.birthdayDiscountAmount
															- priceDetails.marketingDiscountAmount
															- priceDetails.personalDiscount)).intValue
	}
  
  private func getBonuseInfo() -> BonusInfo? {
    guard var bonuses = Int(bonusesController.paymentBonusesView?.writeOffView.textField.text ?? ""),
          let user = ProfileService.shared.user,
          !isFreezedBonuses else {
            return nil
          }
		let updatedAmount = getPriceWithDiscounts()
			if bonuses > updatedAmount {
					bonuses = updatedAmount
			}
		let bonusesBalanceString = Localizator.standard.localizedString("Баланс") + " - " + StringComposer.shared.getPriceCurrencyString(Price(Currency(user.bonuses)))
    
    let bonusInfo = BonusInfo(
      isWrittenOff: isBonusesWrittenOff,
      bonus: "\(bonuses)",
      cancelTitle: Localizator.standard.localizedString("отменить списание бонусов"),
      acceptedBonuses: "(-\(StringComposer.shared.getPriceCurrencyString(Price(Currency(bonuses)))))",
      resultTitleString: bonusesBalanceString)
    
    return bonusInfo
  }
  
  func didTapOnCancelButton(from controller: PaymentBonusesController) {
    if let bonuses = Int(controller.paymentBonusesView?.writeOffView.textField.text ?? ""),
       bonuses > 0 {
      requestPriceDetails(promocode: promocode, bonuses: 0, marketingBonuses: promoBonus)
    } else {
      isBonusesWriteOffVisible = false
      reloadBonuses()
    }
  }
}

// MARK: - PromoBonusesControllerDelegate
extension PaymentViewController: PromoBonusesControllerDelegate {
  func didTapOnWriteOff(from controller: PromoBonusesController) {
    requestPriceDetails(promocode: promocode, bonuses: currentBonuses, marketingBonuses: priceDetails.availableActionBonus)
  }
  
  func didTapOnCancelButton(from controller: PromoBonusesController) {
    requestPriceDetails(promocode: promocode, bonuses: currentBonuses, marketingBonuses: 0)
  }
  
}

extension PaymentViewController: AlphabankPaymentViewDelegate {
  
  func paymentViewDidEnteredCardNumbers(_ lastNumbersComponent: String) {
    guard let payment = selectedPayment as? InstallmentPaymentMethod,
          Bank(rawValue: payment.providerCode) != nil else {
      return
    }
    
    payment.cardNumbers = lastNumbersComponent
  }
}

private enum PaymentConstants {
  static let minPriceForDiscount: Decimal = 500
  static let maxCommentLength = 1000
}

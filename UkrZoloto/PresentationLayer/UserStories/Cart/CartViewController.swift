//
//  CartViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol CartViewControllerOutput: AnyObject {
  func showProducts(from viewController: CartViewController)
  func createOrder(from viewController: CartViewController)
  func showProduct(productId: String, from viewController: CartViewController)
	func didTapOnExchangeDetailsLink(from viewController: CartViewController)
}

private enum CartDataSourceItem {
  case creditWarning
  case title(String)
  case cartItem(CartItem)
  case totalPrice(PriceDetailsViewModel)
  case button
  case spacing(CGFloat)
}

class CartViewController: LocalizableViewController, ErrorAlertDisplayable {

  // MARK: - Public variables
  var output: CartViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = CartView()
  private var dataSource = [CartDataSourceItem]()
	private var pickerDataSource: (months: [String], selectedMonth: String, indexPath: Int)!
	private var debounceTimer: Timer?
  
  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }

  private var cellsCollapsedStates: [String: Bool] = [:]

  func addExpandedValue(_ value: Bool, forKey key: String) {
    cellsCollapsedStates[key] = value
  }

  func expandedValueFor(_ key: String) -> Bool {
    return cellsCollapsedStates[key] ?? true
  }

  func hasExpandedValue(forKey key: String) -> Bool {
    return cellsCollapsedStates[key] != nil
  }

  func removeExpandedValue(forKey key: String) {
    cellsCollapsedStates.removeValue(forKey: key)
  }

  func removeAllValues() {
    cellsCollapsedStates.removeAll()
  }

  // MARK: - Setup
  override func initConfigure() {
    setSelectedTabBar()
    setupView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateNavigationBarColor()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
		CartService.shared.cartDidUpdated = { [weak self] _ in
			self?.setupDataSource()
		}
    loadCartData()
    logViewCart()
  }
  
  private func setupView() {
    if let tabBarHeight = tabBarController?.tabBar.frame.height {
      let bottom = tabBarHeight - Constants.Screen.bottomSafeAreaInset - MainTabBarController.centerItemOffset
      additionalSafeAreaInsets = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: bottom,
                                              right: 0)
    }
    setupSelfView()
    localizeLabels()
  }
  
  private func setupSelfView() {
    selfView.getRefreshControl().addTarget(self,
                                           action: #selector(refresh),
                                           for: .valueChanged)
    setupTableView()
    selfView.setEmptyViewHidden(false)
    selfView.addEmptyViewButtonTarget(self,
                                      action: #selector(backToProducts),
                                      for: .touchUpInside)
  }
  
  private func setupTableView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
  
  private func logViewCart() {
    EventService.shared.logViewCart(
			items: CartService.shared.cart?.cartItems.compactMap { $0.id } ?? [],
      value: CartService.shared.cart?.totalPrice ?? 0)
  }
  
  private func localizeLabels() {
    navigationItem.title = Localizator.standard.localizedString("Корзина")
    let title = Localizator.standard.localizedString("Ваша корзина\nпуста :(")
    let subtitle = Localizator.standard.localizedString("Желаете приобрести ювелирные изделия? Посмотрите наши хиты продаж, загляните в товары со скидкой.")
    let buttonTitle = Localizator.standard.localizedString("Вернуться к покупкам").uppercased()
    selfView.setEmptyView(image: #imageLiteral(resourceName: "package"),
                          title: title,
                          subtitle: subtitle,
                          buttonTitle: buttonTitle)

    if let _ = CartService.shared.cart {
      selfView.getTableView().reloadData()
    }
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  override func localize() {
    localizeLabels()
    loadCartData()
  }
  
  // MARK: - Actions

  private func shouldShowCreditWarning() -> Bool {
    // TODO: - Add check fot available credit options
    return false
  }
  
  private func setupDataSource() {

    guard let cart = CartService.shared.cart,
      !cart.cartItems.isEmpty else {
        selfView.setEmptyViewHidden(false)
        dataSource = []
        selfView.getTableView().reloadData()

        return
    }
		debounceTimer?.invalidate()
		debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
			DispatchQueue.main.async {
				self.selfView.setEmptyViewHidden(true)
				
				self.dataSource = [.title(Localizator.standard.localizedString("Товары в корзине"))]
				
				if self.shouldShowCreditWarning() {
					self.dataSource.append(.creditWarning)
				}
				
				cart.cartItems.forEach { cartItemModel in
					self.dataSource.append(.cartItem(cartItemModel))
					self.dataSource.append(.spacing(40.0))
				}
				
				if let priceDetails = CartService.shared.priceDetails {
					self.dataSource.append(.spacing(20.0))
					self.dataSource.append(.totalPrice(self.getPriceViewModel(from: priceDetails, cart: cart)))
				}
				
				self.dataSource.append(.button)
				
				self.selfView.getTableView().reloadData()
			}
		}
  }
  
  private func getPriceViewModel(from cartPriceDetails: CartPriceDetails, cart: Cart) -> PriceDetailsViewModel {

    typealias Item = PriceDetailsViewModel.Item

		var selectedExchangesCount = 0
		for item in cart.cartItems {
			for service in item.services ?? [] {
				for option in service.options where option.selected {
          selectedExchangesCount += 1
				}
			}
		}

		let exchange = Item.exchange(amount: selectedExchangesCount, price: cartPriceDetails.amountExchange)
	
    let discounts: [Item] = {
      
      var result = [Item]()
      
      if cartPriceDetails.promoDiscount > 0 {
        result.append(.discount(.promocode, cartPriceDetails.promoDiscount))
      }
      
      if cartPriceDetails.personalBonuses > 0 {
        result.append(.discount(.bonusUsage, cartPriceDetails.personalBonuses))
      }
      
      if cartPriceDetails.actionBonuses > 0 {
        result.append(.discount(.promoBonus, cartPriceDetails.actionBonuses))
      }

      // certificate
      
      if cartPriceDetails.personalDiscount > 0 {
        result.append(.discount(.discount, cartPriceDetails.personalDiscount))
      }
      
      if cartPriceDetails.birthdayDiscountAmount > 0 {
        result.append(.discount(.birthday, cartPriceDetails.birthdayDiscountAmount))
      }
      
      if cartPriceDetails.marketingDiscountAmount > 0 {
        result.append(.discount(.additionalPromo, cartPriceDetails.marketingDiscountAmount))
      }
            
      return result
    }()
        
    let cashback = Item.cashback(cartPriceDetails.cashback)
    
    let total = Item.total(cartPriceDetails.totalPrice!)
		//products number and total price
		let header = Item.header(goodsNumber: cart.cartItems.count, price: cartPriceDetails.orderAmount)
		
    let priceVM = PriceDetailsViewModel(
			header: header,
			exchange: cartPriceDetails.amountExchange > 0 ? exchange : nil,
      discounts: discounts,
      delivery: nil,
      cashback: cashback,
      total: total)
    return priceVM
  }
  
  private func loadCartData(silently: Bool = false) {
    if !silently {
      HUD.showProgress()
    }
    
    performLoadCartRequest { [weak self] (cart) in
      let completeBlock = {
        HUD.hide()
        self?.selfView.getRefreshControl().endRefreshing()
        self?.setSelectedTabBar()
        
				self?.setupDataSource()
      }
      
      guard let self = self,
            let cartItemsCount = cart?.cartItems.count,
            cartItemsCount > 0 else {
              
              completeBlock()
              return }
      
      self.calculateCart {
        completeBlock() 
      }
    }
  }
  
  private func performLoadCartRequest(completion: @escaping (Cart?) -> Void) {
    CartService.shared.getCart { [weak self] response in
      DispatchQueue.main.async {
        guard let self = self else { return }

        switch response {
        case .failure(let error):
          self.handleError(error)

          completion(nil)
        case .success(let cart):
          completion(cart)
        }
      }
    }
  }
  
  private func calculateCart(completion: @escaping (() -> Void)) {
      
    CartService.shared.calculateCart { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }

        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let model):
					if model.changedResponse ?? false {
						self.handleError(ServerError.unknown)
						self.setupDataSource()
					}
        }

        completion()
      }
    }
  }
	
	private func addExchangeOptionToCart(variantId: Int, sku: String, exchange: ExtraServiceOption?, completion: @escaping (_ result: Result<Cart>) -> Void) {
		CartService.shared.addToCartVariantBy(variantId: variantId, sku: sku, exchange: exchange, completion: completion)
	}
  
  private func removeFromCart(cartItem: CartItem) {
    HUD.showProgress()
    CartService.shared.removeFromCart(by: cartItem.id, sku: cartItem.sku) { [weak self] response in
      guard let self = self else { return }

      DispatchQueue.main.async {
        switch response {
        case .failure(let error):
          self.handleError(error)
        case .success(let cart):
          if !cart.cartItems.isEmpty {
           
            self.calculateCart {
              HUD.hide()
              self.setSelectedTabBar()
              self.selfView.getRefreshControl().endRefreshing()

              self.removeExpandedValue(forKey: cartItem.sku)
            }
          } else {
            HUD.hide()
            self.setSelectedTabBar()
            self.selfView.getRefreshControl().endRefreshing()

            self.removeExpandedValue(forKey: cartItem.sku)
          }
        }
      }
    }
  }
  
  private func logRemoveFromCart(cartItem: CartItem) {
    EventService.shared.logRemoveFromCart(
      items: [cartItem.id],
			value: CartService.shared.cart?.totalPrice ?? 0)
  }
  
  private func setSelectedTabBar() {
    guard let cartViewController = tabBarController?.viewControllers?[MainTabBarItemOrder.cart.rawValue] else { return }
    if tabBarController?.selectedViewController == cartViewController {
      tabBarController?.selectedViewController = cartViewController
    }
  }
  
  @objc
  private func refresh() {
    loadCartData(silently: true)
  }
  
  @objc
  private func backToProducts() {
    output?.showProducts(from: self)
  }
  
  @objc
  private func order() {
    output?.createOrder(from: self)
  }
}

// MARK: - UIConstants
private enum UIConstants {
  
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {

    case .creditWarning:
      
      let cell = selfView.createCreditWarningCell(tableView: tableView, indexPath: indexPath)
      let text = Localizator.standard.localizedString("Вы не сможете воспользоваться оплатой частями. В заказе есть товары, для которых она недоступна.")
      cell.setup(text: text)
      return cell
      
    case .title(let title):
      
      let cell = selfView.createTitleCell(tableView: tableView, indexPath: indexPath)
      cell.configure(title: title)
      return cell

    case .cartItem(let cartItem):
      
      let cell = selfView.createCartItemCell(tableView: tableView, indexPath: indexPath)
      cell.configure(cartItem: cartItem)
      cell.delegate = self
      return cell
      
    case .button:
      
      let cell = selfView.createButtonCell(tableView: tableView, indexPath: indexPath)
      return cell
      
    case .totalPrice(let vm):
      
      let cell = selfView.createTotalPriceCell(tableView: tableView, indexPath: indexPath)
      cell.configure(viewModel: vm)
      
      return cell
      
    case .spacing(let height):
      
      let cell = selfView.createSpacingCell(tableView: tableView, indexPath: indexPath)
      cell.configure(space: height)
      return cell
      
    }
  }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch dataSource[indexPath.row] {

    case .cartItem(let cartItem):
      output?.showProduct(productId: "\(cartItem.productId)", from: self)
      
    case .button:
      
      output?.createOrder(from: self)
    default: break
    }
  }
}

// MARK: - CartItemTableViewCellDelegate
extension CartViewController: CartItemTableViewCellDelegate {
	func exchangeOptionInfoTapped(_ cell: CartItemTableViewCell, rect: CGRect) {
		guard let indexPath = selfView.getTableView().indexPath(for: cell),
					let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first,
					case let CartDataSourceItem.cartItem(cartItem) = dataSource[indexPath.row] else { return }
		var message = ""
		switch cartItem.preselectedExchangeVariant {
			
		case .sixMonths:
			message = Localizator.standard.localizedString("Услуга обмена «Двойное преимущество» гарантирует возможность обменять приобретенное украшение на другое в течение 6-ти месяцев без объяснения причины. Обязательно сохраните бирку изделия и чек покупки для обмена. P.S. Если новое украшение будет дешевле по цене, мы вернем вам остаток денег.")
		case .nineMonths:
			message = Localizator.standard.localizedString("Услуга обмена «Двойное преимущество» гарантирует возможность обменять приобретенное украшение на другое в течение 9-ти месяцев без объяснения причины. Обязательно сохраните бирку изделия и чек покупки для обмена. P.S. Если новое украшение будет дешевле по цене, мы вернем вам остаток денег.")
		case .none:
			return
		}
		let tipView = CreditInfoTipView(originRect: rect, message: message, clickedText: Localizator.standard.localizedString("Подробнее"))
		tipView.delegate = self
		tipView.display(in: window)
	}
	
	func didTapOnExchange(exchangeVariant: ExchangeItem, in tableViewCell: CartItemTableViewCell) {
		guard let index = selfView.getTableView().indexPath(for: tableViewCell)?.row,
		case let CartDataSourceItem.cartItem(cartItem) = dataSource[index] else { return }
		let option = cartItem.exchangeOptions[exchangeVariant.rawValue]
		CartService.shared.setNewPreselectedVariant(for: cartItem, variant: exchangeVariant, forced: true)
//		self.setupDataSource()
		HUD.showProgress()
		self.addExchangeOptionToCart(variantId: cartItem.id, sku: cartItem.sku, exchange: option) { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self else { return }
				self.calculateCart {
					HUD.hide()
					self.setSelectedTabBar()
					self.selfView.getRefreshControl().endRefreshing()

					self.removeExpandedValue(forKey: cartItem.sku)
					
					self.setupDataSource()
				}
			}
		}
		
	}
	
  func didTapOnRemoveFromCart(in tableViewCell: CartItemTableViewCell) {
    guard let index = selfView.getTableView().indexPath(for: tableViewCell)?.row,
    case let CartDataSourceItem.cartItem(cartItem) = dataSource[index] else { return }
    logRemoveFromCart(cartItem: cartItem)
    removeFromCart(cartItem: cartItem)
  }
	
	func exchangeCellTappedMonths(_ cell: CartItemTableViewCell) {
		
		guard let index = selfView.getTableView().indexPath(for: cell)?.row,
		case let CartDataSourceItem.cartItem(cartItem) = dataSource[index] else { return }
		let variants = cartItem.availableExchangeVariants.map({ $0.rawValue })
			
		self.pickerDataSource = (months: variants, selectedMonth: cartItem.preselectedExchangeVariant.rawValue, indexPath: index)
			presentPicker()
		
	}
}

// MARK: - Picker

private extension CartViewController {
	
	func presentPicker() {

		let pickerView = ExchangeMonthPickerView(months: pickerDataSource.months, selectedMonth: pickerDataSource.selectedMonth)
				
		pickerView.onDoneTap = { [weak self] selectedMonth in
			
			self?.handleSelectedMonths(selectedMonth)
		}
		
		pickerView.displayIn(container: view)
	}
	
	func handleSelectedMonths(_ months: String) {
		
		guard let index = pickerDataSource?.indexPath else { return }
				
		if case let CartDataSourceItem.cartItem(cartItem) = dataSource[index],
			 let newVariant = ExchangeItem(rawValue: months) {
			if cartItem.preselectedExchangeVariant != newVariant {
				CartService.shared.setNewPreselectedVariant(for: cartItem, variant: newVariant)
				self.removeExpandedValue(forKey: cartItem.sku)
				self.setupDataSource()
			}
		}
		pickerDataSource = nil
	}
}

extension CartViewController: CreditInfoTipViewDelegate {
	func didTapOnActiveLabel(from: CreditInfoTipView) {
		output?.didTapOnExchangeDetailsLink(from: self)
	}
}

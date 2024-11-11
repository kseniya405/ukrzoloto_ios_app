//
//  CreditOptionsViewController.swift
//  UkrZoloto
//
//  Created by Mykola on 25.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import PKHUD
import AUIKit
import UIKit

protocol CreditOptionsViewControllerOutput: AnyObject {
  
  func creditOptionsViewControllerTappedBack()
  func creditOptionsViewControllerSelectedCreditOption(viewController: UIViewController)
}

class CreditOptionsViewController: LocalizableViewController, NavigationButtoned, AlertDisplayable {
  
  weak var output: CreditOptionsViewControllerOutput?
  
  private var product: Product!
  private var variant: Variant!
	private var credits: [CreditOption]!
  private let selfView = CreditOptionsView()
  
  private var dataSource: [CreditOptionsItem] = []
  
  private var pickerDataSource: (months: [Int], selectedMonth: Int, indexPath: IndexPath)!
    
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func loadView() {
    view = selfView
  }
  
	convenience init(product: Product, variant: Variant) {
    self.init(shouldDisplayOnFullScreen: true)

    self.product = product
    self.variant = variant
		self.credits = variant.creditList
  }
  
  override func initConfigure() {
    super.initConfigure()
    
    configureSelf()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
	override func viewDidLoad() {
		super.viewDidLoad()
		setupDataSource(options: credits)
	}
	
  private func configureSelf() {
    configureNavigationBar()
    configureSelfView()
    localizeLabels()
  }
  
	func setupDataSource(options: [CreditOption]) {
    selfView
      .getProductDetailsView()
      .configure(imageUrl: product.image, title: product.name, price: variant.price)
        
    func itemFor(option: CreditOption, expanded: Bool) -> CreditOptionsItem {
      
      let bank = Bank(rawValue: option.code)!
      
      let months = bank.getAvailableMonths(option.month)
            
      let selectedMonth = bank == .privatInstallment ? months.max()! : months.min()!
      
      let monthlyPayment = CreditCalculator.getMonthlyPayment(price: variant.price.current,
                                                              comission: option.comission,
                                                              months: selectedMonth)
      
      return CreditOptionsItem.option(data: CreditOptionData(bank: bank,
                                                             title: option.title,
                                                             availableMonths: months,
                                                             months: selectedMonth,
                                                             expanded: expanded,
                                                             description: option.descriptionString,
                                                             comission: option.comission,
                                                             monthlyPayment: monthlyPayment))
    }

    var result = [CreditOptionsItem]()

    if let monobankItem = options.filter({ Bank(rawValue: $0.code) == .monobank }).first {
      result.append(itemFor(option: monobankItem, expanded: true))
    }

    if let privatItem = options.filter({ Bank(rawValue: $0.code) == .privat }).first {
      result.append(itemFor(option: privatItem, expanded: result.isEmpty))
    }

    if let abank = options.filter({ Bank(rawValue: $0.code) == .abank }).first {
      result.append(itemFor(option: abank, expanded: result.isEmpty))
    }

    if let alphaItem = options.filter({ Bank(rawValue: $0.code) == .alpha }).first {
      result.append(itemFor(option: alphaItem, expanded: result.isEmpty))
    }

    if let privatInstallment = options.filter({ Bank(rawValue: $0.code) == .privatInstallment }).first {
      result.append(itemFor(option: privatInstallment, expanded: result.isEmpty))
    }

    if let otp = options.filter({ Bank(rawValue: $0.code) == .otp }).first {
      result.append(itemFor(option: otp, expanded: result.isEmpty))
    }

    if let globus = options.filter({ Bank(rawValue: $0.code) == .globusPlus }).first {
      result.append(itemFor(option: globus, expanded: result.isEmpty))
    }

    dataSource = result
    selfView.getTableView().reloadData()
  }
  
  private func configureSelfView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
  
  private func configureNavigationBar() {
    updateNavigationBarColor()
    setNavigationButton(#selector(didTapOnBack),
                        button: ButtonsFactory.backButtonForNavigationItem())
  }
  
  private func updateNavigationBarColor() {
    (navigationController as? ColoredNavigationController)?.configure(with: .green)
  }
  
  func localizeLabels() {
    
    navigationItem.title = Localizator.standard.localizedString("Выбор кредита")
    selfView.localizeContent() 
  }
}

// MARK: -
extension CreditOptionsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch dataSource[indexPath.row] {
    case .title(let imageUrl, let title, let price):
      
      let cell: CreditProductTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(imageUrl: imageUrl, title: title, price: price)
      return cell
      
    case .option(let data):
      
      let cell: CreditOptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      
      let monthlyPayment = CreditCalculator.getMonthlyPayment(price: variant.price.current,
                                                              comission: data.comission,
                                                              months: data.months)
            
      cell.configure(bank: data.bank,
                     title: data.title,
                     comissionRate: data.comission,
                     months: data.months,
                     monthlyPayment: monthlyPayment,
                     expanded: data.expanded)
      
      cell.delegate = self
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch dataSource[indexPath.row] {
    case .title(_, _, _):
      return 182.0
    case .option(let data):
      return data.expanded ? 245.0 : 100.0
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let cell = tableView.cellForRow(at: indexPath) as? CreditOptionTableViewCell else {
      return
    }
    
    toggleCell(cell: cell, indexPath: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    let view = UIView()
    view.backgroundColor = .white
    
    return view 
  }
  
  func toggleCell(cell: CreditOptionTableViewCell, indexPath: IndexPath) {
      
    if case let CreditOptionsItem.option(item) = dataSource[indexPath.row] {
      
      var newItem = item
      newItem.toggle()
      
      dataSource[indexPath.row] = CreditOptionsItem.option(data: newItem)
      
      cell.setExpanded(!item.expanded, animated: true)
      
      selfView.getTableView().beginUpdates()
      selfView.getTableView().endUpdates()
      selfView.getTableView().scrollToRow(at: indexPath, at: .none, animated: true)      
    }
  }
}

extension CreditOptionsViewController: CreditOptionTableViewCellDelegate {
  
  func bankOptionCellTappedMonths(_ cell: CreditOptionTableViewCell) {
    
    guard let indexPath = selfView.getTableView().indexPath(for: cell) else { return }
        
    if case let CreditOptionsItem.option(data) = dataSource[indexPath.row] {
      
      self.pickerDataSource = (months: data.availableMonths, selectedMonth: data.months, indexPath: indexPath)
      presentPicker()
    }
  }
  
  func bankOptionSelected(_ cell: CreditOptionTableViewCell) {
    if let indexPath = selfView.getTableView().indexPath(for: cell),
       case let CreditOptionsItem.option(data) = dataSource[indexPath.row] {
      
      let dto = CreditDTO(bank: data.bank, months: data.months, variantId: variant.id)
      
      CartService.shared.addToCartWithCreditPayment(creditDTO: dto) { [weak self] result in
        
        switch result {
        case .success(_):
          
          guard let self = self else { return }
          EventService.shared.logAddToCartWithCredit(bankCode: dto.bank.rawValue, months: dto.months)
          self.output?.creditOptionsViewControllerSelectedCreditOption(viewController: self)
          
        case .failure(let error):
          self?.showAlert(title: error.localizedDescription)
        }
      }      
    }
  }
  
  func bankOptionInfoTapped(_ cell: CreditOptionTableViewCell, rect: CGRect) {
    displayInfo(cell: cell, rect: rect)
  }
}

// MARK: - Actions

private extension CreditOptionsViewController {
  
  @objc func didTapOnBack(_ sender: Any) {
    output?.creditOptionsViewControllerTappedBack()
  }
  
  func displayInfo(cell: CreditOptionTableViewCell, rect: CGRect) {
    
    guard let indexPath = selfView.getTableView().indexPath(for: cell),
          let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first,
          case let CreditOptionsItem.option(data) = dataSource[indexPath.row] else { return }
    
    cell.setInfoIcon(highlighted: true)
    
    let message = data.description
    
    let tipView = CreditInfoTipView(originRect: rect, message: message)
    
    tipView.onDismiss = { [weak cell] in
      cell?.setInfoIcon(highlighted: false)
    }
    
    tipView.display(in: window)
  }
}

// MARK: - Picker

private extension CreditOptionsViewController {
  
  func presentPicker() {

    let pickerView = CreditMonthPickerView(months: pickerDataSource.months, selectedMonth: pickerDataSource.selectedMonth)
        
    pickerView.onDoneTap = { [weak self] selectedMonth in
      
      self?.handleSelectedMonths(selectedMonth)
    }
    
    pickerView.displayIn(container: view)
  }
  
  func handleSelectedMonths(_ months: Int) {
    
    guard let indexPath = pickerDataSource?.indexPath else { return }
    
    if case let CreditOptionsItem.option(item) = dataSource[indexPath.row] {
      
      var newItem = item
      newItem.updateMonths(months)
      let payment = CreditCalculator.getMonthlyPayment(price: variant.price.current,
                                                       comission: item.comission,
                                                       months: months)
      newItem.updateMonthlyPayment(payment)
      
      dataSource[indexPath.row] = CreditOptionsItem.option(data: newItem)
            
      selfView.getTableView().reloadRows(at: [indexPath], with: .none)
      
      pickerDataSource = nil
    }
  }
}

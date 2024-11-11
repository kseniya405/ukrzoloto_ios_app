//
//  DeliveryViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import PKHUD

protocol DeliveryViewControllerOutput: AnyObject {
  func showSelectLocationDialog(for deliveryCode: String,
                                location: Location?,
                                withShops: Bool,
                                from viewController: DeliveryViewController)
  func didSelectDelivery(_ delivery: DeliveryMethod, shouldProceedToOrder: Bool)
}

private enum DeliveryItem {
  case title(String)
  case location(LocationDeliveryController, code: String)
  case address(AddressDeliveryController, code: String)
}

class DeliveryViewController: LocalizableViewController, ErrorAlertDisplayable {

  // MARK: - Public variables
  var output: DeliveryViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = DeliveryView()
  
  private var dataSource = [DeliveryItem]()
  private var deliveries = [DeliveryMethod]()
  private var loadingState = LoadingState.readyForLoading
  private var associatedDeliveries: [ASTHashedReference: DeliveryMethod] = [:]
  private var selectedDelivery: DeliveryItem? {
    didSet {
      if let item = selectedDelivery {
        
        switch item {
        case .address(_, let code):
          EventService.shared.logShippingInfo(shippingCode: code)
        case .location(_, let code):
          EventService.shared.logShippingInfo(shippingCode: code)
        default: break 
        }
      }
    }
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
    addObserver()
    setupSelfView()
    localizeLabels()
    updateContinueButtonState()
  }
  
  private func addObserver() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  private func setupSelfView() {
    selfView.addContinueButtonTarget(self,
                                     action: #selector(continueOrder),
                                     for: .touchUpInside)
    setupTableView()
  }
  
  private func setupTableView() {
    selfView.getTableView().delegate = self
    selfView.getTableView().dataSource = self
  }
    
  func localizeLabels() {
    selfView.setContinueTitle(Localizator.standard.localizedString("Продолжить").uppercased())
  }
  
  override func localize() {
    localizeLabels()
    loadData()
  }

  func isDeliverySelected() -> Bool {
    guard let selectedDelivery = selectedDelivery else { return false }

    switch selectedDelivery {
    case .location(let controller, _):
      return controller.locationDeliveryViewModel?.location != nil && controller.locationDeliveryViewModel?.sublocation != nil
    default:
      return false
    }
  }
  
  // MARK: - Interface
	func selectLocation(_ location: Location, parentLocation: Location?, shop: NewShopsItem?) {
    guard let selectedDelivery = selectedDelivery else { return }
    switch selectedDelivery {
    case .location(let controller, _):
      if parentLocation != nil {
        controller.locationDeliveryViewModel?.sublocation = location
				controller.locationDeliveryViewModel?.shop = shop
      } else {
        controller.locationDeliveryViewModel?.location = location
        controller.locationDeliveryViewModel?.sublocation = nil
      }

      selfView.getTableView().reloadData()
    case .address(let controller, _):
      if parentLocation != nil {
        controller.addressDeliveryViewModel?.sublocation = location
        controller.addressDeliveryViewModel?.street = location.title
      } else {
        controller.addressDeliveryViewModel?.location = location
        controller.addressDeliveryViewModel?.sublocation = nil
      }

      selfView.getTableView().reloadData()
    case .title: break
    }
    updateContinueButtonState()
  }
  
  // MARK: - Actions
  private func loadData(silently: Bool = false) {
    loadingState = .loading
    if !silently {
      HUD.showProgress()
    }
    CartService.shared.getDeliveries { [weak self] response in
      DispatchQueue.main.async {
        HUD.hide()
        guard let self = self else { return }
        switch response {
        case .failure(let error):
          self.loadingState = .failed
          self.handleError(error)
        case .success(let deliveries):
          self.setupDataSource(deliveries)
          self.loadingState = .finished
        }
      }
    }
  }
  
  private func setupDataSource(_ deliveries: [DeliveryMethod]) {
    dataSource = []
    associatedDeliveries = [:]
    dataSource.append(.title(Localizator.standard.localizedString("Способ доставки")))
    for (_, delivery) in deliveries.enumerated() {
      switch delivery.type {
      case .location:
        let locationPlaceholder = Localizator.standard.localizedString("Выберите город")
        let sublocationPlaceholder: String
        if delivery.code == NetworkResponseKey.Delivery.DeliveryCode.novaPoshtaLocation {
          sublocationPlaceholder = Localizator.standard.localizedString("Выберите отделение")
        } else if delivery.code == NetworkResponseKey.Delivery.DeliveryCode.novaPoshtaParcelLockers {
          sublocationPlaceholder = Localizator.standard.localizedString("Выберите почтомат")
        } else if delivery.code == NetworkResponseKey.Delivery.DeliveryCode.novaPoshtaAddress {
          sublocationPlaceholder = Localizator.standard.localizedString("Выберите улицу")
        } else {
          sublocationPlaceholder = Localizator.standard.localizedString("Выберите магазин")
        }
        let controller = LocationDeliveryController()

        let viewModel = LocationDeliveryViewModel(delivery: delivery,
                                                  locationPlaceholder: locationPlaceholder,
                                                  sublocationPlaceholder: sublocationPlaceholder,
                                                  isSelected: false)

        controller.locationDeliveryViewModel = viewModel
        controller.delegate = self
				controller.scheduleDelegate = self
        dataSource.append(.location(controller, code: delivery.code))
        associatedDeliveries[ASTHashedReference(controller)] = delivery

      case .address:
        let locationPlaceholder = Localizator.standard.localizedString("Выберите город")
        let streetPlaceholder = Localizator.standard.localizedString("Выберите улицу")
        let housePlaceholder = Localizator.standard.localizedString("Номер дома*")
        let apartmentPlaceholder = Localizator.standard.localizedString("Квартира")
        let controller = AddressDeliveryController()

        let viewModel = AddressDeliveryViewModel(delivery: delivery,
                                                 streetPlaceholder: streetPlaceholder,
                                                 housePlaceholder: housePlaceholder,
                                                 apartmentPlaceholder: apartmentPlaceholder,
                                                 locationPlaceholder: locationPlaceholder,
                                                 isSelected: false)

        controller.addressDeliveryViewModel = viewModel
        controller.delegate = self

        dataSource.append(.address(controller, code: delivery.code))
        associatedDeliveries[ASTHashedReference(controller)] = delivery
      }
      selfView.getTableView().reloadData()
    }
    updateContinueButtonState()
  }
  
  private func deselectAll() {
    for item in dataSource {
      if case let .location(controller, _) = item,
        controller.locationDeliveryViewModel?.isSelected == true {
        controller.locationDeliveryViewModel?.isSelected = false
      }
      if case let .address(controller, _) = item,
        controller.addressDeliveryViewModel?.isSelected == true {
        controller.addressDeliveryViewModel?.isSelected = false
      }
    }
  }
  
  private func updateContinueButtonState() {
    switch selectedDelivery {
    case .none:
      selfView.setButtonEnabled(false)
    case .location(let controller, _)?:
      if let model = controller.locationDeliveryViewModel,
        model.location != nil,
        model.sublocation != nil {
        selfView.setButtonEnabled(true)
      } else {
        selfView.setButtonEnabled(false)
      }
    case .address(let controller, _)?:
      if let model = controller.addressDeliveryViewModel,
        model.location != nil,
        model.sublocation != nil,
        Validator.isValidString(model.house, ofType: .house),
        Validator.isValidString(model.apartment, ofType: .apartment) {

        selfView.setButtonEnabled(true)
      } else {
        selfView.setButtonEnabled(false)
      }
    case .title?:
      break
    }
  }
  
  @objc func continueOrder() {
    updateDelivery(shouldProceedToOrder: true)
  }

  private func updateDelivery(shouldProceedToOrder: Bool) {
    guard let selectedDelivery = selectedDelivery else { return }
    switch selectedDelivery {
    case .address(let controller, _):
      guard var delivery = associatedDeliveries[ASTHashedReference(controller)] else { return }
      let viewModel = controller.addressDeliveryViewModel
      guard
        let location = controller.addressDeliveryViewModel?.location,
        let sublocation = controller.addressDeliveryViewModel?.sublocation,
        let street = controller.addressDeliveryViewModel?.sublocation?.title,
        let house = viewModel?.house else { return }

      delivery.type = .address(
        location: location,
        sublocation: sublocation,
        address: Address(street: street, house: house, apartment: viewModel?.apartment))

      output?.didSelectDelivery(delivery, shouldProceedToOrder: shouldProceedToOrder)
    case .location(let controller, _):
      guard var delivery = associatedDeliveries[ASTHashedReference(controller)],
        let location = controller.locationDeliveryViewModel?.location,
        let sublocation = controller.locationDeliveryViewModel?.sublocation else { return }

      delivery.type = .location(location: location, sublocation: sublocation)

      output?.didSelectDelivery(delivery, shouldProceedToOrder: shouldProceedToOrder)
    case .title:
      break
    }
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
}

private enum UIConstants {
}

extension DeliveryViewController: ShopDeliveryScheduleViewDelegate {
	func needUIUpdate() {
		selfView.getTableView().performBatchUpdates(nil)
	}
}

// MARK: - UITableViewDataSource
extension DeliveryViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .title(let title):
      let cell = selfView.createTitleCell(tableView: tableView, indexPath: indexPath)
      cell.configure(title: title)
      return cell
    case .location(let controller, _):
      let cell = selfView.createLocationCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    case .address(let controller, _):
      let cell = selfView.createAddressCell(tableView: tableView, indexPath: indexPath)
      controller.view = cell.containerView
      return cell
    }
  }
}

// MARK: - UITableViewDelegate
extension DeliveryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didEndDisplaying cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    guard dataSource.indices.contains(indexPath.row) else { return }
    switch dataSource[indexPath.row] {
    case .location(let controller, _):
      controller.view = nil
    case .address(let controller, _):
      controller.view = nil
    case .title:
      break
    }
  }
}

// MARK: - LocationDeliveryControllerDelegate
extension DeliveryViewController: LocationDeliveryControllerDelegate {
  func didSelect(locationDeliveryController: LocationDeliveryController) {
    guard let viewModel = locationDeliveryController.locationDeliveryViewModel,
      !viewModel.isSelected else { return }
    deselectAll()
    locationDeliveryController.locationDeliveryViewModel?.isSelected = true
    selectedDelivery = .location(locationDeliveryController, code: viewModel.code)
    selfView.getTableView().reloadData()
    updateDelivery(shouldProceedToOrder: false)
    updateContinueButtonState()
  }
  
  func didSelectCity(in controller: LocationDeliveryController) {
    guard let deliveryCode = controller.locationDeliveryViewModel?.code else { return }
    output?.showSelectLocationDialog(for: deliveryCode,
                                     location: nil,
                                     withShops: false,
                                     from: self)
  }
  
  func didSelectOffice(in controller: LocationDeliveryController) {
    guard let deliveryCode = controller.locationDeliveryViewModel?.code,
      let location = controller.locationDeliveryViewModel?.location else { return }
    output?.showSelectLocationDialog(for: deliveryCode,
                                     location: location,
                                     withShops: controller.locationDeliveryViewModel?.code == NetworkResponseKey.Delivery.DeliveryCode.selfDelivery,
                                     from: self)
  }
}

// MARK: - AddressDeliveryControllerDelegate
extension DeliveryViewController: AddressDeliveryControllerDelegate {
  func didSelectCity(in controller: AddressDeliveryController) {
    guard let deliveryCode = controller.addressDeliveryViewModel?.code else { return }
    output?.showSelectLocationDialog(for: deliveryCode,
                                     location: nil,
                                     withShops: false,
                                     from: self)
  }

  func didSelectStreet(in controller: AddressDeliveryController) {
    guard
      let deliveryCode = controller.addressDeliveryViewModel?.code,
      let location = controller.addressDeliveryViewModel?.location else { return }
    output?.showSelectLocationDialog(for: deliveryCode,
                                     location: location,
                                     withShops: false,
                                     from: self)
  }

  func didSelect(addressDeliveryController: AddressDeliveryController) {
    guard let viewModel = addressDeliveryController.addressDeliveryViewModel,
      !viewModel.isSelected else { return }
    deselectAll()
    addressDeliveryController.addressDeliveryViewModel?.isSelected = true
    selectedDelivery = .address(addressDeliveryController, code: viewModel.code)
    selfView.getTableView().reloadData()
    updateDelivery(shouldProceedToOrder: false)
    updateContinueButtonState()
  }
  
  func didChangeModel(_ updatedViewModel: AddressDeliveryViewModel, in controller: AddressDeliveryController) {
    updateDelivery(shouldProceedToOrder: false)
    updateContinueButtonState()
  }
  
}

// MARK: - ValidateControllerDelegate
extension DeliveryViewController: ValidateControllerDelegate {
  func didEndEditing(_ textField: UITextField) { }
  
  func didTextFieldWasChanged(_ textField: UITextField?, with type: Validator.ValidatorType) {
    updateContinueButtonState()
  }
  
  func textFieldWillReturn(_ textField: UITextField) {
    for cellData in dataSource {
      switch cellData {
      case let .address(controller, _):
        switch textField {
        case controller.getHouseTextField():
          controller.getApartmentTextField()?.becomeFirstResponder()
        case controller.getApartmentTextField():
          controller.getApartmentTextField()?.resignFirstResponder()
          return
        default:
          continue
        }
        return
      default:
        continue
      }
    }
  }
}

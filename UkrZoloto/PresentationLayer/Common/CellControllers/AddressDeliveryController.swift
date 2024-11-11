//
//  AddressDeliveryController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol AddressDeliveryControllerDelegate: ValidateControllerDelegate {
  func didSelect(addressDeliveryController: AddressDeliveryController)
  func didSelectCity(in controller: AddressDeliveryController)
  func didSelectStreet(in controller: AddressDeliveryController)
  func didChangeModel(_ updatedViewModel: AddressDeliveryViewModel, in controller: AddressDeliveryController)
}

class AddressDeliveryController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: AddressDeliveryControllerDelegate?
  
  var deliveryView: AddressDeliveryTypeView? {
    set { view = newValue }
    get { return view as? AddressDeliveryTypeView }
  }
  
  var addressDeliveryViewModel: AddressDeliveryViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Private variables
  private var validateControllers: [UITextField: ValidateController] = [:]
  
  // MARK: - Actions
  private func didSetViewModel() {
    guard let addressViewModel = addressDeliveryViewModel else { return }
    
    deliveryView?.setTitle(addressViewModel.title)
    deliveryView?.setSubtitle(addressViewModel.subtitle)

    let cityTitle = addressViewModel.location?.title ?? addressViewModel.locationPlaceholder
    deliveryView?.setCityTitle(cityTitle)
    let locationColor = addressViewModel.location != nil ? UIConstants.textColor : UIConstants.placeholderTextColor
    deliveryView?.setCityTextColor(locationColor)

    let streetTitle = addressViewModel.sublocation?.title ?? addressViewModel.streetPlaceholder
    deliveryView?.setStreetTitle(streetTitle)
    let sublocationColor = addressViewModel.sublocation != nil ? UIConstants.textColor : UIConstants.placeholderTextColor
    deliveryView?.setStreetTextColor(sublocationColor)

    deliveryView?.setHouse(addressViewModel.house)
    deliveryView?.setHousePlaceholder(addressViewModel.housePlaceholder)

    deliveryView?.setApartment(addressViewModel.apartment)
    deliveryView?.setApartmentPlaceholder(addressViewModel.apartmentPlaceholder)
    
    deliveryView?.isBottomViewHidden = !addressViewModel.isSelected
    deliveryView?.setRadioBoxState(addressViewModel.isSelected ? .active : .inactive)
  }
  
  override func setupView() {
    super.setupView()
    deliveryView?.addRadioBoxTarget(self, action: #selector(radioBoxTapped))
    deliveryView?.addCityTarget(self, action: #selector(cityTapped))
    deliveryView?.addStreetTarget(self, action: #selector(streetTapped))
                                  
    deliveryView?.getHouseTextField().addTarget(self,
                                                action: #selector(houseChanged),
                                                for: .editingChanged)
    deliveryView?.getApartmentTextField().addTarget(self,
                                                    action: #selector(apartmentChanged),
                                                    for: .editingChanged)
    validateControllers = getValidatorControllers()
    didSetViewModel()
  }
  
  override func unsetupView() {
    super.unsetupView()
    deliveryView?.removeRadioBoxTarget()

    deliveryView?.getHouseTextField().removeTarget(nil, action: nil, for: .editingChanged)
    deliveryView?.getApartmentTextField().removeTarget(nil, action: nil, for: .editingChanged)
    validateControllers = [:]
  }
  
  // MARK: - Interface  
  func getHouseTextField() -> UITextField? {
    return deliveryView?.getHouseTextField()
  }
  
  func getApartmentTextField() -> UITextField? {
    return deliveryView?.getApartmentTextField()
  }
  
  // MARK: - Private
  private func getValidatorControllers() -> [UITextField: ValidateController] {
    guard let houseTextField = getHouseTextField(),
          let apartmentTextField = getApartmentTextField() else { return [:] }
    var controllers: [UITextField: ValidateController] = [:]
    let houseController = ValidateController(textField: houseTextField,
                                             type: .house)
    let apartmentController = ValidateController(textField: apartmentTextField,
                                                 type: .apartment)
    houseController.delegate = delegate
    apartmentController.delegate = delegate
    controllers[houseTextField] = houseController
    controllers[apartmentTextField] = apartmentController
    return controllers
  }
  
  @objc
  private func radioBoxTapped() {
    delegate?.didSelect(addressDeliveryController: self)
  }

  @objc
  private func cityTapped() {
    delegate?.didSelectCity(in: self)
  }

  @objc
  private func streetTapped() {
    delegate?.didSelectStreet(in: self)
  }
  
  @objc
  private func houseChanged() {
    addressDeliveryViewModel?.house = deliveryView?.getHouse()
    guard let addressDeliveryViewModel = addressDeliveryViewModel else { return }
    delegate?.didChangeModel(addressDeliveryViewModel, in: self)
  }
  
  @objc
  private func apartmentChanged() {
    addressDeliveryViewModel?.apartment = deliveryView?.getApartment()
    guard let addressDeliveryViewModel = addressDeliveryViewModel else { return }
    delegate?.didChangeModel(addressDeliveryViewModel, in: self)
  }
  
}

private enum UIConstants {
  static let textColor = UIColor.color(r: 63, g: 76, b: 75)
  static let placeholderTextColor = UIColor.black.withAlphaComponent(0.45)
}

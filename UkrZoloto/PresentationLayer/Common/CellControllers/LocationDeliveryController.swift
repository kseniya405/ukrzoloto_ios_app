//
//  LocationDeliveryController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit

protocol LocationDeliveryControllerDelegate: AnyObject {
  func didSelect(locationDeliveryController: LocationDeliveryController)
  func didSelectCity(in controller: LocationDeliveryController)
  func didSelectOffice(in controller: LocationDeliveryController)
}

class LocationDeliveryController: AUIDefaultViewController {

  // MARK: - Public variables
  weak var delegate: LocationDeliveryControllerDelegate?
	
	weak var scheduleDelegate: ShopDeliveryScheduleViewDelegate?
  
  var deliveryView: LocationDeliveryTypeView? {
    get { return view as? LocationDeliveryTypeView }
    set { view = newValue }
}
  
  var locationDeliveryViewModel: LocationDeliveryViewModel? {
    didSet { didSetViewModel() }
  }
  
  // MARK: - Actions
  private func didSetViewModel() {
    guard let locationViewModel = locationDeliveryViewModel else { return }
    let locationColor = locationViewModel.location != nil ? UIConstants.textColor : UIConstants.placeholderTextColor
    deliveryView?.setCityTextColor(locationColor)
    let sublocationColor = locationViewModel.sublocation != nil ? UIConstants.textColor : UIConstants.placeholderTextColor
    deliveryView?.setOfficeTextColor(sublocationColor)
    deliveryView?.setTitle(locationViewModel.title)
    deliveryView?.setSubtitle(locationViewModel.subtitle)
    let cityTitle = locationViewModel.location?.title ?? locationViewModel.locationPlaceholder
    deliveryView?.setCityTitle(cityTitle)
    let officeTitle = locationViewModel.sublocation?.title ?? locationViewModel.sublocationPlaceholder
    deliveryView?.setOfficeTitle(officeTitle)
    deliveryView?.isBottomViewHidden = !locationViewModel.isSelected
    deliveryView?.setRadioBoxState(locationViewModel.isSelected ? .active : .inactive)
		locationDeliveryViewModel?.shop == nil ? deliveryView?.removeScheduleView() : deliveryView?.addScheduleView()
		if let shop = locationDeliveryViewModel?.shop {
			deliveryView?.setShopSchedule(shop: shop, delegate: scheduleDelegate)
		}
		if locationViewModel.sublocation?.title == nil {
			deliveryView?.removeScheduleView()
		}
  }
  
  override func setupView() {
    super.setupView()
    deliveryView?.addRadioBoxTarget(self, action: #selector(radioBoxTapped))
    deliveryView?.addCityTarget(self, action: #selector(cityTapped))
    deliveryView?.addOfficeTarget(self, action: #selector(officeTapped))
    didSetViewModel()
  }
  
  override func unsetupView() {
    super.unsetupView()
    deliveryView?.removeRadioBoxTarget()
    deliveryView?.removeCityTarget()
    deliveryView?.removeOfficeTarget()
  }
  
  @objc
  private func radioBoxTapped() {
    delegate?.didSelect(locationDeliveryController: self)
  }
  
  @objc
  private func cityTapped() {
		deliveryView?.removeOfficeTarget()
    delegate?.didSelectCity(in: self)
  }
  
  @objc
  private func officeTapped() {
		deliveryView?.removeOfficeTarget()
    delegate?.didSelectOffice(in: self)
  }
}

private enum UIConstants {
  static let textColor = UIColor.color(r: 63, g: 76, b: 75)
  static let placeholderTextColor = UIColor.black.withAlphaComponent(0.45)
}

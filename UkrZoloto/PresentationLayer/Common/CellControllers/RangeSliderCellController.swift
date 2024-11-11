//
//  RangeSliderViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 13.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import AUIKit
import WARangeSlider

protocol RangeSliderCellControllerDelegate: AnyObject {
  func didChangeRangeValue(_ controller: RangeSliderCellController, sender: RangeSlider)
  func didTextFieldsEditing(_ controller: RangeSliderCellController, sender: UITextField)
}

class RangeSliderCellController: AUIDefaultViewController {
  
  // MARK: - Public variables
  weak var delegate: (RangeSliderCellControllerDelegate & UITextFieldDelegate)? {
    didSet {
      rangeView?.setDelegate(delegate)
    }
  }
  
  var rangeView: RangeSliderView? {
    get { return view as? RangeSliderView }
    set { view = newValue }
  }
  
  private(set) var filter: RangeFilter {
    didSet { didSetRangeFilter() }
  }
  
  // MARK: - Life cycle
  init(filter: RangeFilter) {
    self.filter = filter
    super.init()
  }
  
  // MARK: - Configuration
  override func setupView() {
    super.setupView()
    rangeView?.addTarget(self,
                         action: #selector(didChangeRangeValue))
    rangeView?.addTextFieldsTarget(self,
                                   action: #selector(textFieldEditing))
    rangeView?.setDelegate(delegate)
    didSetRangeFilter()
  }
  
  override func unsetupView() {
    super.unsetupView()
    rangeView?.removeTarget(nil, action: nil)
    rangeView?.removeTextFieldsTarget(nil, action: nil)
  }
  
  // MARK: - Private methods
  private func didSetRangeFilter() {
    rangeView?.configure(for: filter)
  }
  
  @objc
  private func didChangeRangeValue(_ sender: RangeSlider) {
    let lowValue = Int(sender.lowerValue)
    let upValue = Int(sender.upperValue)
    
    guard lowValue != filter.minPrice ||
      upValue != filter.maxPrice else {
        return
    }
    filter.minPrice = lowValue
    filter.maxPrice = upValue
    
    rangeView?.setLeftTextFieldText(StringComposer.shared.getRangePriceConfigureString(price: filter.minPrice))
    rangeView?.setRightTextFieldText(StringComposer.shared.getRangePriceConfigureString(price: filter.maxPrice))
    
    delegate?.didChangeRangeValue(self, sender: sender)
  }
  
  @objc
  private func textFieldEditing(_ sender: UITextField) {
    guard let rangeView = rangeView else { return }
    
    let minPrice = (Int(rangeView.getLeftTextFieldText()?
      .replacingOccurrences(of: " ", with: "") ?? String(filter.minPrice)) ?? filter.minPrice)
    let maxPrice = (Int(rangeView.getRightTextFieldText()?
      .replacingOccurrences(of: " ", with: "") ?? String(filter.maxPrice)) ?? filter.maxPrice)
    
    filter.minPrice = minPrice
    filter.maxPrice = maxPrice
    delegate?.didTextFieldsEditing(self, sender: sender)
  }
  
}

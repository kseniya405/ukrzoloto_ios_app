//
//  RangeSliderView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 07.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import WARangeSlider

class RangeSliderView: InitView {
  
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.lineHeight
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
    
    return label
  }()
  
  private let leftTextField: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIConstants.LeftTextField.borderColor.cgColor
    textField.layer.borderWidth = UIConstants.LeftTextField.borderWidth
    textField.layer.cornerRadius = UIConstants.LeftTextField.cornerRadius
    textField.textColor = UIConstants.LeftTextField.textColor
    textField.font = UIConstants.LeftTextField.font
    textField.textAlignment = .center
    textField.keyboardType = .numberPad
    textField.doneAccessory = true
    
    return textField
  }()
  
  private let rightTextField: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIConstants.LeftTextField.borderColor.cgColor
    textField.layer.borderWidth = UIConstants.LeftTextField.borderWidth
    textField.layer.cornerRadius = UIConstants.LeftTextField.cornerRadius
    textField.textColor = UIConstants.LeftTextField.textColor
    textField.font = UIConstants.LeftTextField.font
    textField.textAlignment = .center
    textField.keyboardType = .numberPad
    textField.doneAccessory = true
    
    return textField
  }()
  
  private let rangeSlider: RangeSlider = {
    let slider = RangeSlider()
    slider.trackTintColor = UIConstants.Slider.trackTintColor
    slider.trackHighlightTintColor = UIConstants.Slider.trackHighlightTintColor
    slider.curvaceousness = 1.0
    slider.thumbTintColor = UIConstants.Slider.thumbTintColor
    slider.thumbBorderColor = UIConstants.Slider.thumbBorderColor
    
    return slider
  }()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTitleLabel()
    configureLeftTextField()
    configureRightTextField()
    configureSlider()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
  }
  
  private func configureLeftTextField() {
    addSubview(leftTextField)
    leftTextField.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.LeftTextField.top)
      make.leading.equalToSuperview()
      make.height.equalTo(UIConstants.LeftTextField.height)
    }
  }
  
  private func configureRightTextField() {
    addSubview(rightTextField)
    rightTextField.snp.makeConstraints { make in
      make.top.height.width.equalTo(leftTextField)
      make.leading.equalTo(leftTextField.snp.trailing)
        .offset(UIConstants.RightTextField.leading)
      make.trailing.equalToSuperview()
    }
  }
  
  private func configureSlider() {
    addSubview(rangeSlider)
    rangeSlider.snp.makeConstraints { make in
      make.top.equalTo(leftTextField.snp.bottom)
        .offset(UIConstants.Slider.top)
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.Slider.height)
    }
  }
  
  // MARK: - Interface
  func configure(for filter: RangeFilter) {
    rangeSlider.maximumValue = Double(filter.max)
    rangeSlider.minimumValue = Double(filter.min)
    rangeSlider.upperValue = Double(filter.maxPrice)
    rangeSlider.lowerValue = Double(filter.minPrice)
    
    titleLabel.text = StringComposer.shared.getPriceTitle(for: filter.title)
    leftTextField.text = StringComposer.shared.getRangePriceConfigureString(price: filter.minPrice)
    rightTextField.text = StringComposer.shared.getRangePriceConfigureString(price: filter.maxPrice)
  }
  
  func setDelegate(_ delegate: UITextFieldDelegate?) {
    leftTextField.delegate = delegate
    rightTextField.delegate = delegate
  }

  func addTarget(_ target: Any, action: Selector) {
    rangeSlider.addTarget(target, action: action, for: .touchUpInside)
    rangeSlider.addTarget(target, action: action, for: .touchUpOutside)
  }
  
  func removeTarget(_ target: Any?, action: Selector?) {
    rangeSlider.removeTarget(target, action: action, for: .valueChanged)
  }
  
  func addTextFieldsTarget(_ target: Any, action: Selector) {
    leftTextField.addTarget(target, action: action, for: .editingChanged)
    rightTextField.addTarget(target, action: action, for: .editingChanged)
  }
  
  func removeTextFieldsTarget(_ target: Any?, action: Selector?) {
    leftTextField.removeTarget(target, action: action, for: .editingChanged)
    rightTextField.removeTarget(target, action: action, for: .editingChanged)
  }
  
  func getLeftTextFieldText() -> String? {
    return leftTextField.text
  }
  
  func setLeftTextFieldText(_ text: String) {
    leftTextField.text = text
  }
  
  func getRightTextFieldText() -> String? {
    return rightTextField.text
  }
  
  func setRightTextFieldText(_ text: String) {
    rightTextField.text = text
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum Title {
    static let font = UIFont.boldAppFont(of: 18)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let lineHeight: CGFloat = 21.6
  }
  
  enum LeftTextField {
    static let borderColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.2)
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 20
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    
    static let top: CGFloat = 24
    static let height: CGFloat = 40
  }
  
  enum RightTextField {
    static let leading: CGFloat = 17
  }
  
  enum Slider {
    static let trackTintColor = UIColor.color(r: 17, g: 54, b: 50)
    static let trackHighlightTintColor = UIColor.color(r: 255, g: 220, b: 136)
    static let thumbTintColor = UIColor.color(r: 0, g: 80, b: 47)
    static let thumbBorderColor = UIColor.clear
    
    static let top: CGFloat = 42
    static let height: CGFloat = 30
  }
  
}

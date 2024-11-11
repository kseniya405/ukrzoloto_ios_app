//
//  UserTypeView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 10/28/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import ActiveLabel

protocol UserTypeViewDelegate: AnyObject {
  func didTapOnActiveLabel(from view: UserTypeView)
}

class UserTypeView: RoundedContainerView {
  
  // MARK: - Public variables
  weak var delegate: UserTypeViewDelegate?
  
  // MARK: - Private variables
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.opacity = UIConstants.Image.opacity
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.color)
      .textAlignment(.center)
      .numberOfLines(0)
    label.lineHeight = UIConstants.Title.height
    
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.color)
      .textAlignment(.center)
      .numberOfLines(0)
    label.lineHeight = UIConstants.Subtitle.height
    
    return label
  }()
  
  private let textField = UnderlinedTextField()
  private let smsButton = MainButton()
  private let activeLabel: ActiveLabel = {
    let label = ActiveLabel()
    label.setLineHeight(UIConstants.ActiveLabel.lineHeight)
    label.config
      .font(UIConstants.ActiveLabel.font)
      .textColor(UIConstants.ActiveLabel.textColor)
      .numberOfLines(UIConstants.ActiveLabel.numberOfLines)
      .textAlignment(.center)
    
    return label
  }()
  
  // MARK: - Configure
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupImage()
    setupTitle()
    setupSubtitle()
    configureTextField()
    configureButton()
    configureActiveLabel()
  }
  
  private func setupView() {
    backgroundColor = .white
  }
  
  private func setupImage() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.Image.side).priority(.low)
      make.top.equalToSuperview()
        .offset(UIConstants.Image.top)
      make.centerX.equalToSuperview()
    }
  }
  
  private func setupTitle() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
        .offset(UIConstants.Title.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.Title.leading)
      make.centerX.equalToSuperview()
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupSubtitle() {
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Subtitle.top)
      make.leading.trailing.equalTo(titleLabel)
    }
    subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    subtitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  private func configureTextField() {
    addSubview(textField)
    textField.snp.makeConstraints { make in
      make.top.lessThanOrEqualTo(subtitleLabel.snp.bottom) // lessThanOrEqualTo
        .offset(UIConstants.TextField.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.TextField.insets)
      make.height.equalTo(UIConstants.TextField.height)
    }
    textField.setUnderlineColor(UIConstants.TextField.lineColor)
  }
  
  private func configureButton() {
    addSubview(smsButton)
    smsButton.snp.makeConstraints { make in
      make.top.equalTo(textField.snp.bottom)
        .offset(UIConstants.Button.top)
      make.height.equalTo(UIConstants.Button.height)
      make.leading.trailing.equalTo(textField)
    }
  }
  
  private func configureActiveLabel() {
    addSubview(activeLabel)
    activeLabel.snp.makeConstraints { make in
      make.top.equalTo(smsButton.snp.bottom)
        .offset(UIConstants.ActiveLabel.top)
      make.leading.trailing.equalTo(smsButton)
      make.bottom.lessThanOrEqualToSuperview()
        .inset(UIConstants.ActiveLabel.bottom)
    }
  }
  
  // MARK: - Public
  func setImage(_ image: UIImage) {
    imageView.image = image
  }
  
  func setTitle(_ text: String) {
    titleLabel.text = text
  }
  
  func setSubtitle(_ text: String) {
    subtitleLabel.text = text
  }
  
  func getTextField() -> UITextField {
    return textField
  }
  
  func setPlaceholder(_ title: String) {
    textField.placeholder = title
  }
  
  func setButtonTitle(_ title: String) {
    smsButton.setTitle(title, for: .normal)
  }
  
  func setButtonState(isActive: Bool) {
    smsButton.isEnabled = isActive
  }
  
  func addTarget(_ target: Any, action: Selector) {
    smsButton.addTarget(target, action: action, for: .touchUpInside)
  }
  
  func removeTarget(_ target: Any?, action: Selector?) {
    smsButton.removeTarget(target, action: action, for: .touchUpInside)
  }
  
  func updateBottomConstraint(offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: 5) { [weak self] in
      guard let self = self else { return }
      self.textField.snp.remakeConstraints { make in
        if offset > 0 {
          make.top.equalToSuperview()
            .offset(UIConstants.TextField.scrolledTop + offset / 10)
        } else {
          make.top.lessThanOrEqualTo(self.subtitleLabel.snp.bottom)
            .offset(UIConstants.TextField.top)
        }
        make.leading.trailing.equalToSuperview()
          .inset(UIConstants.TextField.insets)
        make.height.equalTo(UIConstants.TextField.height)
      }
      
      self.updateHiddenLabels(isHidden: offset > 0)
      self.layoutIfNeeded()
    }
  }
  
  private func updateHiddenLabels(isHidden: Bool) {
    self.imageView.isHidden = isHidden
    self.titleLabel.isHidden = isHidden
    self.subtitleLabel.isHidden = isHidden
  }
  
  func setActiveLabel(_ text: String, clickedText: String? = nil) {
    activeLabel.text = text
    activeLabel.setLineHeight(UIConstants.ActiveLabel.lineHeight)
    
    guard let clickedText = clickedText else { return }
    activeLabel.customize { label in
      let dataClickedType = ActiveType.custom(pattern: clickedText)
      label.customColor[dataClickedType] = UIConstants.ActiveLabel.selectedTextColor
      label.customSelectedColor[dataClickedType] = UIConstants.ActiveLabel.textColor
      label.handleCustomTap(for: dataClickedType, handler: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.didTapOnActiveLabel(from: self)
      })
      label.enabledTypes = [dataClickedType]
    }
  }
  
}

private enum UIConstants {
  enum Image {
    static let opacity: Float = 0.8
    
    static let top: CGFloat = Constants.Screen.heightCoefficient > 1 ? 100 : 5
    static let side: CGFloat = 101
  }
  
  enum Title {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 22)
    static let height: CGFloat = 26.4
    
    static let top: CGFloat = Constants.Screen.heightCoefficient > 1 ? 8 : 2
    static let scrolledTop: CGFloat = Constants.Screen.heightCoefficient > 1 ? 80 : 15
    static let leading: CGFloat = 40
  }
  
  enum Subtitle {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    static let height: CGFloat = 19.5
    
    static let top: CGFloat = Constants.Screen.heightCoefficient > 1 ? 14 : 5
    static let bottom: CGFloat = 10
  }
  
  enum TextField {
    static let lineColor = UIColor.color(r: 62, g: 76, b: 75)
    
    static let height: CGFloat = 53
    static let top: CGFloat = 80
    static let scrolledTop: CGFloat = Constants.Screen.heightCoefficient > 1 ? 20 : 0
    static let insets: CGFloat = 24
  }
  
  enum Button {
    static let height: CGFloat = 52
    static let top: CGFloat = Constants.Screen.heightCoefficient > 1 ? 50 : 20
  }
  
  enum ActiveLabel {
    static let selectedTextColor = UIColor.color(r: 0, g: 80, b: 47)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let lineHeight: CGFloat = 18
    static let font = UIFont.regularAppFont(of: 13)
    static let numberOfLines: Int = 0
    
    static let top: CGFloat = 15
    static let bottom: CGFloat = 20
  }
  
}

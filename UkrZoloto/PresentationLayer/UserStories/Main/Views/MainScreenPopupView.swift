//
//  MainScreenPopupView.swift
//  UkrZoloto
//
//  Created by user on 20.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

class MainScreenPopupView: InitView {
  enum PopupType {
    case unregistered
    case registered
  }
  
  // MARK: - Public variables
  let titleLabel =
    LabelFactory.shared.createLabel(
      color: UIConstants.Title.color,
      font: UIConstants.Title.font,
      height: UIConstants.Title.height,
      numbersOfLines: UIConstants.Title.numberOfLines)
  let actionButton = MainButton()
  let secondActionButton = GreyButton()
  
  // MARK: - Private variables
  private var popupType: PopupType
  
  // MARK: - Init
  init(type: PopupType) {
    self.popupType = type
    super.init()
  }
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    configureTitleLabel()
    configureActionButton()
    if popupType == .unregistered {
      configureSecondActionButton()
    }
  }
  
  private func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
    layer.shadowOffset = UIConstants.SelfView.shadowOffset
    layer.shadowColor = UIConstants.SelfView.shadowColor.cgColor
    layer.shadowRadius = UIConstants.SelfView.shadowRadius
    layer.shadowOpacity = 1
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Title.sides)
    }
    titleLabel.textAlignment = .center  }
  
  private func configureActionButton() {
    addSubview(actionButton)
    actionButton.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.ActionButton.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.ActionButton.sides)
      make.height.equalTo(UIConstants.ActionButton.height)
      if popupType == .registered {
        make.bottom.equalToSuperview()
          .inset(UIConstants.ActionButton.bottom)
      }
    }
    actionButton.titleLabel?.adjustsFontSizeToFitWidth = true
    actionButton.titleLabel?.minimumScaleFactor = 0.5
  }
  
  private func configureSecondActionButton() {
    addSubview(secondActionButton)
    secondActionButton.snp.remakeConstraints { make in
      make.top.equalTo(actionButton.snp.bottom)
        .offset(UIConstants.SecondActionButton.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.SecondActionButton.sides)
      make.height.equalTo(UIConstants.SecondActionButton.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.SecondActionButton.bottom)
    }
  }
  
  // MARK: - Interface
  func changeType(to newType: PopupType) {
    self.popupType = newType
    configureActionButton()
    switch newType {
    case .unregistered:
      configureActionButton()
      configureSecondActionButton()
    case .registered:
      configureActionButton()
      secondActionButton.removeFromSuperview()
    }
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 255, g: 220, b: 136)
    static let cornerRadius: CGFloat = 31
    static let shadowOffset = CGSize(width: 0, height: 12)
    static let shadowColor = UIColor.color(r: 157, g: 164, b: 183, a: 0.24)
    static let shadowRadius: CGFloat = 20
  }
  
  enum Title {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    static let height: CGFloat = 21
    static let numberOfLines = 0
    
    static let top: CGFloat = 23
    static let sides: CGFloat = 30
  }
  
  enum ActionButton {
    static let top: CGFloat = 27
    static let sides: CGFloat = 16
    static let height: CGFloat = 52
    static let bottom: CGFloat = 16
  }
  
  enum SecondActionButton {
    static let top: CGFloat = 8
    static let sides: CGFloat = 16
    static let height: CGFloat = 52
    static let bottom: CGFloat = 16
  }
}

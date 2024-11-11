//
//  ProfileFormSavedView.swift
//  UkrZoloto
//
//  Created by Mykola on 07.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class ProfileFormSaveView: InitView {
  
  var onCloseTap: (()->())?
  var onOkTap: (()->())?
  
  private let closeButton: UIButton = {
    
    let button = UIButton()
    button.setImage(UIConstants.closeIcon, for: .normal)
    button.tintColor = UIConstants.closeButtonTintColor
    
    return button
  }()
  
  private let proceedButton: UIButton = {
    
    let button = UIButton()
    button.backgroundColor = UIConstants.closeButtonTintColor
    button.layer.cornerRadius = UIConstants.proceedButtonCornerRadius
    button.clipsToBounds = true
    
    return button
  }()
  
  private let illustrationImageView: UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    
    return imageView
  }()
  
  private let label: UILabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.labelFont)
			.textColor(UIConstants.closeButtonTintColor ?? .green)
      .numberOfLines(0)
      .textAlignment(.center)
      
    label.lineHeight = UIConstants.labelLineHeight
    
    return label
  }()
  
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  //MARK: - Public methods
  
  func localize() {
    
    let labelText = Localizator.standard.localizedString("Отлично! Данные сохранены")
    let illustrationTitle = Localizator.standard.localizedString("ProfileFromSuccessResult")
    let buttonTitle = Localizator.standard.localizedString("Перейти к покупкам").uppercased()
    
    label.text = labelText
    illustrationImageView.image = UIImage(named: illustrationTitle)
    
    let buttonAttributedTitle = NSAttributedString(string: buttonTitle, attributes: [.font: UIConstants.proceedButtonFont as Any,
                                                                                     .foregroundColor: UIConstants.proceedButtonTitleColor])
    proceedButton.setAttributedTitle(buttonAttributedTitle,
                                     for: .normal)
  }
}

//MARK: - Private methods

fileprivate extension ProfileFormSaveView {
  
  func configureSelf() {
    configureCloseButton()
    configureIllustration()
    configureLabel()
    configureProceedButton()
    
    localize()
  }
  
  func configureCloseButton() {
    addSubview(closeButton)
    closeButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.closeButtonLeading)
      make.top.equalToSuperview().offset(UIConstants.closeButtonTop)
      make.height.width.equalTo(UIConstants.closeButtonWidth)
    }
    
    closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
  }
  
  func configureIllustration() {
    addSubview(illustrationImageView)
    illustrationImageView.snp.makeConstraints { make in
      
      make.centerX.equalToSuperview()
      make.width.height.equalTo(UIConstants.illustrationWidth)
      make.bottom.equalTo(self.snp.centerY).offset(UIConstants.illustrationBottomOffset)
    }
  }
  
  func configureLabel() {
    addSubview(label)
    label.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.snp.centerY)
      make.width.equalTo(UIConstants.labelWidth)
    }
  }
  
  func configureProceedButton() {
    let containerView = UIView()
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(label.snp.bottom)
      make.bottom.equalToSuperview()
    }
    
    containerView.addSubview(proceedButton)
    proceedButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.proceedButtonLeadingTrailing)
      make.trailing.equalToSuperview().offset(-UIConstants.proceedButtonLeadingTrailing)
      make.centerY.equalToSuperview()
      make.height.equalTo(UIConstants.proceedButtonHeight)
    }
    
    proceedButton.addTarget(self, action: #selector(onProceedButtonTap(_:)), for: .touchUpInside)
  }
  
  @objc func onCloseButtonTap(_ sender: UIButton) {
    onCloseTap?()
  }
  
  @objc func onProceedButtonTap(_ sender: UIButton) {
    onOkTap?()
  }
}

fileprivate enum UIConstants {
  
  static let closeIcon = UIImage(named: "controlsClose")?.withRenderingMode(.alwaysTemplate)
  static let closeButtonTintColor = UIColor(named: "green")
  static let closeButtonLeading: CGFloat = 16.0
  static let closeButtonTop: CGFloat = 52.0
  static let closeButtonWidth: CGFloat = 28.0
  
  static let illustration = UIImage(named: "saved_illustration_rus")
  //needs ukrainian copy
  static let illustrationWidth: CGFloat = 128.0
  static let illustrationBottomOffset: CGFloat = -35.0
  
  static let labelFont = UIFont.boldAppFont(of: 18.0)
  static let labelLineHeight: CGFloat = 21.6
  static let labelWidth: CGFloat = 271.0
  
  static let proceedButtonFont = UIFont.boldAppFont(of: 14.0)
  static let proceedButtonTitleColor = UIColor.white
  static let proceedButtonCornerRadius: CGFloat = 22.0
  static let proceedButtonHeight: CGFloat = 52.0
  static let proceedButtonLeadingTrailing: CGFloat = 24.0
}

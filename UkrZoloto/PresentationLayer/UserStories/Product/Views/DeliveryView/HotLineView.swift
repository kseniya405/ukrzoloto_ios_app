//
//  HotLineView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 31.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class HotLineView: InitView {
  
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.TitleLabel.height
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.textColor)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
    
    return label
  }()
  
  private let phoneLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.PhoneLabel.height
    label.config
      .font(UIConstants.PhoneLabel.font)
      .textColor(UIConstants.PhoneLabel.textColor)
    
    return label
  }()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTitleLabel()
    configurePhoneLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.TitleLabel.inset)
    }
  }
  
  private func configurePhoneLabel() {
    addSubview(phoneLabel)
    phoneLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.PhoneLabel.top)
      make.leading.trailing.equalTo(titleLabel)
      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func setContent(_ content: HotLine) {
    titleLabel.text = content.title
    phoneLabel.text = content.number
  }
  
  func addHotLineTarget(_ target: Any?, action: Selector) {
    let gesture = UITapGestureRecognizer(target: target, action: action)
    phoneLabel.addGestureRecognizer(gesture)
    phoneLabel.isUserInteractionEnabled = true
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum TitleLabel {
    static let textColor = UIColor.black.withAlphaComponent(0.7)
    static let font = UIFont.regularAppFont(of: 14)
    static let height: CGFloat = 18.2
    static let numberOfLines: Int = 0
    
    static let inset: CGFloat = 24
  }
  
  enum PhoneLabel {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.extraBoldAppFont(of: 32)
    static let height: CGFloat = 41
    
    static let top: CGFloat = 8
  }
}

//
//  OptionView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 12.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class OptionView: InitView {
  
  // MARK: - Private variables
  private let okeyImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIConstants.OkeyImageView.image
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.lineHeight
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
    
    return label
  }()
  
  private let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIConstants.LineView.backgroundColor
    
    return view
  }()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureOkeyImageView()
    configureTitleLabel()
    configureLineView()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureOkeyImageView() {
    addSubview(okeyImageView)
    okeyImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.width.height.equalTo(UIConstants.OkeyImageView.side)
    }
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.equalTo(okeyImageView.snp.trailing)
        .offset(UIConstants.Title.leading)
      make.trailing.equalToSuperview()
      make.centerY.equalTo(okeyImageView)
    }
  }
  
  private func configureLineView() {
    addSubview(lineView)
    lineView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.LineView.top)
      make.leading.trailing.equalTo(titleLabel)
      make.height.equalTo(UIConstants.LineView.height)
      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func configure(title: String, isSelected: Bool, isActive: Bool) {
    titleLabel.text = title
    okeyImageView.isHidden = !isSelected
    titleLabel.textColor = isActive ? UIConstants.Title.textColor : UIConstants.Title.disabledTextColor
  }
  
  func addTarget(_ target: Any?, action: Selector) {
    let gesture = UITapGestureRecognizer(target: target,
                                         action: action)
    addGestureRecognizer(gesture)
  }
  
  func removeTarget(_ target: Any?, action: Selector?) {
    let gesture = UITapGestureRecognizer(target: target, action: action)
    removeGestureRecognizer(gesture)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum OkeyImageView {
    static let image = #imageLiteral(resourceName: "greenAcceptedIcon")
    static let side: CGFloat = 28
  }
  
  enum Title {
    static let font = UIFont.regularAppFont(of: 16)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let lineHeight: CGFloat = 21.6
    static let disabledTextColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.25)
    
    static let top: CGFloat = 16
    static let leading: CGFloat = 14
  }
  
  enum LineView {
    static let backgroundColor = UIColor.color(r: 216, g: 219, b: 219)
    
    static let height: CGFloat = 1
    static let top: CGFloat = 12
  }
  
}

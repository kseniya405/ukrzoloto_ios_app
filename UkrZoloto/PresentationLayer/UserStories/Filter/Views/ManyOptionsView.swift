//
//  ManyOptionsFilterCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 12.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ManyOptionsView: InitView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Line.lineHeight
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
    
    return label
  }()
  
  private let rightLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.RightTitle.lineHeight
    label.config
      .font(UIConstants.RightTitle.font)
      .textColor(UIConstants.RightTitle.textColor)
    
    return label
  }()
  
  private let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIConstants.Line.backgroundColor
    
    return view
  }()
  
  private let arrowImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIConstants.ArrowImageView.image
    
    return imageView
  }()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTitleLabel()
    configureArrowImageView()
    configureLineView()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.equalToSuperview()
    }
  }
  
  private func configureArrowImageView() {
    addSubview(arrowImageView)
    arrowImageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.ArrowImageView.side)
      make.trailing.equalToSuperview()
      make.leading.equalTo(titleLabel.snp.trailing)
        .offset(UIConstants.ArrowImageView.leading)
      make.centerY.equalTo(titleLabel)
    }
  }
  
  private func configureLineView() {
    addSubview(lineView)
    lineView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Line.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(UIConstants.Line.lineHeight)
      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func setTitles(title: String, value: String?) {
    value.isNilOrEmpty ? updateWithoutValue() : updateWithValue()
    titleLabel.text = title
    rightLabel.text = value
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
  
  // MARK: - Private methods
  private func updateWithValue() {
    addSubview(rightLabel)
    rightLabel.snp.makeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.leading.equalTo(titleLabel.snp.trailing)
        .offset(UIConstants.RightTitle.leading)
    }
    rightLabel.setContentHuggingPriority(.required, for: .horizontal)
    rightLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    arrowImageView.snp.remakeConstraints { make in
      make.height.width.equalTo(UIConstants.ArrowImageView.side)
      make.trailing.equalToSuperview()
      make.leading.equalTo(rightLabel.snp.trailing)
        .offset(UIConstants.ArrowImageView.leading)
      make.centerY.equalTo(titleLabel)
    }
  }
  
  private func updateWithoutValue() {
    rightLabel.removeFromSuperview()
    
    arrowImageView.snp.remakeConstraints { make in
      make.height.width.equalTo(UIConstants.ArrowImageView.side)
      make.trailing.equalToSuperview()
      make.leading.equalTo(titleLabel.snp.trailing)
        .offset(UIConstants.ArrowImageView.leading)
      make.centerY.equalTo(titleLabel)
    }
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum Title {
    static let font = UIFont.regularAppFont(of: 16)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let lineHeight: CGFloat = 25
    
    static let top: CGFloat = 16
  }
  
  enum RightTitle {
    static let font = UIFont.regularAppFont(of: 12)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.4)
    static let lineHeight: CGFloat = 16
    
    static let leading: CGFloat = 10
  }
  
  enum Line {
    static let backgroundColor = UIColor.color(r: 216, g: 219, b: 219)
    
    static let lineHeight: CGFloat = 1
    static let top: CGFloat = 12
  }
  
  enum ArrowImageView {
    static let image = #imageLiteral(resourceName: "controlsArrow")
    static let side: CGFloat = 24
    static let leading: CGFloat = 3
  }
}

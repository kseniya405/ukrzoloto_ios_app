//
//  DeliveryTypeView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

class DeliveryTypeView: UIView {
  
  // MARK: - Public variables
  var isBottomViewHidden = false {
    didSet {
      setNeedsUpdateConstraints()
    }
  }

  // MARK: - Private variables
  private let radioBox = RadioBox()
  private let titleLabel = LineHeightLabel()
  private let subtitleLabel = LineHeightLabel()
  private let bottomContainerView = UIView()
  
  private var subtitleLabelToBottomConstraint: Constraint?
  private var bottomContainerViewToBottomConstraint: Constraint?
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if isBottomViewHidden {
      bottomContainerViewToBottomConstraint?.deactivate()
      subtitleLabelToBottomConstraint?.activate()
    } else {
      bottomContainerViewToBottomConstraint?.activate()
      subtitleLabelToBottomConstraint?.deactivate()
    }
    bottomContainerView.isHidden = isBottomViewHidden
    super.updateConstraints()
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureRadioBox()
    configureTitleLabel()
    configureSubtitleLabel()
    configureBottomContainerView()
    setContentHuggingPriority(.required, for: .vertical)
    setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureRadioBox() {
    addSubview(radioBox)
    radioBox.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
      make.height.width.equalTo(UIConstants.RadioBox.side)
    }
  }
  
  private func configureTitleLabel() {
    titleLabel.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
      .textColor(UIConstants.TitleLabel.textColor)
      .textAlignment(UIConstants.TitleLabel.textAlignment)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(radioBox.snp.trailing)
        .offset(UIConstants.TitleLabel.left)
      make.centerY.equalTo(radioBox)
      make.trailing.equalToSuperview()
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
  }
  
  private func configureSubtitleLabel() {
    subtitleLabel.config
      .font(UIConstants.SubtitleLabel.font)
      .numberOfLines(UIConstants.SubtitleLabel.numberOfLines)
      .textColor(UIConstants.SubtitleLabel.textColor)
      .textAlignment(UIConstants.SubtitleLabel.textAlignment)
    subtitleLabel.lineHeight = UIConstants.SubtitleLabel.lineHeight
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(titleLabel)
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.SubtitleLabel.top)
      subtitleLabelToBottomConstraint = make.bottom.equalToSuperview().constraint
    }
    subtitleLabelToBottomConstraint?.deactivate()
    subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    subtitleLabel.setContentHuggingPriority(.required, for: .vertical)
  }
  
  private func configureBottomContainerView() {
    bottomContainerView.backgroundColor = UIConstants.BottomContainerView.backgroundColor
    addSubview(bottomContainerView)
    bottomContainerView.snp.makeConstraints { make in
      make.leading.trailing.equalTo(titleLabel)
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(UIConstants.BottomContainerView.top)
      bottomContainerViewToBottomConstraint = make.bottom.equalToSuperview().constraint
      make.height.equalTo(UIConstants.BottomContainerView.height).priority(1)
    }
  }
  
  // MARK: - Interface
  func setRadioBoxState(_ state: RadioState) {
    radioBox.buttonState = state
  }
  
  func setTitle(_ title: String?) {
    titleLabel.text = title
  }
  
  func setSubtitle(_ title: String?) {
    subtitleLabel.text = title
  }
  
  func addBottomView(_ view: UIView) {
    bottomContainerView.subviews.forEach { $0.removeFromSuperview() }
    bottomContainerView.addSubview(view)
    view.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  func addRadioBoxTarget(_ target: Any?,
                         action: Selector) {
    radioBox.addTarget(target, action: action, for: .touchUpInside)
    
    self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
  }
  
  func removeRadioBoxTarget() {
    radioBox.removeTarget(nil, action: nil, for: .touchUpInside)
  }
  
  func showSubtitleLabel() {
    subtitleLabel.isHidden = false
  }
  
  func hideSubtitleLabel() {
    subtitleLabel.isHidden = true
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum RadioBox {
    static let side = 24
  }
  
  enum TitleLabel {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.semiBoldAppFont(of: 15)
    static let textAlignment = NSTextAlignment.left
    static let numberOfLines = 1
    
    static let left: CGFloat = 10
  }
  
  enum SubtitleLabel {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.7)
    static let font = UIFont.regularAppFont(of: 13)
    static let lineHeight: CGFloat = 16.9
    static let textAlignment = NSTextAlignment.left
    static let numberOfLines = 0
    
    static let top: CGFloat = 5
  }
  
  enum BottomContainerView {
    static let backgroundColor = UIColor.clear
    
    static let top: CGFloat = 24
    static let height: CGFloat = 0
  }
}

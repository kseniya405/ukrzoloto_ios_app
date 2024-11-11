//
//  BlurPopupView.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 08.04.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit
import SnapKit

class BlurPopupView: BlurTransitionView {
  
  // MARK: - Public variables
  var contentView: BaseContentView
  
  // MARK: - Private variables
  private var centerYConstraint: Constraint?
  private var topToBottomConstraint: Constraint?
  
  // MARK: - Life cycle
  init(contentView: BaseContentView) {
    self.contentView = contentView
    super.init(frame: CGRect.zero)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  override func initConfigure() {
    super.initConfigure()
    setupLayout()
  }
  
  private func setupLayout() {
    backgroundColor = .clear
    
    addSubview(contentView)
    configureContentView()
  }
  
  private func configureContentView() {
    contentView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.left)
      topToBottomConstraint = make.top.equalTo(blurView.snp.bottom).priority(999).constraint
      centerYConstraint = make.centerY.equalTo(blurView).constraint
    }
    centerYConstraint?.deactivate()
  }
  
  override func applyPresentAnimationChanges() {
    blurView.backgroundColor = UIConstants.blurColor
  }
  
  // MARK: - Public
  
  func showContentView() {
    topToBottomConstraint?.deactivate()
    centerYConstraint?.activate()
  }
  
  func hideContentView() {
    centerYConstraint?.deactivate()
    topToBottomConstraint?.activate()
  }
}

private enum UIConstants {
  static let blurColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.8)
  static let left: CFloat = 16
}

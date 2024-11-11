//
//  RadioBox.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class RadioBox: UIButton {
  
  // MARK: - Public variables
  var buttonState: RadioState = .inactive {
    didSet {
      update()
    }
  }
  
  // MARK: - Private variables
  private var innerView = UIView()
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.width / 2
    innerView.layer.cornerRadius = bounds.width / 4
  }
  
  // MARK: - Configure
  private func setupView() {
    configureInnerView()
    update()
  }
  
  private func configureInnerView() {
    innerView.backgroundColor = .white
    addSubview(innerView)
    innerView.snp.makeConstraints { make in
      make.width.height.equalToSuperview().multipliedBy(0.5)
      make.center.equalToSuperview()
    }
  }
  
  // MARK: - Private methods
  private func update() {
    switch buttonState {
    case .active:
      backgroundColor = UIConstants.FilledButton.backgroundColor
      innerView.isHidden = false
    case .inactive,
         .inactiveGreen:
      backgroundColor = UIConstants.UnfilledButton.backgroundColor
      innerView.isHidden = true
    }
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  
  struct FilledButton {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  
  struct UnfilledButton {
    static let backgroundColor = UIColor.color(r: 231, g: 231, b: 231)
  }
  
}

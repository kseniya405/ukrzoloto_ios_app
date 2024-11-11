//
//  FilterSelectValueView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 08.08.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum SelectionType {
  case selected
  case inactive
  case normal
}

class FilterSelectValueView: InitView {
  
  // MARK: - Private variables
  private let innerView = UIView()
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.height
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
    return label
  }()
  
  private var selectionType = SelectionType.normal {
    didSet {
      switch selectionType {
      case .normal:
        innerView.backgroundColor = UIConstants.View.backgroundColor
        innerView.layer.borderColor = UIConstants.View.borderColor.cgColor
      case .selected:
        innerView.backgroundColor = UIConstants.View.selectedBackColor
        innerView.layer.borderColor = UIColor.clear.cgColor
      case .inactive:
        innerView.backgroundColor = UIConstants.View.inactiveBackColor
        innerView.layer.borderColor = UIColor.clear.cgColor
      }
    }
  }
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    configureInnerView()
    configureTitleLabel()
  }
  
  private func configureSelf() {
    backgroundColor = UIColor.clear
  }
  
  private func configureInnerView() {
    addSubview(innerView)
    innerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(UIConstants.View.height)
    }
    innerView.layer.cornerRadius = UIConstants.View.radius
    innerView.layer.borderColor = UIConstants.View.borderColor.cgColor
    innerView.layer.borderWidth = UIConstants.View.borderWidth
  }
  
  private func configureTitleLabel() {
    innerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
        .offset(UIConstants.Title.leading)
      make.centerX.equalToSuperview()
    }
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  // MARK: - Interface
  func configure(for variant: FilterVariant) {
    titleLabel.text = variant.value
    setSelectionType(for: variant)
    switch selectionType {
    case .normal:
      titleLabel.config
        .textColor(UIConstants.Title.textColor)
        .font(UIConstants.Title.font)
      isUserInteractionEnabled = true
    case .selected:
      titleLabel.config
        .textColor(UIConstants.Title.selectedTextColor)
        .font(UIConstants.Title.selectedFont)
      isUserInteractionEnabled = true
    case .inactive:
      titleLabel.config
        .textColor(UIConstants.Title.inactiveTextColor)
        .font(UIConstants.Title.font)
      isUserInteractionEnabled = false
    }
  }
  
  // MARK: - Private methods
  private func setSelectionType(for variant: FilterVariant) {
    guard variant.active else {
      selectionType = .inactive
      return
    }
    selectionType = variant.status ? .selected : .normal
  }
  
}

private enum UIConstants {
  enum View {
    static let radius: CGFloat = 20
    static let borderColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.2)
    static let borderWidth: CGFloat = 1
    static let height: CGFloat = 40
    
    static let selectedBackColor = UIColor.color(r: 255, g: 220, b: 136)
    static let backgroundColor = UIColor.clear
    static let inactiveBackColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.1)
  }
  
  enum Title {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let selectedTextColor = UIColor.color(r: 36, g: 43, b: 42)
    static let inactiveTextColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.3)
    static let font = UIFont.regularAppFont(of: 15)
    static let selectedFont = UIFont.semiBoldAppFont(of: 15)
    
    static let height: CGFloat = 19
    static let leading: CGFloat = 24
  }
}

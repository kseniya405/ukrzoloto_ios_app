//
//  SizeCollectionViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 26.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class SizeCollectionViewCell: UICollectionViewCell, Reusable {
  
  // MARK: - Public variables
  override var isSelected: Bool {
    didSet {
      innerView.backgroundColor = isSelected ? UIConstants.View.selectedBackColor : UIConstants.View.backgroundColor
    }
  }
  
  static let reuseID = String(describing: SizeCollectionViewCell.self)
  
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
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfiguration()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfiguration()
  }
  
  // MARK: - Configuration
  private func initConfiguration() {
    configureSelf()
    configureInnerView()
    configureTitleLabel()
  }
  
  private func configureSelf() {
    
  }
  
  private func configureInnerView() {
    contentView.addSubview(innerView)
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
      make.leading.greaterThanOrEqualToSuperview()
        .offset(UIConstants.Title.leading)
      make.centerX.equalToSuperview()
    }
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
		titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  // MARK: - Interface
  func configure(title: String, isSelected: Bool) {
    self.isSelected = isSelected
    innerView.backgroundColor = isSelected ? UIConstants.View.selectedBackColor : UIConstants.View.backgroundColor
    titleLabel.text = title
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum View {
    static let radius: CGFloat = 18
    static let borderColor = UIColor.color(r: 232, g: 237, b: 237)
    static let borderWidth: CGFloat = 1
    static let selectedBackColor = UIColor.color(r: 255, g: 220, b: 136)
    static let backgroundColor = UIColor.white
    
    static let height: CGFloat = 36
  }
  
  enum Title {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 17)
    
    static let height: CGFloat = 19
    static let leading: CGFloat = 24
  }
}

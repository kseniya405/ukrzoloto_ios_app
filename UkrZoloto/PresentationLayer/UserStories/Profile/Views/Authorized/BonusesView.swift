//
//  BonusesView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 12/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class BonusesView: InitView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let discountLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.DiscountLabel.font)
      .textAlignment(UIConstants.DiscountLabel.textAlignment)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .vertical)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = UIConstants.DiscountLabel.minimumScaleFactor
    return label
  }()
  
  private let bonusesLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.BonusesLabel.font)
      .textColor(UIConstants.BonusesLabel.textColor)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = UIConstants.BonusesLabel.minimumScaleFactor
    return label
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.TitleLabel.font)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    return label
  }()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureBonusesLabel()
    configureDiscountLabel()
    configureTitleLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureBonusesLabel() {
    addSubview(bonusesLabel)
    bonusesLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }
  }
  
  private func configureDiscountLabel() {
    addSubview(discountLabel)
    discountLabel.snp.makeConstraints { make in
      make.top.equalTo(bonusesLabel.snp.bottom)
      make.leading.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.DiscountLabel.height)
    }
  }

  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(discountLabel.snp.trailing)
        .offset(UIConstants.TitleLabel.leading)
      make.trailing.lessThanOrEqualToSuperview()
      make.bottom.equalTo(discountLabel)
    }
  }
  
  // MARK: - Interface
  func configure(_ viewModel: BonusesViewModel) {
    discountLabel.text = viewModel.bonuses
    discountLabel.textColor = viewModel.color
    titleLabel.text = viewModel.title
    titleLabel.textColor = viewModel.color
    bonusesLabel.text = viewModel.bonusesTitle
    layoutIfNeeded()
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum DiscountLabel {
		static let font = UIFont.aliceRegularFont(of: 42)
    static let textAlignment = NSTextAlignment.left
    static let minimumScaleFactor: CGFloat = 0.1
    
    static let height: CGFloat = 43
  }
  
  enum BonusesLabel {
    static let font = Constants.Screen.widthCoefficient < 1 ? UIFont.aliceRegularFont(of: 13) : UIFont.aliceRegularFont(of: 16)
    static let textColor = UIColor.white.withAlphaComponent(0.9)
    static let textAlignment = NSTextAlignment.left
    static let minimumScaleFactor: CGFloat = 0.5
  }
  
  enum TitleLabel {
    static let font = UIFont.aliceRegularFont(of: 18)
    static let textAlignment = NSTextAlignment.left
    static let leading: CGFloat = 4
  }
}


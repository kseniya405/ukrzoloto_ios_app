//
//  DiscountView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 11/1/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class DiscountPercentView: InitView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let discountLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.DiscountLabel.font)
      .textAlignment(UIConstants.DiscountLabel.textAlignment)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .horizontal)
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
  
  private let percentImageView: UIImageView = {
    let imageView = UIImageView(image: UIConstants.PercentImageView.image)
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = UIConstants.PercentImageView.backgroundColor
    return imageView
  }()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureDiscountLabel()
    configurePercentImageView()
    configureTitleLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureDiscountLabel() {
    addSubview(discountLabel)
    discountLabel.snp.makeConstraints { make in
      make.leading.bottom.equalToSuperview()
    }
  }
  
  private func configurePercentImageView() {
    insertSubview(percentImageView, at: 0)
    percentImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.equalTo(discountLabel.snp.right)
      make.width.height.equalTo(UIConstants.PercentImageView.side)
    }
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(percentImageView.snp.bottom)
      make.leading.equalTo(discountLabel.snp.trailing)
        .offset(UIConstants.TitleLabel.left)
      make.trailing.equalToSuperview()
      make.firstBaseline.equalTo(discountLabel)
        .inset(UIConstants.TitleLabel.bottom)
    }
  }
  
  // MARK: - Interface
  func configure(_ viewModel: DiscountViewModel) {
    discountLabel.text = viewModel.discount
    discountLabel.textColor = viewModel.color
    titleLabel.text = viewModel.title
    titleLabel.textColor = viewModel.color
    layoutIfNeeded()
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum DiscountLabel {
		static let font = UIFont.aliceRegularFont(of: 80)
    static let textAlignment = NSTextAlignment.left
  }
  
  enum TitleLabel {
    static let font = UIFont.aliceRegularFont(of: 18)
    static let textAlignment = NSTextAlignment.left
    
    static let left: CGFloat = 6
    static let bottom: CGFloat = -10
  }
  
  enum PercentImageView {
    static let image = #imageLiteral(resourceName: "percent")
    static let backgroundColor = UIColor.clear
    
    static let side: CGFloat = 46
  }
}

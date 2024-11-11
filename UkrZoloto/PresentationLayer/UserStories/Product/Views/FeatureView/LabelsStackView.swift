//
//  LabelsStackView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/30/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class LabelsStackView: InitView {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let leftTitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.LeftTitle.height
    label.config
      .font(UIConstants.LeftTitle.font)
      .textColor(UIConstants.LeftTitle.textColor)
      .numberOfLines(UIConstants.LeftTitle.numberOfLines)
    
    return label
  }()
  
  private let rightTitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.RightTitle.height
    label.config
      .font(UIConstants.RightTitle.font)
      .textColor(UIConstants.RightTitle.textColor)
      .numberOfLines(UIConstants.RightTitle.numberOfLines)
    
    return label
  }()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureLeftLabel()
    configureRightLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureLeftLabel() {
    addSubview(leftTitleLabel)
    leftTitleLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
      make.bottom.lessThanOrEqualToSuperview()
    }
    leftTitleLabel.setContentCompressionResistancePriority(.required,
                                                           for: .vertical)
    leftTitleLabel.setContentCompressionResistancePriority(.required,
                                                           for: .horizontal)
    leftTitleLabel.setContentHuggingPriority(.defaultLow,
                                             for: .vertical)
  }
  
  private func configureRightLabel() {
    addSubview(rightTitleLabel)
    rightTitleLabel.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview()
      make.leading.equalTo(leftTitleLabel.snp.trailing)
        .offset(UIConstants.RightTitle.leading)
      make.width.equalTo(leftTitleLabel)
      make.bottom.lessThanOrEqualToSuperview()
    }
    rightTitleLabel.setContentCompressionResistancePriority(.required,
                                                            for: .vertical)
    rightTitleLabel.setContentCompressionResistancePriority(.required,
                                                            for: .horizontal)
    rightTitleLabel.setContentHuggingPriority(.defaultLow,
                                              for: .vertical)
  }
  
  // MARK: - Interface
  func configure(title: String, value: String) {
    leftTitleLabel.text = title
    rightTitleLabel.text = value
    
    leftTitleLabel.sizeToFit()
    rightTitleLabel.sizeToFit()
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum LeftTitle {
    static let font = UIFont.regularAppFont(of: 14)
    static let height: CGFloat = 20
    static let textColor = UIColor.color(r: 62, g: 76, b: 75, a: 0.6)
    static let spacing: CGFloat = 14
    static let numberOfLines: Int = 2
  }
  
  enum RightTitle {
    static let font = UIFont.regularAppFont(of: 14)
    static let height: CGFloat = 20
    static let textColor = UIColor(named: "textDarkGreen")!
    static let numberOfLines: Int = 2
    
    static let leading: CGFloat = 16
  }
}

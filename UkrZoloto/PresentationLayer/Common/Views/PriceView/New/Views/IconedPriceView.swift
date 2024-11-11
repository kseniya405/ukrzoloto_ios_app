//
//  IconedPriceView.swift
//  UkrZoloto
//
//  Created by Mykola on 15.11.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

class IconedPriceView: InitView {
  
  private let imageView: UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  private let label: UILabel = {
    
    let label = LineHeightLabel()
    
    label.config
      .font(UIConstants.font)
      .textColor(UIConstants.textColor)
      .numberOfLines(0)
    
    label.textAlignment = .left

    label.setContentHuggingPriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    return label
  }()
  
  private let valueLabel: UILabel = {
    
    let label = LineHeightLabel()

    label.config
      .font(UIConstants.font)
      .textColor(UIConstants.textColor)
      .numberOfLines(1)
      
    label.setLineHeight(20.0)
    label.prepareForStackView()
    
    label.textAlignment = .right
        
    return label
  }()
  
  override func initConfigure() {
    super.initConfigure()
    
    configure()
  }
  
  func setup(title: String,
             valueString: String,
             icon: UIImage?,
             additionalText: String? = nil, // optional params needed for one case
             textColor: UIColor? = nil) {
    
    label.attributedText = nil
    label.text = title
    valueLabel.text = valueString
    valueLabel.textColor = textColor ?? UIConstants.textColor
    valueLabel.sizeToFit()
    
    if let icon = icon {
      imageView.isHidden = false
      imageView.image = icon
    } else {
      imageView.isHidden = true
    }
    
    if let additionalText = additionalText {
      
      let str = title + "  " + additionalText
      
      let attributedString = NSMutableAttributedString(string: str)
      
      attributedString.setAttributes([.foregroundColor: UIConstants.textColor], range: NSRange(location: 0, length: str.count))
      attributedString.setAttributes([.font: UIConstants.font], range: NSRange(location: 0, length: title.count))
      attributedString.setAttributes([.font: UIConstants.additionalFont], range: NSRange(location: str.count - additionalText.count, length: additionalText.count))
      
      label.text = nil
      label.attributedText = attributedString
    }
  }
  
  private func configure() {
    
    prepareForStackView()
  
    backgroundColor = .clear
    
    let stackView = UIStackView()
    stackView.prepareForStackView()
    stackView.spacing = 5.0
    stackView.axis = .horizontal
    addSubview(stackView)
    
    stackView.snp.makeConstraints { make in
      
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    imageView.setContentCompressionResistancePriority(.required, for: .vertical)
    
    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(24.0).priority(.required)
    }
    
    stackView.addArrangedSubview(imageView)
    
    let labelContainer = UIView()
    labelContainer.backgroundColor = .clear
    labelContainer.addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.centerY.equalToSuperview().offset(0)
    }
    
    stackView.addArrangedSubview(labelContainer)

    addSubview(valueLabel)
    valueLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.leading.equalTo(stackView.snp.trailing).offset(8.0)
    }
  }
}

private enum UIConstants {
  
  static let font = UIFont.regularAppFont(of: 14)
  static let lineHeight: CGFloat = 24.0
  static let textColor = UIColor(named: "textDarkGreen")!
	static let additionalFont = UIFont.semiBoldAppFont(of: 14)
}

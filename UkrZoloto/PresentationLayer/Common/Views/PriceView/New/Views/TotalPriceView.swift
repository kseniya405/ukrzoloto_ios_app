//
//  TotalPriceView.swift
//  UkrZoloto
//
//  Created by Mykola on 16.11.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

class TotalPriceView: InitView {
  
  private let titleLabel: UILabel = {
    
    let label = UILabel()
    label.config
      .font(UIConstants.titleFont)
      .textColor(UIConstants.textColor)
    
    return label
  }()
  
  private let valueLabel: UILabel = {
    
    let label = UILabel()
    label.config
      .font(UIConstants.valueFont)
      .textColor(UIConstants.textColor)
    
    label.prepareForStackView()
    
    return label
  }()
  
  
  override func initConfigure() {
    super.initConfigure()
   
    configure() 
  }
  
  private func configure() {
    
    backgroundColor = .clear
    prepareForStackView()
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    addSubview(valueLabel)
    valueLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.top.bottom.equalToSuperview()
    }
  }
  
  func setup(title: String, valueString: String) {
    
    titleLabel.text = title
    valueLabel.text = valueString
  }
}

fileprivate enum UIConstants {
  
  static let titleFont = UIFont.boldAppFont(of: 18.0)
  static let valueFont = UIFont.boldAppFont(of: 18.0)
  static let textColor = UIColor(named: "textDarkGreen")!
}

//
//  InstallmentPaymentPartsView.swift
//  UkrZoloto
//
//  Created by Mykola on 04.11.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

class InstallmentPaymentPartsView: InitView {
  
  private let label: UILabel = {
    let label = LineHeightLabel()
    
    label.config.font(UIConstants.font)
      .numberOfLines(1)
      .textColor(UIConstants.textColor)
    
    label.lineHeight = UIConstants.lineHeight
    
    return label
  }()
  
  
  
  override func initConfigure() {
    super.initConfigure()
    
    configureSelf()
  }
  
  func setPartsCount(count: Int) {
    label.text = "\(count)"
  }
  
  private func configureSelf() {
    
    let arrowIcon: UIImageView = {
      
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFit
      imageView.image = UIImage(named: "allow_down_bold")
      
      return imageView
    }()
    
    addSubview(arrowIcon)
    arrowIcon.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.width.height.equalTo(24.0)
      make.trailing.equalToSuperview()
    }
    
    addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalTo(arrowIcon.snp.top).offset(-5.0)
    }
    
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    
    
    let lineView = UIView()
    lineView.backgroundColor = UIColor(named: "card")!
    
    addSubview(lineView)
    lineView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
      make.bottom.equalToSuperview()
      make.top.equalTo(arrowIcon.snp.bottom).offset(8)
    }
  }
}

fileprivate enum UIConstants {
  static let font = UIFont.boldAppFont(of: 16)
  static let lineHeight: CGFloat = 24.0
  static let textColor = UIColor(named: "textDarkGreen")!
}

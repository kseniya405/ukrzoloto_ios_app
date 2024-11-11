//
//  CreditMonthView.swift
//  UkrZoloto
//
//  Created by Mykola on 28.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

class CreditMonthView: InitView {
  
  private let label: UILabel = {
    let label = UILabel()
    
    label.config
      .font(UIConstants.Label.labelFont)
      .textColor(UIConstants.Label.textColor)
    
    return label
  }()
    
  override func initConfigure() {
    super.initConfigure()
    setupSelf()
  }
  
  private func setupSelf() {
      
    addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.Label.leftPadding)
      make.centerY.equalToSuperview()
    }

    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = #imageLiteral(resourceName: "arrow_months")
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(UIConstants.Arrow.size)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(UIConstants.Arrow.rightPadding)
    }
  }
  
  func updateMonths(_ months: Int) {
    label.text = "\(months)"
  }
}

private enum UIConstants {
  
  enum Label {
    static let labelFont = UIFont.semiBoldAppFont(of: 18)
    static let textColor = UIColor(hex: "#1F2323")
    static let leftPadding: CGFloat = 15.0
  }

  enum Arrow {
    static let size: CGFloat = 24.0
    static let rightPadding: CGFloat = -9.0
  }
}

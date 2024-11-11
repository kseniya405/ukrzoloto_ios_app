//
//  IconLabelView.swift
//  UkrZoloto
//
//  Created by Mykola on 24.07.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class IconLabelView: UIView {
  
  private let imageView: UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .clear
    
    return imageView
  }()
  
  private let label: LineHeightLabel = {
    
    let label = LineHeightLabel()
    
    label.config
      .font(UIConstants.Label.font)
      .textColor(UIConstants.Label.color)
      .textAlignment(.left)
      .numberOfLines(0)
    
    label.contentMode = .center
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.lineHeight = UIConstants.Label.height
    
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  func setIcon(_ image: UIImage?) {
    imageView.image = image
  }
  
  func setText(_ text: String) {
    label.text = text
    label.sizeToFit()
  }
  
  private func setup() {
    
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview().offset(5)
      make.width.height.equalTo(UIConstants.Icon.width)
    }
    
    addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.equalTo(imageView.snp.trailing).offset(UIConstants.Label.leading)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
  
  private enum UIConstants {
    
    enum Label {
      static let font = UIFont.semiBoldAppFont(of: 16)
      static let color = UIColor.color(r: 31, g: 35, b: 35)
      static let height: CGFloat = 22.4
      
      static let leading: CGFloat = 10.0
    }
    
    enum Icon {
      static let width: CGFloat = 32.0
    }
  }
}

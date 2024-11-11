//
//  ImageLabelView.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 06.01.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class ImageLabelView: InitView {
  
  // MARK: - Private variables
  private let imageView = UIImageView()
  private let titleLabel = LineHeightLabel()
  
  // MARK: - Init configure
  override func initConfigure() {
    configureSelfView()
    configureImageView()
    configureTitleLabel()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureImageView() {
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.left.equalToSuperview()
      make.height.width.equalTo(UIConstants.ImageView.side)
    }
  }
  
  private func configureTitleLabel() {
    titleLabel.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
      .textColor(UIConstants.TitleLabel.textColor)
      .textAlignment(UIConstants.TitleLabel.textAlignment)
    titleLabel.lineHeight = UIConstants.TitleLabel.lineHeight
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(UIConstants.TitleLabel.top)
      make.leading.trailing.bottom.equalToSuperview()
    }
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  // MARK: - Interface
  func setImage(_ imageViewModel: ImageViewModel?) {
    if let imageViewModel = imageViewModel {
      imageView.setImage(from: imageViewModel)
    } else {
      imageView.image = nil
    }
  }
  
  func setTitle(_ title: String?) {
    titleLabel.text = title
  }
  
  func setTitleColor(_ color: UIColor) {
    titleLabel.textColor = color
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum ImageView {
    static let side: CGFloat = 35
  }
  
  enum TitleLabel {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 16)
    static let lineHeight: CGFloat = 24
    static let textAlignment = NSTextAlignment.left
    static let numberOfLines = 0
    
    static let top: CGFloat = 8
  }
}

//
//  PopupView.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 09.04.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class PopupView: InitView {
  
  // MARK: - Private variables
  private let imageView = UIImageView()
  private let titleLabel = LineHeightLabel()
  private let button = MainButton()
  
  // MARK: - Init configure
  override func initConfigure() {
    configureSelfView()
    configureImageView()
    configureTitleLabel()
    configureButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
  }
  
  private func configureImageView() {
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.ImageView.top)
      make.centerX.equalToSuperview()
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
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.TitleLabel.left)
    }
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureButton() {
    addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Button.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Button.left)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Button.bottom)
      make.height.equalTo(UIConstants.Button.height)
    }
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
  
  func setButtonTitle(_ title: String?) {
    button.setTitle(title, for: .normal)
  }
  
  func addButtonTarget(_ target: Any?,
                       action: Selector,
                       for controlEvents: UIControl.Event = .touchUpInside) {
    button.addTarget(target, action: action, for: controlEvents)
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
    static let cornerRadius: CGFloat = 32
  }
  
  enum ImageView {
    static let top: CGFloat = 24
    static let side: CGFloat = 66
  }
  
  enum TitleLabel {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    static let lineHeight: CGFloat = 21
    static let textAlignment = NSTextAlignment.center
    static let numberOfLines = 0
    
    static let top: CGFloat = 24
    static let left: CGFloat = 30
  }
  
  enum Button {
    static let top: CGFloat = 24
    static let left: CGFloat = 16
    static let bottom: CGFloat = 16
    static let height: CGFloat = 52
  }
}

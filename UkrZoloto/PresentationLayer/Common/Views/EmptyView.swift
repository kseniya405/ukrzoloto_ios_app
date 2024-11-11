//
//  EmptyView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 10.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class EmptyView: InitView {
  
  // MARK: - Private variables
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.color)
      .textAlignment(.center)
      .numberOfLines(0)
    label.lineHeight = UIConstants.Title.height
    
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.color)
      .textAlignment(.center)
      .numberOfLines(0)
    label.lineHeight = UIConstants.Subtitle.height
    
    return label
  }()
  
  private let button = EmptyButton()
  
  // MARK: - Configure
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupImage()
    setupTitle()
    setupSubtitle()
    setupButton()
  }
  
  private func setupView() {
    backgroundColor = .white
  }
  
  private func setupImage() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.Image.side)
      make.top.equalToSuperview()
        .offset(UIConstants.Image.top)
      make.centerX.equalToSuperview()
    }
  }
  
  private func setupTitle() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
        .offset(UIConstants.Title.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.Title.leading)
      make.centerX.equalToSuperview()
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupSubtitle() {
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Subtitle.top)
      make.leading.trailing.equalTo(titleLabel)
    }
    subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupButton() {
    addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(UIConstants.Button.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Button.leading)
      make.bottom.lessThanOrEqualTo(snp.bottom)
        .inset(UIConstants.Button.bottom)
      make.height.equalTo(UIConstants.Button.height)
    }
    setButtonTitle(nil)
  }
  
  // MARK: - Public
  func setImage(_ image: UIImage) {
    imageView.image = image
  }
  
  func setTitle(_ text: String) {
    titleLabel.text = text
  }
  
  func setSubtitle(_ text: String) {
    subtitleLabel.text = text
  }
  
  func setButtonTitle(_ text: String?) {
    button.setTitle(text, for: .normal)
    button.isHidden = text.isNilOrEmpty
  }
  
  func addTargetOnButton(_ target: Any?,
                         action: Selector,
                         for event: UIControl.Event) {
    button.addTarget(target, action: action, for: event)
  }
}

private enum UIConstants {
  enum Image {
    static let top: CGFloat = Constants.Screen.heightCoefficient > 1 ? 100 : 50
    static let side: CGFloat = 60
  }
  
  enum Title {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 22)
    static let height: CGFloat = 26.4
    
    static let top: CGFloat = 8
    static let leading: CGFloat = 30
  }
  
  enum Subtitle {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    static let height: CGFloat = 19.5
    
    static let top: CGFloat = 14
    static let bottom: CGFloat = 10
  }
  
  enum Button {
    static let top: CGFloat = 28
    static let leading: CGFloat = 24
    static let bottom: CGFloat = 10
    static let height: CGFloat = 52
  }
  
}

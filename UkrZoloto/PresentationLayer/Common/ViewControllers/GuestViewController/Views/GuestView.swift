//
//  GuestView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 16.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class GuestView: RoundedContainerView {
  
  // MARK: - Private variables
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.opacity = UIConstants.Image.opacity
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
  
  private let loginButton = MainButton()
  private let guestButton = EmptyButton()
  
  // MARK: - Configure
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupImage()
    setupTitle()
    setupSubtitle()
    setupLoginButton()
    setupGuestButton()
  }
  
  private func setupView() {
    backgroundColor = .white
  }
  
  private func setupImage() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.Image.side).priority(.low)
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
  
  private func setupLoginButton() {
    addSubview(loginButton)
    loginButton.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(UIConstants.LoginButton.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.LoginButton.leading)
      make.height.equalTo(UIConstants.LoginButton.height)
    }
  }
  
  private func setupGuestButton() {
    addSubview(guestButton)
    guestButton.snp.makeConstraints { make in
      make.top.equalTo(loginButton.snp.bottom)
        .offset(UIConstants.GuestButton.top)
      make.leading.trailing.height.equalTo(loginButton)
      make.bottom.lessThanOrEqualTo(snp.bottom)
        .inset(UIConstants.GuestButton.bottom)
    }
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
  
  func setLoginButtonTitle(_ text: String?) {
    loginButton.setTitle(text, for: .normal)
  }
  
  func addTargetOnLoginButton(_ target: Any?,
                         action: Selector,
                         for event: UIControl.Event) {
    loginButton.addTarget(target, action: action, for: event)
  }
  
  func setGuestButtonTitle(_ text: String?) {
    guestButton.setTitle(text, for: .normal)
    guestButton.isHidden = text.isNilOrEmpty
  }
  
  func addTargetOnGuestButton(_ target: Any?,
                         action: Selector,
                         for event: UIControl.Event) {
    guestButton.addTarget(target, action: action, for: event)
  }
}

private enum UIConstants {
  enum Image {
    static let opacity: Float = 0.8
    
    static let top: CGFloat = 100
    static let side: CGFloat = 101
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
  
  enum LoginButton {
    static let top: CGFloat = 28
    static let leading: CGFloat = 24
    static let height: CGFloat = 52
  }
  
  enum GuestButton {
    static let top: CGFloat = 16
    static let bottom: CGFloat = 20
  }
  
}

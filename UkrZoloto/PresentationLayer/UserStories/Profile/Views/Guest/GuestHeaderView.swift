//
//  GuestHeaderView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit
import ActiveLabel

protocol GuestHeaderViewDelegate: AnyObject {
  func subtitleTextWasClicked(from: GuestHeaderView)
  func buttonWasClicked(from: GuestHeaderView)
}

class GuestHeaderView: InitView {
  
  // MARK: - Public variables
  weak var delegate: GuestHeaderViewDelegate?
  
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.lineHeight
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
      .numberOfLines(UIConstants.Title.numberOfLines)
    return label
  }()
  
  private let subtitleLabel: ActiveLabel = {
    let label = ActiveLabel()
    label.setLineHeight(UIConstants.Subtitle.lineHeight)
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.textColor)
      .numberOfLines(UIConstants.Subtitle.numberOfLines)
    return label
  }()
  
  private let button: RightImageButton = {
    let button = RightImageButton()
    button.setImage(UIConstants.Button.image, for: .normal)
    button.textColor = UIConstants.Button.textColor
    button.textFont = UIConstants.Button.font
    button.contentHorizontalAlignment = .left
    return button
  }()
  
  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureTitleLabel()
    configureSubtitleLabel()
    configureButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
        .inset(UIConstants.Title.insets)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.height.equalTo(90)
    }
  }
  
  private func configureSubtitleLabel() {
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Subtitle.top)
      make.leading.trailing.equalTo(titleLabel)
    }
  }
  
  private func configureButton() {
    button.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
    addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(UIConstants.Button.top)
      make.leading.trailing.equalTo(subtitleLabel)
      make.height.equalTo(UIConstants.Button.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Button.bottom)
    }
  }
  
  // MARK: - Interface
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
  
  func setSubtitle(_ text: String, clickedText: String? = nil) {
    subtitleLabel.text = text
    subtitleLabel.setLineHeight(UIConstants.Subtitle.lineHeight)
    
    guard let clickedText = clickedText else { return }
    subtitleLabel.customize { label in
      let dataClickedType = ActiveType.custom(pattern: clickedText)
      label.customColor[dataClickedType] = UIConstants.Subtitle.selectedTextColor
      label.customSelectedColor[dataClickedType] = UIConstants.Subtitle.textColor
      label.handleCustomTap(for: dataClickedType, handler: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.subtitleTextWasClicked(from: self)
      })
      label.enabledTypes = [dataClickedType]
    }
  }
  
  func setButtonTitle(_ title: String) {
    button.setTitle(title, for: .normal)
    button.layoutIfNeeded()
  }
  
  // MARK: - Private
  @objc
  private func didTapOnButton() {
    delegate?.buttonWasClicked(from: self)
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  
  enum Title {
    static let font = UIFont.extraBoldAppFont(of: 34)
    static let textColor = UIColor.white
    static let numberOfLines = 0
    static let lineHeight: CGFloat = 36
    
    static let insets: CGFloat = 24
    static let top: CGFloat = 10 * Constants.Screen.heightCoefficient
  }
  
  enum Subtitle {
    static let font = UIFont.regularAppFont(of: 15)
    static let textColor = UIColor.white
    static let selectedTextColor = UIColor.color(r: 255, g: 220, b: 136)
    static let numberOfLines = 0
    static let lineHeight: CGFloat = 22.5
    
    static let top: CGFloat = 7 * Constants.Screen.heightCoefficient
  }
  
  enum Button {
    static let top: CGFloat = 20 * Constants.Screen.heightCoefficient
    static let height: CGFloat = 25
    static let imageInset: CGFloat = 14
    static let bottom: CGFloat = 20 * Constants.Screen.heightCoefficient
    
    static let image = #imageLiteral(resourceName: "rightYellowArrow")
    static let font = UIFont.boldAppFont(of: 13)
    static let textColor = UIColor.color(r: 255, g: 220, b: 136)
  }
}

//
//  AdPermissionView.swift
//  UkrZoloto
//
//  Created by Mykola on 24.07.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class AdPermissionView: RoundedContainerView {
  
  private var gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.colors = UIConstants.SelfView.gradientColors
    layer.startPoint = CGPoint(x: 0.5, y: 0.0)
    layer.endPoint = CGPoint(x: 0.5, y: 1.0)
    
    return layer
  }()
  
  private let imageView: UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    
    let label = LineHeightLabel()
    
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.color)
      .textAlignment(.left)
      .numberOfLines(0)
    label.lineHeight = UIConstants.Title.height
    
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    
    let label = LineHeightLabel()
    
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.color)
      .textAlignment(.left)
      .numberOfLines(0)
    
    return label
  }()
  
  private let stackView: UIStackView = {
    
    let stackView = UIStackView()
    
    stackView.distribution = .fillEqually
    stackView.spacing = UIConstants.Stack.spacing
    stackView.axis = .vertical
    
    return stackView
  }()
  
  private let button = RoundedButton(fillColor: UIColor.color(r: 255, g: 220, b: 136),
                                     textColor: UIColor.color(r: 31, g: 35, b: 35))
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }
  
  override func initConfigure() {
    super.initConfigure()
    
    setupView()
    setupProceedButton()
    setupStackView()
    setupSubtitle()
    setupTitle()
    setupIllustration()
  }
}

//MARK: - Public methods
extension AdPermissionView {
  
  func setTitle(_ text: String) {
    titleLabel.text = text
  }
  
  func setSubtitle(_ text: String) {
    subtitleLabel.text = text
  }
  
  func setTopLabelText(_ text: String) {
    if let view = stackView.arrangedSubviews.filter({$0.tag == 1}).first as? IconLabelView {
      view.setText(text)
    }
  }
  
  func setMiddleLabelText(_ text: String) {
    
    if let view = stackView.arrangedSubviews.filter({$0.tag == 2}).first as? IconLabelView {
      view.setText(text)
    }
  }
  
  func setBottomLabelText(_ text: String) {
    
    if let view = stackView.arrangedSubviews.filter({$0.tag == 3}).first as? IconLabelView {
      view.setText(text)
    }
  }
  
  func setButtonTitle(_ text: String) {
    button.setTitle(text, for: .normal)
  }
  
  func addTargetOnProceedButton(_ target: Any?,
                                action: Selector,
                                for event: UIControl.Event) {
    
    button.addTarget(target, action: action, for: event)
  }
}

fileprivate extension AdPermissionView {
  
  func setupView() {
    
    backgroundColor = .white
    setupGradient()
  }
  
  func setupProceedButton() {
        
    addSubview(button)
    button.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-UIConstants.Button.padding)
      make.leading.equalToSuperview().offset(UIConstants.Button.padding)
      make.trailing.equalToSuperview().offset(-UIConstants.Button.padding)
      make.height.equalTo(UIConstants.Button.height)
    }
  }
  
  func setupStackView() {
    
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.trailing.equalTo(button)
      make.bottom.equalTo(button.snp.top).offset(-UIConstants.Stack.bottom)
    }
    stackView.setContentCompressionResistancePriority(.required, for: .vertical)
    
    let topSubview = IconLabelView()
    topSubview.tag = 1
    topSubview.setIcon(UIImage(named: "iconsGem"))
    
    let middleSubview = IconLabelView()
    middleSubview.tag = 2
    middleSubview.setIcon(UIImage(named: "iconsBell"))
    
    let bottomSubview = IconLabelView()
    bottomSubview.tag = 3
    bottomSubview.setIcon(UIImage(named: "iconsBluehorn"))
    
    stackView.addArrangedSubview(topSubview)
    stackView.addArrangedSubview(middleSubview)
    stackView.addArrangedSubview(bottomSubview)
  }
  
  func setupSubtitle() {
    
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().offset(UIConstants.Subtitle.leading)
      make.bottom.equalTo(stackView.snp.top).offset(-UIConstants.Subtitle.top)
    }
  }
  
  func setupTitle() {
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(subtitleLabel)
      make.bottom.equalTo(subtitleLabel.snp.top).offset(-UIConstants.Subtitle.top)
    }
  }
  
  func setupIllustration() {
    
    let image = UIImage(named: "idfa_illustration")
    imageView.image = image
    
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.lessThanOrEqualTo(self.snp.topMargin)
      make.bottom.equalTo(titleLabel.snp.top)
    }
  }
  
  func setupGradient() {
    
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(container)
    container.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    container.layer.addSublayer(gradientLayer)
  }
}

fileprivate extension AdPermissionView {
  
  enum UIConstants {
    
    enum SelfView {
      static let gradientColors = [UIColor.color(r: 255, g: 255, b: 255).cgColor,
                                   UIColor.color(r: 255, g: 251, b: 240).cgColor]
    }
    
    enum Title {
      static let font = UIFont.boldAppFont(of: 24)

      static let height: CGFloat = 33.6
      static let color = UIColor.color(r: 31, g: 35, b: 35)
      
      static let leading = 30
    }
    
    enum Subtitle {
      static let font = UIFont.semiBoldAppFont(of: 16)
      static let color = UIColor.color(r: 31, g: 35, b: 35)
      static let height: CGFloat = 22.4
      
      static let leading: CGFloat = 30.0
      static let top: CGFloat = 20.0
    }
    
    enum Stack {
      static let spacing: CGFloat = 20.0
      
      static let leading: CGFloat = 30.0
      static let top: CGFloat = 20.0
      static let bottom: CGFloat = 40.0
    }
    
    enum Button {
      static let padding: CGFloat = 30.0
      static let height: CGFloat = 50.0
    }
  }
}

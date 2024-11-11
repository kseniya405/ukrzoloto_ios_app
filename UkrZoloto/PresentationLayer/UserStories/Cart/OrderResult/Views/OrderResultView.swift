//
//  OrderResultView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/29/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum GiftViewState {
  case none
  case request
  case received
}

class OrderResultView: InitView {
  
  // MARK: - Private variables
  private let scrollView = UIScrollView()
  private let contentView = InitView()
  
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
  
  private let orderNumberTextLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.OrderNumberTextLabel.font)
      .textColor(UIConstants.OrderNumberTextLabel.color)
      .textAlignment(.center)
      .numberOfLines(1)
    label.lineHeight = UIConstants.OrderNumberTextLabel.height
    
    return label
  }()
  
  private let orderNumberLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.OrderNumberLabel.font)
      .textColor(UIConstants.OrderNumberLabel.color)
      .textAlignment(.center)
      .numberOfLines(1)
    label.lineHeight = UIConstants.OrderNumberLabel.height
    
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
  
  private let contactTitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Contact.Title.font)
      .textColor(UIConstants.Contact.Title.color)
      .textAlignment(.center)
      .numberOfLines(0)
    label.lineHeight = UIConstants.Contact.Title.height
    
    return label
  }()
  
  private let contactSubtitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Contact.Subtitle.font)
      .textColor(UIConstants.Contact.Subtitle.color)
      .textAlignment(.center)
      .numberOfLines(0)
    label.lineHeight = UIConstants.Contact.Subtitle.height
    
    return label
  }()
  
  private let contactPhoneLabel: UILabel = {
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.Contact.Phone.font)
      .textColor(UIConstants.Contact.Phone.color)
      .textAlignment(.center)
      .numberOfLines(0)
    label.lineHeight = UIConstants.Contact.Phone.height
    
    return label
  }()
  
  private let giftRequestView = GiftRequestView()
  private let giftReceivedView = GiftReceivedView()
  
  private let button = EmptyButton()
  
  // MARK: - Configure
  override func initConfigure() {
    super.initConfigure()
    setupView()
    setupScrollView()
    setupImageView()
    setupTitleLabel()
    setupOrderNumberTextLabel()
    setupOrderNumberLabel()
    setupSubtitleLabel()
    setupContactTitleLabel()
    setupContactPhoneLabel()
    setupContactSubtitleLabel()
    setupGiftRequestView()
    setupGiftReceivedView()
    setupButton()
  }
  
  private func setupView() {
    backgroundColor = UIConstants.backgroundColor
  }
  
  private func setupScrollView() {
    addSubview(scrollView)
    scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(scrollView)
    }
  }
  
  private func setupImageView() {
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.Image.side)
      make.top.equalToSuperview()
        .offset(UIConstants.Image.top)
      make.centerX.equalToSuperview()
    }
  }
  
  private func setupTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
        .offset(UIConstants.Title.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.Title.leading)
      make.centerX.equalToSuperview()
    }
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupOrderNumberTextLabel() {
    contentView.addSubview(orderNumberTextLabel)
    orderNumberTextLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.OrderNumberTextLabel.top)
      make.leading.trailing.equalTo(titleLabel)
    }
    orderNumberTextLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupOrderNumberLabel() {
    contentView.addSubview(orderNumberLabel)
    orderNumberLabel.snp.makeConstraints { make in
      make.top.equalTo(orderNumberTextLabel.snp.bottom)
        .offset(UIConstants.OrderNumberLabel.top)
      make.leading.trailing.equalTo(titleLabel)
    }
    orderNumberLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupSubtitleLabel() {
    contentView.addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(orderNumberLabel.snp.bottom)
        .offset(UIConstants.Subtitle.top)
      make.leading.trailing.equalTo(titleLabel)
    }
    subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupContactTitleLabel() {
    contentView.addSubview(contactTitleLabel)
    contactTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(UIConstants.Contact.Title.top)
      make.leading.trailing.equalTo(titleLabel)
    }
    contactTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupContactPhoneLabel() {
    contentView.addSubview(contactPhoneLabel)
    contactPhoneLabel.snp.makeConstraints { make in
      make.top.equalTo(contactTitleLabel.snp.bottom)
        .offset(UIConstants.Contact.Phone.top)
      make.leading.trailing.equalTo(titleLabel)
    }
    contactPhoneLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupContactSubtitleLabel() {
    contentView.addSubview(contactSubtitleLabel)
    contactSubtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(contactPhoneLabel.snp.bottom)
        .offset(UIConstants.Contact.Phone.top)
      make.leading.trailing.equalTo(titleLabel)
    }
    contactSubtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func setupGiftRequestView() {
    contentView.addSubview(giftRequestView)
    giftRequestView.snp.makeConstraints { make in
      make.top.equalTo(contactSubtitleLabel.snp.bottom)
        .offset(UIConstants.GiftRequestView.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.GiftRequestView.leading)
    }
  }
  
  private func setupGiftReceivedView() {
    contentView.addSubview(giftReceivedView)
    giftReceivedView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalTo(giftRequestView)
    }
  }
  
  private func setupButton() {
    button.backgroundColor = UIConstants.Button.color
    button.setTitleColor(UIConstants.Button.titleColor, for: .normal)
    contentView.addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(giftRequestView.snp.bottom)
        .offset(UIConstants.Button.topToRequestView)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Button.leading)
      make.height.equalTo(UIConstants.Button.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Button.bottom)
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
  
  func setOrderNumberText(_ text: String) {
    orderNumberTextLabel.text = text
  }
  
  func setOrderNumber(_ text: String) {
    orderNumberLabel.text = text
  }
  
  func setSubtitle(_ text: String) {
    subtitleLabel.text = text
  }
  
  func setButtonTitle(_ text: String?) {
    button.setTitle(text, for: .normal)
    button.isHidden = text.isNilOrEmpty
  }
  
  func setContactTitle(_ text: String?) {
    contactTitleLabel.text = text
  }
  
  func setContactSubtitle(_ text: String?) {
    contactSubtitleLabel.text = text
  }
  
  func setContactPhone(_ text: String?) {
    contactPhoneLabel.text = text
  }
  
  func setRequestGiftTitle(_ giftTitle: String?) {
    giftRequestView.setTitle(giftTitle)
  }
  
  func setReceivedGiftTitle(_ giftTitle: String?) {
    giftReceivedView.setTitle(giftTitle)
  }
  
  func setGiftState(_ state: GiftViewState) {
    switch state {
    case .none:
      button.snp.makeConstraints { make in
        make.top.equalTo(contactSubtitleLabel.snp.bottom)
          .offset(UIConstants.Button.topToContactSubtitle)
        make.leading.trailing.equalToSuperview()
          .inset(UIConstants.Button.leading)
        make.height.equalTo(UIConstants.Button.height)
        make.bottom.equalToSuperview()
          .inset(UIConstants.Button.bottom)
      }
      giftRequestView.isHidden = true
      giftReceivedView.isHidden = true
    case .request,
         .received:
      giftRequestView.isHidden = state == .received
      giftReceivedView.isHidden = state == .request
      button.snp.makeConstraints { make in
        make.top.equalTo(giftRequestView.snp.bottom)
          .offset(UIConstants.Button.topToRequestView)
        make.leading.trailing.equalToSuperview()
          .inset(UIConstants.Button.leading)
        make.height.equalTo(UIConstants.Button.height)
        make.bottom.equalToSuperview()
          .inset(UIConstants.Button.bottom)
      }
    }
  }
  
  func addTargetOnGift(_ target: Any?,
                       action: Selector,
                       for event: UIControl.Event) {
    let gesture = UITapGestureRecognizer(target: target, action: action)
    giftRequestView.addGestureRecognizer(gesture)
    giftRequestView.isUserInteractionEnabled = true
  }
  
  func addTargetOnButton(_ target: Any?,
                         action: Selector,
                         for event: UIControl.Event) {
    button.addTarget(target, action: action, for: event)
  }
  
  func addTargetOnContact(_ target: Any?,
                          action: Selector,
                          for event: UIControl.Event) {
    let gesture = UITapGestureRecognizer(target: target, action: action)
    contactPhoneLabel.addGestureRecognizer(gesture)
    contactPhoneLabel.isUserInteractionEnabled = true
  }
}

private enum UIConstants {
  
  static let backgroundColor = UIColor.white
  
  enum Image {
    static let top: CGFloat = 0.04 * Constants.Screen.screenHeight
    static let side: CGFloat = 126 * Constants.Screen.heightCoefficient
  }
  
  enum Title {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 18)
    static let height: CGFloat = 21.6
    
    static let top: CGFloat = 24
    static let leading: CGFloat = 24
  }
  
  enum OrderNumberTextLabel {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    static let height: CGFloat = 19
    
    static let top: CGFloat = 10
    static let leading: CGFloat = 24
  }
  
  enum OrderNumberLabel {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 15)
    static let height: CGFloat = 19
    
    static let top: CGFloat = 2
    static let leading: CGFloat = 24
  }
  
  enum Subtitle {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    static let height: CGFloat = 19.5
    
    static let top: CGFloat = 12
  }
  
  enum Contact {
    enum Title {
      static let color = UIColor.color(r: 62, g: 76, b: 75)
      static let font = UIFont.regularAppFont(of: 13)
      static let height: CGFloat = 16.9
      
      static let top: CGFloat = 24
    }
    
    enum Phone {
      static let color = UIColor.color(r: 62, g: 76, b: 75)
      static let font = UIFont.boldAppFont(of: 24)
      static let height: CGFloat = 24
      
      static let top: CGFloat = 9
    }
    
    enum Subtitle {
      static let color = UIColor.color(r: 62, g: 76, b: 75)
      static let font = UIFont.regularAppFont(of: 13)
      static let height: CGFloat = 16.9
      
      static let top: CGFloat = 6
    }
  }
  
  enum GiftRequestView {
    static let top: CGFloat = 26
    static let leading: CGFloat = 24
  }
  
  enum Button {
    static let color = UIColor.color(r: 0, g: 80, b: 47)
    static let titleColor = UIColor.white
    
    static let topToRequestView: CGFloat = 10
    static let topToContactSubtitle: CGFloat = 33
    static let leading: CGFloat = 24
    static let height: CGFloat = 52
    static let bottom: CGFloat = 16
  }
}

//
//  SupportView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 03.07.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation

class SupportView: InitView {
  weak var delegate: SupportSocialViewDelegate?

  private let topLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.TopLabel.font
    label.textColor = UIConstants.TopLabel.textColor
    label.numberOfLines = 0
    label.textAlignment = .center

    return label
  }()

  private let phoneLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.PhoneLabel.font
    label.textColor = UIConstants.PhoneLabel.textColor
    label.numberOfLines = 0
    label.textAlignment = .center

    return label
  }()

  private let workingLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.WorkingLabel.font
    label.textColor = UIConstants.WorkingLabel.textColor
    label.numberOfLines = 0
    label.textAlignment = .center

    return label
  }()

  private let weekendLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.WeekendLabel.font
    label.textColor = UIConstants.WeekendLabel.textColor
    label.numberOfLines = 0
    label.textAlignment = .center

    return label
  }()

  private let separatorView: UIView = {
    let view = UIView()

    view.backgroundColor = UIConstants.SeparatorView.color

    return view
  }()

  private let bottomLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.BottomLabel.font
    label.textColor = UIConstants.BottomLabel.textColor
    label.numberOfLines = 0
    label.textAlignment = .center

    return label
  }()

  private let messengersStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .equalCentering
    stackView.spacing = UIConstants.MessengersStackView.spacing

    return stackView
  }()

  override func initConfigure() {
    super.initConfigure()

    self.backgroundColor = UIColor(hex: "#F6F6F6")
    self.layer.cornerRadius = 16

    addSubview(topLabel)
    topLabel.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.TopLabel.height)
      make.top.equalToSuperview().offset(UIConstants.TopLabel.top)
      make.leading.trailing.equalToSuperview()
    }

    addSubview(phoneLabel)
    phoneLabel.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.PhoneLabel.height)
      make.top.equalTo(topLabel.snp.bottom).offset(UIConstants.PhoneLabel.top)
      make.leading.trailing.equalToSuperview()
    }

    addSubview(workingLabel)
    workingLabel.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.WorkingLabel.height)
      make.top.equalTo(phoneLabel.snp.bottom).offset(UIConstants.WorkingLabel.top)
      make.leading.trailing.equalToSuperview()
    }

    addSubview(weekendLabel)
    weekendLabel.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.WeekendLabel.height)
      make.top.equalTo(workingLabel.snp.bottom).offset(UIConstants.WeekendLabel.top)
      make.leading.trailing.equalToSuperview()
    }

    addSubview(separatorView)
    separatorView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.SeparatorView.height)
      make.top.equalTo(weekendLabel.snp.bottom).offset(UIConstants.SeparatorView.top)
      make.leading.trailing.equalToSuperview()
    }

    addSubview(bottomLabel)
    bottomLabel.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.BottomLabel.height)
      make.top.equalTo(separatorView.snp.bottom).offset(UIConstants.BottomLabel.top)
      make.leading.trailing.equalToSuperview()
    }

    addSubview(messengersStackView)
    messengersStackView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.MessengersStackView.height)
      make.top.equalTo(bottomLabel.snp.bottom).offset(UIConstants.MessengersStackView.top)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(UIConstants.MessengersStackView.bottom)
    }
  }

  func addHotLineTarget(_ target: Any?, action: Selector) {
    let gesture = UITapGestureRecognizer(target: target, action: action)
    phoneLabel.addGestureRecognizer(gesture)
    phoneLabel.isUserInteractionEnabled = true
  }

  func addSupportSocialDelegate(_ delegate: SupportSocialViewDelegate) {
    self.delegate = delegate
  }

  public func updateViewStateWith(_ socials: [Social]) {
    topLabel.text = Localizator.standard.localizedString("Горячая линия")
    phoneLabel.text = ContactsHelper().formattedPhone
    workingLabel.text = Localizator.standard.localizedString("Пн-Пт") + " " + ContactsHelper().workdayHrs
    weekendLabel.text = Localizator.standard.localizedString("Сб-Вс") + " " + ContactsHelper().weekendHrs
    bottomLabel.text = Localizator.standard.localizedString("Поддержка в мессенджерах")

    if messengersStackView.arrangedSubviews.isEmpty {
      socials.forEach { socialNetwork in
        let socialIcon = UIImageView(image: socialNetwork.image)
        socialIcon.isUserInteractionEnabled = true
        socialIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage)))

        messengersStackView.addArrangedSubview(socialIcon)
      }

      messengersStackView.sizeToFit()
    }
  }

  // MARK: - Actions
  @objc
  private func didTapOnImage(gestureRecognizer: UIGestureRecognizer) {
		if let index = messengersStackView.arrangedSubviews.firstIndex(of: gestureRecognizer.view!) {
      delegate?.didTapOnImage(with: index)
    }
  }
}

fileprivate enum UIConstants {
  enum TopLabel {
    static let font = UIFont.boldAppFont(of: 14.0)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let height: CGFloat = 20
    static let top: CGFloat = 15
  }

  enum PhoneLabel {
    static let font = UIFont.boldAppFont(of: 28.0)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let height: CGFloat = 32
    static let top: CGFloat = 5
  }

  enum WorkingLabel {
    static let font = UIFont.semiBoldAppFont(of: 12)
    static let textColor = UIColor(hex: "#87908F")
    static let height: CGFloat = 16
    static let top: CGFloat = 5
  }

  enum WeekendLabel {
    static let font = UIFont.semiBoldAppFont(of: 12)
    static let textColor = UIColor(hex: "#87908F")
    static let height: CGFloat = 16
    static let top: CGFloat = 5
  }

  enum SeparatorView {
    static let top: CGFloat = 15
    static let color = UIColor(hex: "#E6EDEC")
    static let height: CGFloat = 1
  }

  enum BottomLabel {
    static let height: CGFloat = 20
    static let font = UIFont.boldAppFont(of: 14.0)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let top: CGFloat = 15
  }

  enum MessengersStackView {
    static let top: CGFloat = 10
    static let bottom: CGFloat = 15
    static let spacing: CGFloat = 20
    static let height: CGFloat = 32
    static let elelementSize: CGFloat = 32
  }
}

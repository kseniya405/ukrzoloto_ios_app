//
//  ProfileBirthdateToolTipView.swift
//  UkrZoloto
//
//  Created by Mykola on 12.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

class ProfileBirthdateToolTipView: UIView {
  
  var onDismiss: (()->())?
  var onPhoneNumberTap: (()->())?
  
  private var originRect: CGRect!
  private var tipView: UIView!
    
  private let messageLabel: UILabel = {
    
    let label = UILabel()
    label.config
      .font(UIConstants.TipView.messageFont)
      .textColor(UIConstants.TipView.textColor)
      .numberOfLines(0)
    
    label.text = Localizator.standard.localizedString("Если Вам необходимо изменить указанную дату рождения - обратитесь, пожалуйста, в один из магазинов Укрзолото с паспортом или на горячую линию")
    return label
  }()
  
  private let numberLabel: UILabel = {
    
    let label = UILabel()
    label.config
      .font(UIConstants.TipView.numberFont)
      .textColor(UIConstants.TipView.textColor)
    
    label.text = ContactsHelper().formattedPhone
    label.isUserInteractionEnabled = true
    
    return label
  }()
  
  convenience init(originRect: CGRect) {
    self.init(frame: .zero)
    self.originRect = originRect
    
    initConfigure()
  }
  
  func display(in container: UIView) {
      displayInternal(container: container)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
    tipView.layer.shadowPath = UIBezierPath(rect: tipView.bounds).cgPath
    tipView.layer.shadowColor = UIColor.black.cgColor
    tipView.layer.shadowRadius = 15.0
    tipView.layer.shadowOpacity = 0.15
    tipView.layer.masksToBounds = false
  }
}

fileprivate extension ProfileBirthdateToolTipView {
  
  func initConfigure() {
    backgroundColor = .clear
    isUserInteractionEnabled = true 
  }
  
  func displayInternal(container: UIView) {
    
    self.frame = container.bounds
    
    tipView = UIView()
    tipView.isUserInteractionEnabled = true
    tipView.backgroundColor = .white
    tipView.layer.cornerRadius = UIConstants.TipView.cornerRadius
    tipView.clipsToBounds = false
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = UIConstants.TipView.textVerticalPadding
    
    stackView.addArrangedSubview(messageLabel)
    stackView.addArrangedSubview(numberLabel)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPhoneTap(_:)))
    numberLabel.addGestureRecognizer(tapGesture)
    
    tipView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.TipView.textInset)
      make.trailing.equalToSuperview().offset(-UIConstants.TipView.textInset)
      make.top.equalToSuperview().offset(UIConstants.TipView.textInset)
      make.bottom.equalToSuperview().offset(-UIConstants.TipView.textInset)
    }
    
    addSubview(tipView)
    tipView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.TipView.leftpadding)
      make.trailing.equalToSuperview().offset(-UIConstants.TipView.rightPadding)
      make.bottom.equalTo(self.snp.top).offset(originRect.minY - UIConstants.TipView.bottomPadding)
    }
    
    let view = UIView()
    view.backgroundColor = .white
    view.transform = CGAffineTransform(rotationAngle: .pi/4)
    self.addSubview(view)
    view.snp.makeConstraints { make in
      make.trailing.equalTo(tipView.snp.trailing).offset(-16.0)
      make.height.width.equalTo(16.0)
      make.top.equalTo(tipView.snp.bottom).offset(-8.0)
    }
    self.bringSubviewToFront(view)
    
    let outsideTap = UITapGestureRecognizer(target: self, action: #selector(onOutsideTap(_:)))
    self.addGestureRecognizer(outsideTap)

    container.addSubview(self)
  }
  
  
  @objc private func onOutsideTap(_ sender: UITapGestureRecognizer) {
    
    UIView.animate(withDuration: 0.3) {
      self.alpha = 0.0
    } completion: { _ in
      
      self.onDismiss?()
      self.removeFromSuperview()
    }
  }
  
  @objc private func onPhoneTap(_ sender: UITapGestureRecognizer) {
    self.onPhoneNumberTap?()
  }
}

fileprivate enum UIConstants {
  
  enum TipView {
    static let cornerRadius: CGFloat = 16.0
    
    static let bottomPadding: CGFloat = 14.0
    static let leftpadding: CGFloat = 60.0
    static let rightPadding: CGFloat = 13.0
    
    
		static let messageFont = UIFont.regularAppFont(of: 12)
    static let numberFont = UIFont.boldAppFont(of: 12.0)
    static let textColor = UIColor(named: "textDarkGreen")!.withAlphaComponent(0.7)
    static let textVerticalPadding: CGFloat = 10.0
    
    static let textInset: CGFloat = 16.0
  }
}


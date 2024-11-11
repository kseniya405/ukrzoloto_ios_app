//
//  CreditInfoTipView.swift
//  UkrZoloto
//
//  Created by Mykola on 27.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

protocol CreditInfoTipViewDelegate: AnyObject {
	func didTapOnActiveLabel(from: CreditInfoTipView)
}

class CreditInfoTipView: UIView {
  
  var onDismiss: (() -> Void)?
	var delegate: CreditInfoTipViewDelegate?
  private var clickedText: String?
  private var originRect: CGRect!
  private var tipView: UIView!
  private var message: String!
    
  private let messageLabel: ActiveLabel = {
		let label = ActiveLabel()
	label.config
		.font(UIConstants.messageFont)
		.textColor(UIConstants.textColor)
		.textAlignment(.justified)
		.numberOfLines(0)
	
	return label
}()
    
  convenience init(originRect: CGRect, message: String, clickedText: String? = nil) {
    self.init(frame: .zero)
    self.originRect = originRect
    self.message = message
		self.clickedText = clickedText
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

private extension CreditInfoTipView {
  
  func initConfigure() {
    backgroundColor = .clear
    isUserInteractionEnabled = true
  }
	
	func setActiveLabel(_ text: String, clickedText: String? = nil) {
		messageLabel.text = text
		messageLabel.setLineHeight(UIConstants.ActiveLabel.lineHeight)
		messageLabel.lineSpacing = -5
		guard let clickedText = clickedText else { return }
		messageLabel.customize { label in
			self.isUserInteractionEnabled = true
			let dataClickedType = ActiveType.custom(pattern: clickedText)
			label.customColor[dataClickedType] = UIConstants.ActiveLabel.selectedTextColor
			label.customSelectedColor[dataClickedType] = UIConstants.ActiveLabel.textColor
			label.handleCustomTap(for: dataClickedType, handler: { [weak self] _ in
				guard let self = self else { return }
				self.onOutsideTap()
				self.delegate?.didTapOnActiveLabel(from: self)
			})
			label.enabledTypes = [dataClickedType]
		}
	}
	  
  func displayInternal(container: UIView) {
    
    self.frame = container.bounds
    
    tipView = UIView()
    tipView.isUserInteractionEnabled = true
    tipView.backgroundColor = .white
    tipView.layer.cornerRadius = UIConstants.cornerRadius
    tipView.clipsToBounds = false
    
    tipView.addSubview(messageLabel)
    messageLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.textInset)
      make.trailing.equalToSuperview().offset(-UIConstants.textInset)
      make.top.equalToSuperview().offset(UIConstants.textInset)
      make.bottom.equalToSuperview().offset(-UIConstants.textInset)
    }
		setActiveLabel(message, clickedText: clickedText)
    messageLabel.sizeToFit()
    
    addSubview(tipView)
    tipView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.leftpadding)
      make.trailing.equalToSuperview().offset(-UIConstants.rightPadding)
    }
    
    if getDirection() == .up {
      
      tipView.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(originRect.maxY + UIConstants.bottomPadding)
      }
    } else {
      
      tipView.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(originRect.minY - UIConstants.bottomPadding - getMessageHeight() - UIConstants.textInset * 2)
      }
    }
        
    let view = UIView()
    view.backgroundColor = .white
    view.transform = CGAffineTransform(rotationAngle: .pi / 4)
    self.addSubview(view)
    view.snp.makeConstraints { make in
      make.centerX.equalTo(self.snp.leading).offset(originRect.midX)
      make.height.width.equalTo(16.0)
      
      if getDirection() == .up {
        make.top.equalTo(tipView.snp.top).offset(-8.0)
      } else {
        make.top.equalTo(tipView.snp.bottom).offset(-8.0)
      }
    }
    self.bringSubviewToFront(view)
    let outsideTap = UITapGestureRecognizer(target: self, action: #selector(onOutsideTap))
		outsideTap.delegate = self
    self.addGestureRecognizer(outsideTap)

    container.addSubview(self)
  }
  
  enum Direction {
    case up
    case down
  }
  
  private func getDirection() -> Direction {
    
    let maxheight = UIScreen.main.bounds.height - 34.0 // safe area bottom inset
    let height = getMessageHeight()
    
    if (maxheight - originRect.maxY - UIConstants.bottomPadding) > height {
      return .up
    } else {
      return .down
    }
  }
  
  private func getMessageHeight() -> CGFloat {
    
    let width = UIScreen.main.bounds.width -
    UIConstants.leftpadding -
    UIConstants.rightPadding -
    UIConstants.textInset * 2
    
    let font = UIConstants.messageFont
    
    let tipViewRect = (message as NSString).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).size
    
    return tipViewRect.height
  }
    
  @objc private func onOutsideTap() {
    
    UIView.animate(withDuration: 0.3) {
      self.alpha = 0.0
    } completion: { _ in
      
      self.onDismiss?()
      self.removeFromSuperview()
    }
  }
}

extension CreditInfoTipView: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		touch.view !== self.messageLabel
	}
}
  
private enum UIConstants {
  
	static let messageFont = UIFont.regularAppFont(of: 12)
  static let numberFont = UIFont.boldAppFont(of: 12.0)
  static let textColor = UIColor(named: "textDarkGreen")!.withAlphaComponent(0.7)
  static let textVerticalPadding: CGFloat = 10.0
  static let cornerRadius: CGFloat = 16.0

  static let bottomPadding: CGFloat = 14.0
  static let leftpadding: CGFloat = 20.0
  static let rightPadding: CGFloat = 53.0
  
  static let textInset: CGFloat = 16.0
	
	enum ActiveLabel {
		static let selectedTextColor = UIColor.color(r: 0, g: 80, b: 47)
		static let textColor = UIColor.color(r: 62, g: 76, b: 75)
		static let lineHeight: CGFloat = 18
		static let font = UIFont.regularAppFont(of: 13)
		static let numberOfLines: Int = 0
		
		static let top: CGFloat = 15
		static let bottom: CGFloat = 20
	}
}

//
//  GiftView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 9/30/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class GiftView: RoundedContainerView {

  // MARK: - Private variables
  private let segmentedControl = BetterSegmentedControl()
  private let indicatorLineView = UIView()

  private let senderView = GiftInfoView()
  private let recipientView = GiftInfoView()

  // MARK: - Init configure
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }

  private func configureSelf() {
    configureSegmentedControl()
    configureSenderView()
    configureRecipientView()
    showRecipientView()
  }

  private func configureSegmentedControl() {
    addHeaderSubview(segmentedControl)
    segmentedControl.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(UIConstants.SegmentedControl.inset)
      make.height.equalTo(UIConstants.SegmentedControl.height)
      make.top.bottom.equalToSuperview()
    }
    configureIndicatorLineView()
  }

  private func configureIndicatorLineView() {
    indicatorLineView.backgroundColor = UIConstants.SegmentedControl.indicatorColor
    indicatorLineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    indicatorLineView.layer.cornerRadius = UIConstants.SegmentedControl.indicatorCornerRadius
    segmentedControl.indicatorView.addSubview(indicatorLineView)
    indicatorLineView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.SegmentedControl.indicatorHeight)
    }
  }

  private func configureSenderView() {
    addSubview(senderView)
    senderView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func configureRecipientView() {
    addSubview(recipientView)
    recipientView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Interface
  func setTabTitles(_ titles: [String]) {
    let selectedSelectorIndicator = AligmentLabelSegment.SelectorIndicator(
      indicatorColor: UIConstants.SegmentedControl.indicatorColor,
      indicatorHeight: UIConstants.SegmentedControl.indicatorHeight,
      indicatorCornerRadius: UIConstants.SegmentedControl.indicatorCornerRadius
    )

    let segments = AligmentLabelSegment.segments(withTitles: titles,
                                                 normalFont: UIConstants.SegmentedControl.textFont,
                                                 normalTextColor: UIConstants.SegmentedControl.textColor,
                                                 selectedSelectorIndicator: selectedSelectorIndicator,
                                                 selectedFont: UIConstants.SegmentedControl.selectedTextFont,
                                                 selectedTextColor: UIConstants.SegmentedControl.selectedTextColor,
                                                 textAlignment: .center)

    segmentedControl.segments = segments
    segmentedControl.setOptions([.indicatorViewInset(0),
                                .panningDisabled(true)])
    segmentedControl.backgroundColor = Constants.AppColors.mainGreenColor
    segmentedControl.indicatorView.backgroundColor = Constants.AppColors.mainGreenColor
  }

  func getSegmentedControl() -> BetterSegmentedControl {
    return segmentedControl
  }
  
  func getSenderNameTextField() -> UITextField {
    return senderView.getNameTextField()
  }
  
  func getSenderPhoneTextField() -> UITextField {
    return senderView.getPhoneTextField()
  }
  
  func getSenderEmailTextField() -> UITextField {
    return senderView.getEmailTextField()
  }
  
  func getRecipientNameTextField() -> UITextField {
    return recipientView.getNameTextField()
  }
  
  func getRecipientPhoneTextField() -> UITextField {
    return recipientView.getPhoneTextField()
  }
  
  func getRecipientEmailTextField() -> UITextField {
    return recipientView.getEmailTextField()
  }
  
  func addSenderContinueButtonTarget(_ target: Any?,
                                     action: Selector,
                                     for event: UIControl.Event) {
    senderView.addContinueButtonTarget(target, action: action, for: event)
  }
  
  func addRecipientContinueButtonTarget(_ target: Any?,
                                        action: Selector,
                                        for event: UIControl.Event) {
    recipientView.addContinueButtonTarget(target, action: action, for: event)
  }
  
  func setRecipientContinueButtonEnabled(_ isEnabled: Bool) {
    recipientView.setButtonEnabled(isEnabled)
  }
  
  func setSenderContinueButtonEnabled(_ isEnabled: Bool) {
    senderView.setButtonEnabled(isEnabled)
  }
  
  func setRecipientContinueButtonTitle(_ title: String) {
    recipientView.setButtonTitle(title)
  }
  
  func setSenderContinueButtonTitle(_ title: String) {
    senderView.setButtonTitle(title)
  }
  
  func setRecipientPlaceholders(name: String?,
                                email: String?,
                                phone: String?) {
    recipientView.setNamePlaceholder(name)
    recipientView.setEmailPlaceholder(email)
    recipientView.setPhonePlaceholder(phone)
  }
  
  func setSenderPlaceholders(name: String?,
                             email: String?,
                             phone: String?) {
    senderView.setNamePlaceholder(name)
    senderView.setEmailPlaceholder(email)
    senderView.setPhonePlaceholder(phone)
  }
  

  func showSenderView() {
    segmentedControl.setIndex(1)
    senderView.isHidden = false
    recipientView.isHidden = true
  }

  func showRecipientView() {
    segmentedControl.setIndex(0)
    senderView.isHidden = true
    recipientView.isHidden = false
  }
  
  func setSelectedTabIndex(_ index: Int) {
    segmentedControl.setIndex(index, animated: true)
  }
  
  func updateBottomConstraint(offset: CGFloat, duration: Double) {
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else { return }
      self.senderView.snp.updateConstraints({ make in
        make.bottom.equalToSuperview()
          .inset(offset)
      })
      self.recipientView.snp.updateConstraints({ make in
        make.bottom.equalToSuperview()
          .inset(offset)
      })
    }
  }
  
}

private enum UIConstants {
  enum SegmentedControl {
    static let textColor = UIColor.color(r: 255, g: 255, b: 255, a: 0.6)
    static let textFont = UIFont.regularAppFont(of: 16)

    static let selectedTextColor = UIColor.white
    static let selectedTextFont = UIFont.boldAppFont(of: 16)

    static let inset: CGFloat = 24
    static let height: CGFloat = 51

    static let indicatorColor = UIColor.color(r: 255, g: 220, b: 136)
    static let indicatorCornerRadius: CGFloat = 4
    static let indicatorHeight: CGFloat = 4
  }
}

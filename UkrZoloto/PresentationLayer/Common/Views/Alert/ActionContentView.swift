//
//  ActionContentView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SnapKit

protocol ActionContentViewDelegate: AnyObject {
  func hideView()
}

class ActionContentView: BaseContentView {
  
  // MARK: - Public variables
  weak var delegate: ActionContentViewDelegate?
  
  var title: String? {
    didSet {
      guard let title = title
        else { return }
      
      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIConstants.TitleLabel.font
      ]
      
      titleLabel.textAlignment = .center
      titleLabel.attributedText = NSAttributedString(string: title,
                                                     attributes: attributes)
    }
  }
  
  var subtitle: String? {
    didSet {
      subtitleLabel.text = subtitle
    }
  }
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(0)
      .textAlignment(.center)
      .textColor(UIConstants.TitleLabel.color)
    
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  private var panableView = PanableView()
  private var bottomConstraint: Constraint?
  private var actions = [UIButton: (() -> Void)]()
  private let radioController = RadioController()
  private var lastAction: UIButton?
  private let isSubtitleAvailable: Bool
  
  init(isSubtitleAvailable: Bool) {
    self.isSubtitleAvailable = isSubtitleAvailable
    super.init(frame: .zero)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    isSubtitleAvailable = false
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.color
    layer.cornerRadius = UIConstants.SelfView.cornerRadius
    layout()
  }
  
  private func layout() {
    super.addSubview(titleLabel)
    if isSubtitleAvailable {
      super.addSubview(subtitleLabel)
    }
    super.addSubview(panableView)
    makeConstraints()
  }
  
  private func makeConstraints() {
    configPanableView()
    configTitleLabel()
    if isSubtitleAvailable {
      configSubtitleLabel()
    }
  }
  
  private func configPanableView() {
    panableView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.PanableView.height)
      make.top.equalToSuperview()
        .offset(UIConstants.PanableView.top)
      make.centerX.equalToSuperview()
      make.width.equalTo(UIConstants.PanableView.width)
    }
  }
  
  private func configTitleLabel() {
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(panableView.snp.bottom)
        .offset(UIConstants.TitleLabel.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.TitleLabel.leading)
      make.centerX.equalToSuperview()
      bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
          .inset(UIConstants.TitleLabel.bottom).constraint

    }
  }
  
  private func configSubtitleLabel() {
    bottomConstraint?.deactivate()
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.SubtitleLabel.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.SubtitleLabel.leading)
      make.centerX.equalToSuperview()
      bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
          .inset(UIConstants.SubtitleLabel.bottom).constraint

    }
  }
  
  private func createActionButton(action: AlertAction) -> UIButton {
    let actionButton = RadioButton()
    switch action.style {
    case .filled:
      actionButton.buttonState = .active
    case .unfilled:
      actionButton.buttonState = .inactive
    case .unfilledGreen:
      actionButton.buttonState = .inactiveGreen
    }
    actionButton.titleLabel?.font = action.isEmphasized ? UIConstants.Action.boldFont : UIConstants.Action.normalFont
    actionButton.setTitle(action.title, for: .normal)
    actions[actionButton] = action.completion
    radioController.buttons.append(actionButton)
    actionButton.addTarget(self,
                           action: #selector(didTapOnButton(_:)),
                           for: .touchUpInside)
    return actionButton
  }
  
  private func configNewAction(action: AlertAction) {
    let button = createActionButton(action: action)
    addSubview(button)
    bottomConstraint?.deactivate()
    button.snp.makeConstraints { make in
      if let lastButton = lastAction {
        make.top.equalTo(lastButton.snp.bottom)
          .offset(UIConstants.Action.top)
      } else {
        make.top.equalTo((isSubtitleAvailable ? subtitleLabel : titleLabel).snp.bottom)
          .offset(UIConstants.Action.firstActionTop)
      }
      make.leading.equalToSuperview()
        .offset(UIConstants.Action.leading)
      make.centerX.equalToSuperview()
      bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
          .inset(UIConstants.Action.bottom).constraint
      make.height.equalTo(UIConstants.Action.height)
    }
    lastAction = button
  }
  
  func addAction(_ action: AlertAction) {
    configNewAction(action: action)
  }
  
  @objc private func didTapOnButton(_ sender: RadioButton) {
    radioController.selectButton(sender)
    actions[sender]?()
    delegate?.hideView()
  }
  
}

private enum UIConstants {
  struct SelfView {
    static let color: UIColor = .white
    static let cornerRadius: CGFloat = 16
  }
  
  struct PanableView {
    static let height = 4
    static let top: CGFloat = 16
    static let width: CGFloat = 47
  }
  
  struct TitleLabel {
    static let top = 24
    static let leading = 24
    static let bottom = 100
    static let font = UIFont.boldAppFont(of: 20)
    static let color = UIColor.color(r: 62, g: 76, b: 75)
  }
  
  struct SubtitleLabel {
    static let leading = 40
    static let top = 26
    static let bottom = 100
    static let fontSize: CGFloat = 16
    static let textColor: UIColor = .color(r: 0, g: 0, b: 0)
    static let alignment: NSTextAlignment = .center
  }
  
  struct Action {
    static let firstActionTop = 32
    static let top = 10
    static let leading = 32
    static let height = 46
    static let bottom = 45
    
    static let normalFont = UIFont.regularAppFont(of: 16)
    static let boldFont = UIFont.boldAppFont(of: 14)
  }
  
}

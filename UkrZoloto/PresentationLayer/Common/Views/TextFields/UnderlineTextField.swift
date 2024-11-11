//
//  UnderlineTextField.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SnapKit

protocol UnderlineTextInput {
  func setUnderlineColor(_ color: UIColor, animated: Bool)
  func setError(_ error: String?)
  func hideError()
  func setHelper(_ text: String?)
  func hideHelper()
}

class UnderlinedTextField: FloatingTextField, UnderlineTextInput {
  
  // MARK: - Private variables
  private var underlineView = UIView()
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initConfigure()
  }
  
  override func becomeFirstResponder() -> Bool {
    setUnderlineColor(showingError ?
                        UIConstants.UnderlineView.errorColor :
                        UIConstants.UnderlineView.activeColor)
    return super.becomeFirstResponder()
  }
  
  override func resignFirstResponder() -> Bool {
    setUnderlineColor(showingError ?
                        UIConstants.UnderlineView.errorColor :
                        UIConstants.UnderlineView.inactiveColor)
    return super.resignFirstResponder()
  }
  
  // MARK: - UnderlineTextInput
  func setUnderlineColor(_ color: UIColor, animated: Bool = true) {
    if animated {
      UIView.animate(withDuration: UIConstants.Animation.duration) { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.updateUnderlineView(color: color)
      }
    } else {
      updateUnderlineView(color: color)
    }
  }
  
  func setError(_ error: String?) {
    errorText = error
    if !error.isNilOrEmpty {
      hideHelper()
    }
    setUnderlineColor(UIConstants.UnderlineView.errorColor)
  }
  
  func hideError() {
    errorText = nil
    setUnderlineColor(isFirstResponder ? UIConstants.UnderlineView.activeColor : UIConstants.UnderlineView.inactiveColor)
  }
  
  func setHelper(_ text: String?) {
    helperText = text
    if !text.isNilOrEmpty {
      hideError()
    }
  }
  
  func hideHelper() {
    helperText = nil
  }
  
  // MARK: - Private
  private func initConfigure() {
    setupStyle()
    configureUnderlineView()
  }
  
  private func setupStyle() {
    borderStyle = .none
    backgroundColor = .clear
    textAlignment = .left
    adjustsFontSizeToFitWidth = false
    doneAccessory = true
  }
  
  private func configureUnderlineView() {
    addSubview(underlineView)
    underlineView.backgroundColor = UIConstants.UnderlineView.inactiveColor
    underlineView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.UnderlineView.height)
    }
  }
  
  private func updateUnderlineView(color: UIColor) {
    underlineView.backgroundColor = color
  }
  
}

// MARK: - UI constants
private enum UIConstants {
  enum Animation {
    static let duration: TimeInterval = 0.2
  }
  
  enum UnderlineView {
    static let height = 1
    static let inactiveColor = UIColor.color(r: 230, g: 230, b: 230)
    static let activeColor = UIColor.color(r: 62, g: 76, b: 75)
    static let errorColor = UIColor.color(r: 255, g: 95, b: 95)
  }
  
}

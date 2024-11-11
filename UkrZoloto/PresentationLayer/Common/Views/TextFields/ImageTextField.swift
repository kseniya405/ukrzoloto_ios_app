//
//  ImageTextField.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 10.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SnapKit

enum ImageTextFieldType {
  case bonuses
  case promocode
}

protocol ImageTextInput {
  func setImage(_ image: UIImage?)
}

class ImageTextField: UnderlinedTextField, ImageTextInput {
  
  // MARK: - Public variables
  var type: ImageTextFieldType = .bonuses
  
  var buttonAction: (() -> Void)?
  
  // MARK: - Private variables
  private var rightButton = UIButton()
  
  // MARK: - Life cycle
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
  
  override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.width - UIConstants.Button.side - UIConstants.Button.trailingInset,
                  y: (bounds.height - UIConstants.Button.side) / 2,
                  width: UIConstants.Button.side + UIConstants.Button.trailingInset,
                  height: UIConstants.Button.side)
  }
  
  // MARK: - ImageTextInput
  func setImage(_ image: UIImage?) {
    rightButton.isHidden = image == nil
    rightButton.setImage(image, for: .normal)
    rightButton.contentMode = .scaleAspectFit
    
    rightView = configureRightView()
  }
  
  // MARK: - Private
  private func initConfigure() {
    setupStyle()
    _ = resignFirstResponder()
  }
  
  private func setupStyle() {
    borderStyle = .none
    backgroundColor = .clear
    textAlignment = .left
    adjustsFontSizeToFitWidth = false
    rightViewMode = .always
    setupRightButton()
  }
  
  private func setupRightButton() {
    rightButton.addTarget(self,
                          action: #selector(didTapOnButton),
                          for: .touchUpInside)
  }
  
  private func configureRightView() -> UIView {
    let viewRight = UIView(frame: CGRect(x: 0,
                                         y: 0,
                                         width: UIConstants.Button.side + UIConstants.Button.trailingInset,
                                         height: UIConstants.Button.side))
    viewRight.addSubview(rightButton)
    
    rightButton.snp.makeConstraints { make in
      make.width.height.equalTo(UIConstants.Button.side)
      make.top.equalToSuperview()
      make.trailing.equalToSuperview()
        .inset(UIConstants.Button.trailingInset)
    }
    
    return viewRight
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnButton() {
    buttonAction?()
  }
  
}

// MARK: - UI constants
private enum UIConstants {
  enum Button {
    static let side: CGFloat = 24
    static let trailingInset: CGFloat = 0
  }
}

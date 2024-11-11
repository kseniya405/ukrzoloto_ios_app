//
//  UnderlineTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/11/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol UnderlineTableViewCellDelegate: DatePickerBottomViewDelegate {
  func shouldBeginEditingTextField(in cell: UnderlineTableViewCell) -> Bool
  func shouldChangeCharactersIn(_ textField: UITextField,
                                range: NSRange,
                                replacementString string: String,
                                in cell: UnderlineTableViewCell) -> Bool
  func textDidChanged(newText: String?,
                      in cell: UITableViewCell)
}

class UnderlineTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: UnderlineTableViewCellDelegate? {
    didSet {
      datePicker.delegate = delegate
    }
  }
  
  // MARK: - Private variables
  let textField = ImageTextField()
  
  private let datePicker = DatePickerBottomView(frame: UIConstants.DatePicker.frame)
  
  private var profileData: ProfileData?
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initConfigure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initConfigure()
  }
  
  private func initConfigure() {
    selectionStyle = .none
    configureTextField()
  }
  
  private func configureTextField() {
    contentView.addSubview(textField)
    textField.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.TextField.top)
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.TextField.insets)
      make.height.equalTo(UIConstants.TextField.height)
      make.bottom.equalToSuperview()
    }
    textField.setUnderlineColor(UIConstants.TextField.underlineColor)
    textField.font = UIConstants.TextField.font
    textField.textColor = UIConstants.TextField.textColor
    textField.delegate = self
    textField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
  }
  
  @discardableResult
  override func resignFirstResponder() -> Bool {
    return textField.resignFirstResponder()
  }
  
  // MARK: - Interface
  func configure(profileData: ProfileData) {
    self.profileData = profileData
    let viewModel = profileData.vm
    textField.placeholder = viewModel.placeholder
    textField.setHelper(viewModel.description)
    
    if viewModel.placeholder == "E-mail" {
      textField.keyboardType = .emailAddress
    }
    
    if !viewModel.text.isNilOrEmpty {
      textField.text = viewModel.text
    } else {
      textField.text = nil
    }
    
    if profileData.isDate {
      if let date = DateFormattersFactory.dateOnlyFormatter().date(from: profileData.vm.text ?? "") {
        datePicker.setDate(date)
      }
      configureDateTextField(profileData)
    } else {
      textField.inputView = nil
    }
    
    if let image = viewModel.image {
      let imageView = UIImageView()
      imageView.setImage(from: image)
      textField.setImage(imageView.image ?? UIImage())
      
      if profileData.isDate {
        textField.buttonAction = { [weak self] in
          let _ = self?.textField.becomeFirstResponder()
        }
      }
      
    } else {
      textField.setImage(UIImage())
    }
  }
  
  func setError() {
    textField.setError(profileData?.vm.error)
  }
  
  func hideError() {
    textField.hideError()
  }
    
  // MARK: - Private
  private func configureDateTextField(_ profileData: ProfileData) {
    textField.inputView = datePicker
    
  }
  
  @objc
  private func textDidChanged() {
    delegate?.textDidChanged(newText: textField.text, in: self)
  }
}

// MARK: - UITextFieldDelegate
extension UnderlineTableViewCell: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    let shouldBegin = delegate?.shouldBeginEditingTextField(in: self) ?? true
    defer {
      if !shouldBegin {
        resignFirstResponder()
      }
    }
    return shouldBegin
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    return delegate?.shouldChangeCharactersIn(textField,
                                              range: range,
                                              replacementString: string,
                                              in: self) ?? true
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum TextField {
    static let insets: CGFloat = 24
    static let top: CGFloat = 5
    static let height: CGFloat = 50
    
    static let underlineColor = UIColor.color(r: 230, g: 230, b: 230)
    static let font = UIFont.boldAppFont(of: 16)
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
  }
  enum DatePicker {
    static let height: CGFloat = 277
    static let frame = CGRect(x: 0, y: 0, width: Constants.Screen.screenWidth,
                              height: UIConstants.DatePicker.height)
  }
}

//
//  NameController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 10/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol ValidateControllerDelegate: AnyObject {
  func didTextFieldWasChanged(_ textField: UITextField?, with type: Validator.ValidatorType)
  func didEndEditing(_ textField: UITextField)
  func textFieldWillReturn(_ textField: UITextField)
}

class ValidateController: NSObject {
  
  // MARK: - Public
  weak var delegate: ValidateControllerDelegate?
  
  // MARK: - Private
  private weak var textField: UITextField?
  private var type: Validator.ValidatorType
  
  // MARK: - Life cycle
  init(textField: UITextField, type: Validator.ValidatorType) {
    self.textField = textField
    self.type = type
    super.init()

    self.textField?.addTarget(
      self,
      action: #selector(textFieldDidChanged),
      for: .editingChanged)
    self.textField?.delegate = self
  }
  
  // MARK: - Interface
  func setPlaceholder(_ placeholder: String?) {
    textField?.placeholder = placeholder
  }
  
  func getText() -> String? {
    if Validator.isValidString(textField?.text, ofType: type) {
      return textField?.text
    } else {
      return nil
    }
  }
  
  // MARK: - Actions
  @objc private func textFieldDidChanged() {
    delegate?.didTextFieldWasChanged(textField, with: type)
  }
  
}

// MARK: - UITextFieldDelegate
extension ValidateController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    if let newString = newString {
      let allowedSymbolsOnly = string.rangeOfCharacter(from: Validator.allowedCharacterSet(for: type).inverted) == nil
      switch type {
      case .name, .surname:
        if  newString.count <= Validator.maxSymbolsCount(for: type),
          allowedSymbolsOnly,
          let firstCharacter = newString.first,
          firstCharacter.isLowercase {
          textField.text = newString.capitalized
          return false
        }
      default: break
      }
      return newString.count <= Validator.maxSymbolsCount(for: type) && allowedSymbolsOnly
    }
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    delegate?.textFieldWillReturn(textField)
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    switch reason {
    case .committed:
      delegate?.didEndEditing(textField)
    default:
      break
    }
  }
}

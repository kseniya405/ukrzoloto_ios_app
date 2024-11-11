//
//  EmailController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol EmailControllerDelegate: AnyObject {
  func didChangeEmail()
}

class EmailController: NSObject {

  // MARK: - Public
  weak var delegate: EmailControllerDelegate?
  
  // MARK: - Private
  private weak var textField: UITextField?
  
  // MARK: - Life cycle
  init(textField: UITextField) {
    super.init()
    self.textField = textField
    self.textField?.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    self.textField?.delegate = self
  }
  
  // MARK: - Interface
  func setPlaceholder(_ placeholder: String?) {
    textField?.placeholder = placeholder
  }
  
  func getEmail() -> String? {
    if Validator.isValidString(textField?.text, ofType: .email) {
      return textField?.text
    } else {
      return nil
    }
  }
  
  // MARK: - Actions

  @objc private func textFieldDidChanged() {
    delegate?.didChangeEmail()
  }
}

extension EmailController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    if let newString = newString {
      let allowedSymbolsOnly = string.rangeOfCharacter(from: Validator.allowedCharacterSet(for: .email).inverted) == nil
      return newString.count <= Validator.maxSymbolsCount(for: .email) && allowedSymbolsOnly
    }
    return true
  }
}

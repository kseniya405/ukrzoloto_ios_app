//
//  PhoneNumberController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS

protocol PhoneNumberControllerDelegate: AnyObject {
  func didChangePhone()
  func textFieldWillReturn(_ textField: UITextField)
  func didEndEditing(_ textField: UITextField)
}

class PhoneNumberController: NSObject {
  
  // MARK: - Public
  weak var delegate: PhoneNumberControllerDelegate?
  
  // MARK: - Private
  private weak var textField: UITextField?
  private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
  private var nbPhoneNumber: NBPhoneNumber?
  private var formatter: NBAsYouTypeFormatter
  private var prefix = UIConstants.phonePrefix
  
  // MARK: - Life cycle
  init(textField: UITextField) {
    formatter = NBAsYouTypeFormatter(regionCode: "UA")
    super.init()
    self.textField = textField
    self.textField?.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    self.textField?.delegate = self
  }
  
  // MARK: - Configure
  
  // MARK: - Actions
  func getRawPhoneNumber() -> String {
    if let number = textField?.text {
      return clean(string: number)
    }
    return ""
  }
  
  func getFormattedPhoneNumber() -> String? {
    return try? phoneUtil.format(nbPhoneNumber, numberFormat: NBEPhoneNumberFormat.INTERNATIONAL)
  }
  
  func set(phoneNumber: String) {
    var cleanedPhoneNumber = clean(string: phoneNumber)
    let withPlusPrefix = "+" + cleanedPhoneNumber
    if getValidNumber(phoneNumber: cleanedPhoneNumber) == nil && getValidNumber(phoneNumber: withPlusPrefix) != nil {
      cleanedPhoneNumber = withPlusPrefix
    }
    guard cleanedPhoneNumber.hasPrefix(prefix) else { return }
    
    if let validPhoneNumber = getValidNumber(phoneNumber: cleanedPhoneNumber) {
      if validPhoneNumber.italianLeadingZero {
        textField?.text = "0\(validPhoneNumber.nationalNumber.stringValue)"
      } else {
        didEditText("+\(validPhoneNumber.countryCode.stringValue)\(validPhoneNumber.nationalNumber.stringValue)")
      }
    }
  }
  
  func setPhonePrefix(_ prefix: String) {
    self.prefix = prefix
    textField?.text = prefix
  }
  
  func setPlaceholder(_ placeholder: String?) {
    textField?.placeholder = placeholder
  }
  
  private func didEditText(_ text: String?) {
    if let number = text {
      var cleanedPhoneNumber = clean(string: number)
      
      if let validPhoneNumber = getValidNumber(phoneNumber: cleanedPhoneNumber) {
        nbPhoneNumber = validPhoneNumber
        cleanedPhoneNumber = "+\(validPhoneNumber.countryCode.stringValue)\(validPhoneNumber.nationalNumber.stringValue)"
        
        if let inputString = formatter.inputString(cleanedPhoneNumber) {
          textField?.text = inputString
        }
      } else {
        nbPhoneNumber = nil
        if !cleanedPhoneNumber.hasPrefix("+") {
          cleanedPhoneNumber = "+" + cleanedPhoneNumber
        }
        if let inputString = formatter.inputString(cleanedPhoneNumber) {
          textField?.text = inputString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
      }
    }
  }
  
  private func clean(string: String) -> String {
    let hasPlusPrefix = string.hasPrefix("+")
    let allowedCharactersSet = CharacterSet.decimalDigits
    var cleanedString = string.components(separatedBy: allowedCharactersSet.inverted).joined(separator: "")
    if hasPlusPrefix {
      cleanedString = "+" + cleanedString
    }
    return cleanedString
  }
  
  private func getValidNumber(phoneNumber: String) -> NBPhoneNumber? {
    do {
      let parsedPhoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion: "")
      let isValid = phoneUtil.isValidNumber(parsedPhoneNumber)
      
      return isValid ? parsedPhoneNumber : nil
    } catch {
      return nil
    }
  }
  
  @objc private func textFieldDidChanged() {
    didEditText(textField?.text)
    delegate?.didChangePhone()
  }
}

extension PhoneNumberController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    var cleanedPhoneNumber = clean(string: newString)
    if !cleanedPhoneNumber.hasPrefix("+") {
      cleanedPhoneNumber = "+" + cleanedPhoneNumber
    }
    return newString.hasPrefix(prefix) && cleanedPhoneNumber.count <= UIConstants.maxSymbolsCount
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

private enum UIConstants {
  static let phonePrefix = "+380"
  static let maxSymbolsCount = 13
}

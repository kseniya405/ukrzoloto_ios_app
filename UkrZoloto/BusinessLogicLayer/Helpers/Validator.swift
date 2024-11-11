//
//  Validator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

class Validator {
  
  enum ValidatorType {
    case email
    case price
    case event
    case name
    case surname
    case street
    case house
    case apartment
    case bonuses
    case promocode
  }
  
  static var latinAlphabetSet: CharacterSet {
    let latinSmallAlphabet = UInt32("a")...UInt32("z")
    let latinBigAlphabet = UInt32("A")...UInt32("Z")
    var string = String(String.UnicodeScalarView(latinSmallAlphabet.compactMap(UnicodeScalar.init)))
    string += String(String.UnicodeScalarView(latinBigAlphabet.compactMap(UnicodeScalar.init)))
    return CharacterSet(charactersIn: string)
  }
    
  static var spaceAlphanumericsSet: CharacterSet {
    var set = CharacterSet.letters
    set.insert(charactersIn: " ")
    return set
  }
  
  static func shouldChangeText(_ string: String?, for type: ValidatorType) -> Bool {
    return isValidString(string, ofType: type) || string.isNilOrEmpty
  }
  
  static func isValidString(_ string: String?, ofType type: ValidatorType) -> Bool {
    switch type {
    case .email:
      guard let string = string else { return false }
      return RegexService.shared.isValidEmail(string)
    case .price:
      return true
    case .event:
      return true
    case .name,
         .surname:
      guard let string = string,
        !string.trim().isEmpty else { return false }
      let allowedSymbolsOnly = string.rangeOfCharacter(from: Validator.allowedCharacterSet(for: type).inverted) == nil
      return string.count <= Validator.maxSymbolsCount(for: .name) && allowedSymbolsOnly
    case .street, .house:
      return !(string?.trim().isEmpty ?? true)
    case .apartment:
      return true
    case .bonuses:
      return true
    case .promocode:
      return true
    }
  }
  
  static func allowedCharacterSet(for type: ValidatorType) -> CharacterSet {
    switch type {
    case .email:
      var set = latinAlphabetSet
      set.formUnion(CharacterSet.decimalDigits)
      set.insert(charactersIn: "!#$%&'*+-/=?^_`{|}~;@ .")
      return set
    case .price:
      let set = CharacterSet.decimalDigits
      return set
    case .event:
      return spaceAlphanumericsSet
    case .name, .surname,
         .house, .apartment:
      var set = spaceAlphanumericsSet
      set.formUnion(CharacterSet.decimalDigits)
      return set
    case .street:
      return spaceAlphanumericsSet
    case .bonuses:
      return CharacterSet.decimalDigits
    case .promocode:
      var set = CharacterSet.alphanumerics
      set.insert(charactersIn: "!#$%&'*+-/=?^_`{|}~;@ .")
      return set
    }
  }
  
  static func maxSymbolsCount(for type: ValidatorType) -> Int {
    switch type {
    case .email:
      return 64
    case .price:
      return 7
    case .event:
      return 64
    case .name:
      return 30
    case .surname:
      return 30
    case .street:
      return 100
    case .house:
      return 10
    case .apartment:
      return 10
    case .bonuses:
      return 6
    case .promocode:
      return 20
    }
  }
}

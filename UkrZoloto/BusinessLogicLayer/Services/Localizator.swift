//
//  Localizator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

class Localizator {
  
  // MARK: - Public variables
  static let standard = Localizator(stringsFileName: "Localizable",
                                    stringsDictFileName: "LocalizableDict")
  
  // MARK: - Private variables
  private let stringsFileName: String?
  private let stringsDictFileName: String?
  private let appLanguageStorage: LocalizationStorage
  
  // MARK: - Life cycle
  init(stringsFileName: String? = nil,
       stringsDictFileName: String? = nil,
       appLanguageStorage: LocalizationStorage = LocalizationService.shared) {
    self.appLanguageStorage = appLanguageStorage
    self.stringsFileName = stringsFileName
    self.stringsDictFileName = stringsDictFileName
  }
  
  // MARK: - Public
  func localizedString(_ string: String, _ args: CVarArg...) -> String {
    let bundle = getBundle()
    let defaultString = "*\(string)"
    
    let stringsLocalizedString = searchInStrings(
      translateString: string, defaultString: defaultString, bundle: bundle)
    
    let stringsFound = stringsLocalizedString != defaultString
    if stringsFound {
      return String(format: stringsLocalizedString, arguments: args)
    }
    
    let stringsDictLocalizedString = searchInStringsDict(
      translateString: string, defaultString: defaultString, bundle: bundle)
    return String(format: stringsDictLocalizedString, arguments: args)
  }
  
  // MARK: - Searching in localization files
  private func searchInStrings(translateString: String, defaultString: String, bundle: Bundle) -> String {
    return NSLocalizedString(translateString,
                             tableName: stringsFileName,
                             bundle: bundle,
                             value: defaultString,
                             comment: "")
  }
  
  private func searchInStringsDict(translateString: String, defaultString: String, bundle: Bundle) -> String {
    return NSLocalizedString(translateString,
                             tableName: stringsDictFileName ?? stringsFileName,
                             bundle: bundle,
                             value: defaultString,
                             comment: "")
  }
  
  // MARK: - Bundle finding
  private func getBundle() -> Bundle {
    let defaultBundle = Bundle.main
    let languageCode = appLanguageStorage.language.languageCode
    guard let bundlePath = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
      return defaultBundle
    }
    return Bundle(path: bundlePath) ?? Bundle.main
  }
}

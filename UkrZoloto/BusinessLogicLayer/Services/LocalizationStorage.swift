//
//  LocalizationStorage.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Localize_Swift

protocol LocalizationStorage {
  var language: AppLanguage { get set }
}

class LocalizationService: LocalizationStorage {
  // MARK: Singleton
  static let shared = LocalizationService()
  
  // MARK: - Public
  var language: AppLanguage {
    get {
      let languageCode = UserDefaults.standard.string(forKey: LocalizationService.languageUserDefaultsKey)
      if let languageCodeUnwrapped = languageCode {
        return AppLanguage.language(withCode: languageCodeUnwrapped)
      } else {
        save(language: LocalizationService.defaultLanguage)
        return AppLanguage.language(withCode: LocalizationService.defaultLanguage)
      }
    }
    set {
      guard newValue != language else { return }
      save(language: newValue.code)
      Localize.setCurrentLanguage(newValue.languageCode)
    }
  }
  
  // MARK: - Life cycle
  private init() {
    UserDefaults.standard.setValue([language.languageCode], forKeyPath: "AppleLanguages")
    setup()
  }
  
  // MARK: Setup
  private func setup() {
    Localize.setCurrentLanguage(language.languageCode)
  }
  
}

// MARK: - Private
extension LocalizationService {
  private static let defaultLanguage = AppLanguage.ISO639Alpha2.ukrainian
  private static let languageUserDefaultsKey = "languageUserDefaultsKey"
  
  private func save(language: String) {
    UserDefaults.standard.set(language, forKey: LocalizationService.languageUserDefaultsKey)
  }
}

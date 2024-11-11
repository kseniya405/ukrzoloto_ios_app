//
//  AppLanguage.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

class AppLanguage {
  // MARK: - Public variables
  var code: String //ISO 639-1
  var nativeName: String
  var languageCode: String {
    return Locale(identifier: code).languageCode ?? code
  }
  
  // MARK: - Life cycle
  private init() {
    self.code = ""
    self.nativeName = ""
  }
  
  private init(code: String, nativeName: String) {
    self.code = code
    self.nativeName = nativeName
  }
  
  // MARK: - Languages
  static var list: [AppLanguage] {
    var list: [AppLanguage] = []
    for code in AppLanguage.codes {
      list.append(AppLanguage.language(withCode: code))
    }
    return list
  }
  
  static var codes: [String] {
    return [AppLanguage.ISO639Alpha2.russian,
            AppLanguage.ISO639Alpha2.ukrainian]
  }
  
  // MARK: - ISO 639-1 Languge codes
  struct ISO639Alpha2 {
    static let russian = "ru_RU"
    static let ukrainian = "uk_UA"
  }
  
  // MARK: - Factory method
  static func language(withCode code: String) -> AppLanguage {
    var language: AppLanguage
    switch code {
    case AppLanguage.ISO639Alpha2.russian:
      language = AppLanguage(code: code, nativeName: "RU")
    case AppLanguage.ISO639Alpha2.ukrainian:
      language = AppLanguage(code: code, nativeName: "UA")
    default:
      fatalError("Language with code \(code) is not supported")
    }
    return language
  }
}

// MARK: - Equatable
extension AppLanguage: Equatable {
  static func == (lhs: AppLanguage, rhs: AppLanguage) -> Bool {
    return lhs.code == rhs.code
  }
}

//
//  ServerError.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ServerErrorType: Int {
  // common
  case unauthorized = 400
  case refreshToken = 401
  case unknown = -10000
  case noInternetConnection = -10001
  
  case serverError = 500
  case smsLimit = 403
  case waitForNextSms = 429
}

struct ServerError: Error {
  var title: String
  var description: String
  var type: ServerErrorType
  var newToken: String?
  
  init?(type: Int, json: JSON, newToken: String? = nil) {
    guard let dictionary = json.dictionary,
      let description = dictionary[NetworkResponseKey.Error.detail]?.string else {
        return nil
    }
    let title = dictionary[NetworkResponseKey.Error.title]?.string ?? ServerError.unknown.title
    self.type = ServerErrorType(rawValue: type) ?? .unknown
    if type == 400 ||
      (type == ServerErrorType.refreshToken.rawValue && newToken.isNilOrEmpty) {
      self.type = ServerErrorType.unauthorized
    }
    self.title = title
    self.description = description
    self.newToken = newToken
  }
  
  init?(json: JSON) {
    guard let dictionary = json.dictionary,
      let type = dictionary[NetworkResponseKey.Error.code]?.int else {
        return nil
    }
    self.init(type: type, json: json)
  }
  
  init(type: ServerErrorType, title: String, description: String) {
    self.title = title
    self.description = description
    self.type = type
  }
  
  static var unknown: ServerError {
    return ServerError(type: .unknown,
                       title: Localizator.standard.localizedString("Ошибка"),
                       description: Localizator.standard.localizedString("Что-то пошло не так. Повторите попытку позже."))
  }
  
  static var noInternetConnection: ServerError {
    return ServerError(type: .noInternetConnection,
                       title: Localizator.standard.localizedString("Ошибка"),
                       description: Localizator.standard.localizedString("Потеряно интернет соединение. Повторите попытку позже."))
  }
  
  static var unauthorized: ServerError {
    return ServerError(type: .unauthorized,
                       title: Localizator.standard.localizedString("Ошибка"),
                       description: Localizator.standard.localizedString("Ошибка аутентификация пользователя. Войдите в систему повторно"))
  }
  
}

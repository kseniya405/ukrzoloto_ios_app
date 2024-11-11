//
//  ErrorAlertDisplayable.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 11/4/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol ErrorsAlerts: AnyObject {
  func cantAddToFavorite(onCancel: @escaping () -> Void, onSuccess: @escaping () -> Void)
}

protocol ErrorAlertDisplayable: ErrorHandlable, AlertDisplayable, ErrorsAlerts, HintDisplayable {}

extension ErrorAlertDisplayable {
  func handleError(_ error: Error) {
    if let serverError = error as? ServerError {
      let isAutorized = checkAuthorized(error)
      if isAutorized {
        showAlert(title: serverError.title,
                  subtitle: serverError.description)
      } else {
        showUnauthorizedErrorAlert(serverError)
      }
    } else {
      showAlert(title: Localizator.standard.localizedString("Ошибка"),
                subtitle: error.localizedDescription)
    }
  }
  
  @discardableResult
  func checkAuthorized(_ error: Error?) -> Bool {
    guard let error = error as? ServerError else { return true }
    let isNeedToRefreshToken = error.type == .refreshToken &&
      !error.newToken.isNilOrEmpty
    return error.type != .unauthorized && !isNeedToRefreshToken
  }

  func cantAddToFavorite(onCancel: @escaping () -> Void, onSuccess: @escaping () -> Void) {
    let loginAlert = AlertAction(style: .filled,
                                 title: Localizator.standard.localizedString("Войти / Зарегистрироваться").uppercased(),
                                 isEmphasized: true) {
      onSuccess()
    }
    let cancelAlert = AlertAction(style: .unfilledGreen,
                                  title: Localizator.standard.localizedString("Отмена").uppercased(),
                                  isEmphasized: true) {
      onCancel()
    }
    showAlert(title: Localizator.standard.localizedString("Невозможно добавить товар в Избранное"),
              subtitle: Localizator.standard.localizedString("Чтобы добавить товар в список желаний нужно войти или зарегистрироваться в приложении"),
              actions: [cancelAlert, loginAlert])
  }
  
  // MARK: - Private
  private func showUnauthorizedErrorAlert(_ error: ServerError) {
    showAlert(
      title: error.title,
      subtitle: error.description) {
        ProfileService.shared.resetUser()
        NotificationCenter.default.post(
          name: .userWasLoggedOut, object: nil)
    }
  }
}

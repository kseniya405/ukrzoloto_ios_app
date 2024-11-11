//
//  ProfileService.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import KeychainAccess
import FirebaseAppCheck
import FirebaseAnalytics

class ProfileService {
  
  // MARK: - Public variables
  static let shared = ProfileService()
  
  // MARK: - Private variables
  private(set) var token: JWTToken? {
    willSet {
      keychain[Constants.Keychain.token] = newValue
    }
  }
  
  private(set) var userId: UserID? {
    willSet {
      if let newValue = newValue {
        keychain[Constants.Keychain.userId] = "\(newValue)"
					Analytics.setDefaultEventParameters(["user_id": "\(newValue)"])
					Analytics.setUserID("\(newValue)")
      } else {
        keychain[Constants.Keychain.userId] = nil
				Analytics.setDefaultEventParameters(["user_id": ""])
				Analytics.setUserID("")
      }
    }
  }
  
  var pushToken: String? {
    willSet {
      guard pushToken != newValue else { return }
      keychain[Constants.Keychain.pushTokenKey] = newValue
    }
  }

  func discountValue() -> Int {
    guard let goldenDiscount = self.user?.goldDiscount, goldenDiscount != 0 else {
      return 3
    }

    return goldenDiscount
  }
  
  private(set) var user: User? {
    get {
      return fetchedUser
    }
    set {
      if let newUser = newValue {
        fetchedUser = newUser
        CoreDataService.shared.save(user: newUser) { _ in }
        NotificationCenter.default.post(name: .userWasUpdated,
                                        object: nil,
                                        userInfo: [Notification.Key.updatedUser: newUser])
      } else {
        fetchedUser = nil
        CoreDataService.shared.clearUserData { _ in }
        NotificationCenter.default.post(name: .userWasUpdated,
                                        object: nil,
                                        userInfo: nil)
      }
    }
  }
  
  // MARK: - Private variables
  private static let wasLoadedUserDefaultsKey = "wasLoadedUserDefaultsKey"
  var shouldShowForm: Bool = false
  private let keychain = Keychain(service: Constants.Keychain.name)
  private var fetchedUser = CoreDataService.shared.fetchUser()
  
  private var authData: AuthorizationData?
  
  // MARK: - Life cycle
  private init() {
    if !UserDefaults.standard.bool(forKey: ProfileService.wasLoadedUserDefaultsKey) {
      keychain[Constants.Keychain.token] = nil
    }
    token = keychain[Constants.Keychain.token]
    UserDefaults.standard.set(true, forKey: ProfileService.wasLoadedUserDefaultsKey)
    pushToken = keychain[Constants.Keychain.pushTokenKey]
    if let userIdString = keychain[Constants.Keychain.userId] {
      userId = Int(userIdString)
    } else {
      userId = nil
    }
  }
  
  // MARK: - Interface
  func isBirthdayPeriod() -> Bool {
    guard let birthday = ProfileService.shared.user?.birthday else {
      return false
    }

    let calendar = Calendar.current
    let today = Date()
    let todayComponents = calendar.dateComponents([.month, .day], from: today)

    for dayOffset in -7...14 {
      if let dateToCheck = calendar.date(byAdding: .day, value: dayOffset, to: birthday) {
        let dateToCheckComponents = calendar.dateComponents([.month, .day], from: dateToCheck)
        if todayComponents == dateToCheckComponents {
          return true
        }
      }
    }

    return false
  }

  func setToken(_ token: JWTToken?) {
    self.token = token
  }
  
  // MARK: - Authorization
  func requestOTP(for phone: String,
                  completion: @escaping (_ result: Result<Any?>) -> Void) {
    #if DEBUG
    self.requestOTPWithoutAppCehck(for: phone, completion: completion)
    #else
    self.requestOTPWithAppCehck(for: phone, completion: completion)
    #endif
  }

  func requestOTPWithAppCehck(for phone: String,
                   completion: @escaping (_ result: Result<Any?>) -> Void) {
    AppCheck.appCheck().token(forcingRefresh: false) { [weak self] appCheckToken, _ in
      guard let appCheckToken = appCheckToken else {
        completion(.failure(ServerError.unknown))

        return
      }

      AuthAPI.shared.requestOTP(for: phone.digitsOnly(), appCheckToken: appCheckToken.token) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let authData):
          self.authData = authData
          completion(.success(nil))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }

  func requestOTPWithoutAppCehck(for phone: String,
                   completion: @escaping (_ result: Result<Any?>) -> Void) {
    AuthAPI.shared.requestOTP(for: phone.digitsOnly(), appCheckToken: nil) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let authData):
        self.authData = authData
        completion(.success(nil))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func authConfirm(code: String,
                   completion: @escaping (_ result: Result<Any?>) -> Void) {
    guard let authData = authData else {
      completion(.failure(ServerError.unknown))
      return
    }
    let authBlock: (_ result: Result<AuthResponse>) -> Void = { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.token = response.token
        self.userId = response.userId
        self.user = response.user
        self.shouldShowForm = response.showUserForm

        EventService.shared.tryUpdateUserInformation()

        if authData.isUserExist {
          EventService.shared.logLogin()
        } else {
          EventService.shared.logSignUp()
        }
        completion(.success(nil))

      case .failure(let error):
        completion(.failure(error))
      }
    }
    if authData.isUserExist {
      AuthAPI.shared.authConfirm(
        authToken: authData.authToken,
        phone: authData.phone.digitsOnly(),
        code: code,
        completion: authBlock)
    } else {
      AuthAPI.shared.register(
        authToken: authData.authToken,
        phone: authData.phone.digitsOnly(),
        code: code,
        completion: authBlock)
    }
  }
  
  // MARK: - Logout
  func logout(completion: @escaping (_ result: Result<Any?>) -> Void) {
    EventService.shared.markUserAsUnregistered()

    resetUser()

    completion(.success(nil))
  }
  
  func resetUser() {
    token = nil
    userId = nil
    user = nil
  }

  // MARK: - Delete Account
  func deleteAccount(completion: @escaping (_ result: Result<Void>) -> Void) {
    UserAPI.shared.deleteUser { [weak self] result in
        guard let self = self else { return }

        switch result {
        case .success():
          self.resetUser()

          completion(.success(()))
        case .failure(let error):
          if let serverError = error as? ServerError, serverError.type == ServerErrorType.unauthorized {
            self.resetUser()
            DispatchQueue.main.async {
              NotificationCenter.default.post(
                name: .logOutProfile, object: nil)
            }
          }
          completion(.failure(error))
        }
    }
  }
  
  // MARK: - Profile
  func getProfile(completion: @escaping (_ result: Result<User>) -> Void) {
    guard token != nil else {
      completion(.failure(ServerError.unknown))
      return
    }

    UserAPI.shared.getUser { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success(let user):
        self.user = user

        EventService.shared.updateUserInformation(user, isForceUpdate: false)

        completion(.success(user))
      case .failure(let error):
        if let serverError = error as? ServerError,
           serverError.type == ServerErrorType.unauthorized {
          self.resetUser()
          DispatchQueue.main.async {
            NotificationCenter.default.post(
              name: .logOutProfile, object: nil)
          }
        }
        completion(.failure(error))
      }
    }
  }
  
  func updateUser(name: String?,
                  surname: String?,
                  email: String?,
                  birthday: Date?,
                  gender: Gender?,
                  completion: @escaping (_ result: Result<User>) -> Void) {
    UserAPI.shared.updateUser(name: name,
                              surname: surname,
                              email: email,
                              birthday: birthday,
                              gender: gender) { [weak self] result in
                                guard let self = self else { return }
                                switch result {
                                case .success(let user):
                                  self.user = user
                                  completion(.success(user))
                                  EventService.shared.logProfileStatus(isFull: user.isFull)

                                  EventService.shared.updateUserInformation(user, isForceUpdate: true)

                                case .failure(let error):
                                  completion(.failure(error))
                                }
    }
  }
  
  func updateUserId(_ userId: UserID) {
    self.userId = userId
  }
  
  // MARK: - Contacts
  
  func updateContacts() {
    
    UserAPI.shared.updateContacts { result in
      
      switch result {
      case .success(let model):
        ContactsHelper().storeContacts(model)
        NotificationCenter.default.post(name: Notification.Name.contactsUpdated, object: nil)
      case .failure(_):
        return
      }
    }
  }
  
  // MARK: - Gifts
  func sendGift(sender: GiftParticipant,
                recipient: GiftParticipant,
                product: Product,
                completion: @escaping (_ result: Result<Any?>) -> Void) {
    UserAPI.shared.sendGift(sender: sender,
                            recipient: recipient,
                            productId: product.id,
                            image: product.image?.absoluteString ?? "",
                            completion: completion)
  }
}

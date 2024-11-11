//
//  AuthAPI.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

typealias JWTToken = String

class AuthAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = AuthAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let phone = "/auth/phone"
    static let authConfirm = "/auth/phone/confirm"
    static let register = "/auth/profile"
  }
  
  // MARK: - Phone
  func requestOTP(for phone: String, appCheckToken: String?, completion: @escaping (_ result: Result<AuthorizationData>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }

    alamofireRequest(endpoint: Endpoint.phone,
                     method: .post,
                     parameters: getPhoneParameters(from: phone),
                     appCheckToken: appCheckToken) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let authToken = data[NetworkResponseKey.Auth.authToken].stringValue
                        let isUserExist = data[NetworkResponseKey.Auth.userExist].boolValue
                        let authData = AuthorizationData(phone: phone,
                                                         authToken: authToken,
                                                         isUserExist: isUserExist)
                        completion(.success(authData))
                      }
    }
  }
  
  func authConfirm(authToken: String,
                   phone: String,
                   code: String,
                   completion: @escaping (_ result: Result<AuthResponse>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params = [NetworkRequestKey.Auth.authToken: authToken,
                  NetworkRequestKey.Auth.telephoneNumber: phone,
                  NetworkRequestKey.Auth.code: code]
    alamofireRequest(endpoint: Endpoint.authConfirm,
                     method: .post,
                     parameters: [NetworkRequestKey.data: params]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let authResponse = AuthResponse(json: data) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        completion(.success(authResponse))
                      }
    }
  }
  
  func register(authToken: String,
                phone: String,
                code: String,
                completion: @escaping (_ result: Result<AuthResponse>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    let params = [NetworkRequestKey.Auth.authToken: authToken,
                  NetworkRequestKey.Auth.telephoneNumber: phone,
                  NetworkRequestKey.Auth.code: code]
    alamofireRequest(endpoint: Endpoint.register,
                     method: .post,
                     parameters: [NetworkRequestKey.data: params]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let authResponse = AuthResponse(json: data) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        completion(.success(authResponse))
                      }
    }
  }
  
  // MARK: - Private methods
  private func getPhoneParameters(from phoneNumber: String) -> [String: Any] {
    var param = [String: Any]()
    let data = [NetworkRequestKey.Auth.telephoneNumber: phoneNumber]
    param[NetworkRequestKey.Auth.data] = data
    return param
  }
  
}

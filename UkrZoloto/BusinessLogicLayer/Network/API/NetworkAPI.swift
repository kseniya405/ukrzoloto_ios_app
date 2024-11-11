//
//  NetworkAPI.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum RefreshTokenResponse {
  case tokenUpdated
  case failure(AFDataResponse<Data>)
}

class NetworkAPI: NSObject {

  // MARK: - Public methods
  func alamofireRequest(
    endpoint: String,
    method: HTTPMethod,
    parameters: [String: Any],
    appCheckToken: String? = nil,
    useBaseURL: Bool = true,
    completion: @escaping (AFDataResponse<Data>) -> Void) {
      let requestURL = useBaseURL ? Constants.baseURL + endpoint : Constants.baseURLWithoutAPI + endpoint

      var headers: HTTPHeaders = [
        HTTPHeader.accept(NetworkConstants.accept),
        HTTPHeader.contentType(NetworkConstants.contentType),
        HTTPHeader.acceptLanguage(LocalizationService.shared.language.languageCode),
        HTTPHeader.userAgent(NetworkConstants.userAgent)
      ]

      if let bearerToken = ProfileService.shared.token {
        headers.add(HTTPHeader.authorization(bearerToken: bearerToken))
      }

      if let appCheckToken = appCheckToken {
        headers.add(HTTPHeader(name: NetworkConstants.appCheckToken, value: appCheckToken))
      }

      let refreshTokenHandler: (_ response: RefreshTokenResponse) -> Void = { [weak self] result in
        guard let self = self else { return }

        switch result {
        case .tokenUpdated:
          self.alamofireRequest(endpoint: endpoint,
                                method: method,
                                parameters: parameters,
                                useBaseURL: useBaseURL,
                                completion: completion)
        case .failure(let response):
          completion(response)
        }
      }

      debugPrint(" ☄️ REQUEST >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
      debugPrint(" ☄️ >>> Path >>>:", requestURL)
//      debugPrint(" ☄️ >>> Headers >>>:", headers)
      debugPrint(" ☄️ >>> Parameters >>>:", parameters)

      AF.request(
        requestURL,
        method: method,
        parameters: parameters,
        encoding: self.getEncodingTypeBy(method),
        headers: headers)
        .responseData { [weak self] dataResponse in
          guard let self = self else { return }

          let parsedResult = self.parseResponse(dataResponse, showDebugInfo: false)

          if let serverError = parsedResult.error as? ServerError,
             serverError.type == .refreshToken,
             let newToken = serverError.newToken {

            if Network.state == .active {
              Network.state = .needToRefreshToken
            }

            self.refreshToken(newToken: newToken, completion: refreshTokenHandler)
          } else {
            completion(dataResponse)
          }
        }
    }

  private func getEncodingTypeBy(_ httpMethod: HTTPMethod) -> ParameterEncoding {
    return httpMethod == .get ? URLEncoding.default : JSONEncoding.default
  }

  func parseResponse(_ response: AFDataResponse<Data>, showDebugInfo: Bool = false) -> Result<JSON> {
    guard let statusCode = response.response?.statusCode else {
      return .failure(ServerError.unknown)
    }

    let data = JSON(response.data as Any)

    if showDebugInfo {
      debugPrint("⬇️ RESPONSE: \(response.request?.url?.absoluteString ?? "") Code – [ \(statusCode) ] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    }

    if !(200..<300).contains(statusCode) {
      let newToken = data[NetworkResponseKey.Error.newToken].string

      let error = ServerError(
        type: statusCode, json: data[NetworkResponseKey.Error.error],
        newToken: newToken) ?? ServerError.unknown

      if error.type == .unauthorized {
        EventService.shared.logAutoLogout(
          appVersion: Bundle.main.buildVersionNumber,
          appName: Bundle.main.bundleId,
          request: response.request?.url?.absoluteString ?? "",
          date: Date(), method: response.request?.httpMethod ?? "",
          statusFromServer: response.response?.statusCode ?? -1,
          headers: response.request?.allHTTPHeaderFields ?? [:])
      }

      if showDebugInfo {
        debugPrint("❌ FAILURE: Error – \(error.title) >>> \(error.description) >>> \(String(describing: response.error))")
				debugPrint("\n\n\n\n\n\n")
      }

      return .failure(error)
    }

    if showDebugInfo {
      debugPrint("✅ SUCCESS: JSON")
      debugPrint(data)
      debugPrint("⬆️ END RESPONSE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
			debugPrint("\n\n\n\n\n\n")
    }

    return .success(data[NetworkResponseKey.data])
  }

  func refreshToken(newToken: String, completion: @escaping (_ response: RefreshTokenResponse) -> Void) {
    switch Network.state {
    case .refreshing:
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.refreshToken(newToken: newToken, completion: completion)
      }

      return
    case .active:
      completion(.tokenUpdated)

      return
    case .needToRefreshToken:

      break
    }

    Network.state = .refreshing
    ProfileService.shared.setToken(newToken)

    completion(.tokenUpdated)

    Network.state = .active
  }
}

private enum NetworkConstants {
  static let accept = "application/json"
  static let contentType = "application/json"
  static let userAgent = "okhttp/4.0.0-alpha02"
  static let appCheckToken = "X-Firebase-AppCheck"
}

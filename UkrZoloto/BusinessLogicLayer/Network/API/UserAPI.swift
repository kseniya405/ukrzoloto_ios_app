//
//  UserAPI.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 10/21/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import Alamofire

class UserAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = UserAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let user = "/me"
    static let gift = "/gift_letter"
    static let contacts = "/settings"
    static let deleteUser = "/users/current"
  }
  
  // MARK: - User
  func deleteUser(completion: @escaping (_ result: Result<Void>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }

    alamofireRequest(endpoint: Endpoint.deleteUser,
                     method: HTTPMethod.delete,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        print(error)

                        completion(.failure(error))
                      case .success(let successResponseData):
                        debugPrint(successResponseData)
                        completion(.success(()))
                      }
    }
  }

  func getUser(completion: @escaping (_ result: Result<User>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.user,
                     method: HTTPMethod.get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let user = User(json: data[NetworkResponseKey.User.profile]) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        completion(.success(user))
                      }
    }
  }
  
  func updateUser(name: String?,
                  surname: String?,
                  email: String?,
                  birthday: Date?,
                  gender: Gender?,
                  completion: @escaping (_ result: Result<User>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    var params: [String: Any] = [NetworkRequestKey.User.name: name ?? "",
                                 NetworkRequestKey.User.surname: surname ?? "",
                                 NetworkRequestKey.User.email: email ?? ""
    ]
    
    if let gender = gender, gender != .undefined {
      params[NetworkRequestKey.User.gender] = gender.rawValue
    } else {
      params[NetworkRequestKey.User.gender] = ""
    }

    if let date = birthday {
      params[NetworkRequestKey.User.birthday] = DateFormattersFactory.serverDateFormatter().string(from: date)
    } else {
      params[NetworkRequestKey.User.birthday] = ""
    }
    alamofireRequest(endpoint: Endpoint.user,
                     method: .put,
                     parameters: [NetworkRequestKey.data: [NetworkRequestKey.User.profile: params]]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let user = User(json: data[NetworkResponseKey.User.profile]) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        completion(.success(user))
                      }
    }
  }
  
  func updateContacts(completion: @escaping (_ result: Result<Contacts>) -> ()) {
    
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.contacts,
                     method: .get,
                     parameters: [:]) { [weak self] response in
      guard let self = self else { return }
      
      let parsedResponse = self.parseResponse(response)
      
      switch parsedResponse {
      
      case .success(let json):
        
        guard let model = Contacts(json: json) else {
          completion(.failure(ServerError.unknown))
          return
        }
        completion(.success(model))
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  // MARK: - Gifts
  func sendGift(sender: GiftParticipant,
                recipient: GiftParticipant,
                productId: Int,
                image: String,
                completion: @escaping (_ result: Result<Any?>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params = getGiftParameters(for: sender,
                                   recipient: recipient,
                                   productId: productId,
                                   image: image)
    alamofireRequest(endpoint: Endpoint.gift,
                     method: .post,
                     parameters: params) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success:
                        completion(.success(nil))
                      }
    }
  }
  
  // MARK: - Private methods
  func getGiftParameters(for sender: GiftParticipant,
                         recipient: GiftParticipant,
                         productId: Int,
                         image: String) -> [String: Any] {
    
    return [
      NetworkRequestKey.Gift.forName: recipient.name,
      NetworkRequestKey.Gift.forEmail: recipient.email ?? "",
      NetworkRequestKey.Gift.forPhone: recipient.phone ?? "",
      NetworkRequestKey.Gift.fromName: sender.name,
      NetworkRequestKey.Gift.fromEmail: sender.email ?? "",
      NetworkRequestKey.Gift.fromPhone: sender.phone ?? "",
      NetworkRequestKey.Gift.productId: productId,
      NetworkRequestKey.Gift.image: image
    ]
  }
}

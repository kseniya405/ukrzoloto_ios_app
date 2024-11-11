//
//  AuthResponse.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 12.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import SwiftyJSON

typealias UserID = Int

struct AuthResponse {
  
  // MARK: Public variables
  let token: JWTToken
  let userId: UserID
  let showUserForm: Bool
  let user: User
  
  // MARK: - Life cycle
  init?(json: JSON) {
    guard let data = json.dictionary,
          let jwtToken = data[NetworkResponseKey.Auth.jwt]?.string,
          let userJson = data[NetworkResponseKey.Auth.profile],
          let userModel = User(json: userJson) else {
      return nil
    }
    token = jwtToken
    userId = data[NetworkResponseKey.Auth.userId]?.intValue ?? 0
    showUserForm = data[NetworkResponseKey.Auth.showUserForm]?.boolValue ?? false
    user = userModel
  }
}

//
//  Network.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 26.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

enum NetworkState {
  case active
  case needToRefreshToken
  case refreshing
}

final class Network {

  // MARK: - Public variables
  static var state: NetworkState = .active
  
  // MARK: - Life cycle
  private init() { }
}

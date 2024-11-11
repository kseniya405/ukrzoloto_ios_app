//
//  ShopsService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/19/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ShopsService {
  
  // MARK: - Public variables
  static let shared = ShopsService()
  
  // MARK: - Life cycle
  private init() { }
  
  // MARK: - Interface
  func getCitiesWithShops(completion: @escaping (_ result: Result<[City]>) -> Void) {
    ShopsAPI.shared.getCitiesWithShops(completion: completion)
  }
	
	func getShopsList(parameters: [String: Any], completion: @escaping (_ result: Result<NewShops?>) -> Void) {
		ShopsAPI.shared.getShopsList(parameters: parameters, completion: completion)
	}
}

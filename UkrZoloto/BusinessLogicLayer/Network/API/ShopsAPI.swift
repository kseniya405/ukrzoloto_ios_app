//
//  ShopsAPI.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/19/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ShopsAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = ShopsAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let allShops = "/cities_with_shops"
		static let newShops = "/v2/shops/"
  }
  
	func getCitiesWithShops(completion: @escaping (_ result: Result<[City]>) -> Void) {
		if !ReachabilityService.shared.isInternetAvailable {
			completion(.failure(ServerError.noInternetConnection))
			return
		}
		
		alamofireRequest(endpoint: Endpoint.allShops,
										 method: .get,
										 parameters: [:]) { [weak self] dataResponse in
			guard let self = self else { return }
			let parsedResult = self.parseResponse(dataResponse)
			switch parsedResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let data):
				let cities = data[NetworkResponseKey.City.cities].arrayValue.compactMap { City(json: $0) }
				completion(.success(cities))
			}
		}
	}
//
	func getShopsList(parameters: [String: Any], completion: @escaping (_ result: Result<NewShops?>) -> Void) {
			if !ReachabilityService.shared.isInternetAvailable {
				completion(.failure(ServerError.noInternetConnection))
				return
			}
			alamofireRequest(endpoint: Endpoint.newShops,
											 method: .get,
											 parameters: parameters, useBaseURL: false) { [weak self] dataResponse in
				guard let self = self else { return }
				let parsedResult = self.parseResponse(dataResponse)
//				print(parsedResult)
				switch parsedResult {
				case .failure(let error):
					completion(.failure(error))
				case .success(let data):
					
					let shops = NewShops(json: data)
					completion(.success(shops))
				}
			}
		}
  
}

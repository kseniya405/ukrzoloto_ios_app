//
//  SearchAPI.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 8/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import Alamofire

typealias SearchResponseInfo = (searchText: String, page: Int, rangeFilters: [RangeFilter], selectFilters: [SelectFilter])

struct SearchPageData {
  let products: [Product]
  let rangeFilters: [RangeFilter]
  let selectFilters: [SelectFilter]
  let pagination: Pagination
  
  static let zero = SearchPageData(products: [],
                                   rangeFilters: [],
                                   selectFilters: [],
                                   pagination: Pagination.zero)
}

class SearchAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = SearchAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let search = "/search"
  }
  
  // MARK: - Search
  func search(for searchInfo: SearchResponseInfo, completion: @escaping (_ result: Result<SearchPageData>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    alamofireRequest(endpoint: Endpoint.search,
                     method: HTTPMethod.get,
                     parameters: getSearchParams(for: searchInfo)) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let rangeFilters = data[NetworkResponseKey.Filter.filters].arrayValue
                          .filter { $0[NetworkResponseKey.Filter.type].stringValue == NetworkResponseKey.RangeFilter.type }
                          .compactMap { RangeFilter(json: $0) }
                        let selectFilters = data[NetworkResponseKey.Filter.filters].arrayValue
                          .filter { $0[NetworkResponseKey.Filter.type].stringValue == NetworkResponseKey.SelectFilter.type }
                          .compactMap { SelectFilter(json: $0) }
                        let products = data[NetworkResponseKey.Product.goods].arrayValue.compactMap { Product(json: $0) }
                        let pagination = Pagination(json: data[NetworkResponseKey.Pagination.pagination])
                        completion(.success(
                          SearchPageData(products: products,
                                         rangeFilters: rangeFilters,
                                         selectFilters: selectFilters,
                                         pagination: pagination)))
                      }
    }
  }
  
  // MARK: - Private methods
  private func getSearchParams(for searchInfo: SearchResponseInfo) -> [String: Any] {
    var attr: [String: Any] = [
      NetworkRequestKey.Search.searchText: searchInfo.searchText,
      NetworkRequestKey.Search.page: searchInfo.page]
    
    if let rangeFilter = searchInfo.rangeFilters.first {
      attr[NetworkRequestKey.Filter.minPrice] = rangeFilter.minPrice * 100
      attr[NetworkRequestKey.Filter.maxPrice] = rangeFilter.maxPrice * 100
    }
    
    let filterAttr = searchInfo.selectFilters.reduce(into: [String: [String]]()) { (resultFilters, filter) in
      filter.variants.filter { $0.status }
        .forEach { variant in
          if let result = resultFilters[variant.id] {
            if !result.contains(variant.slug) {
              resultFilters[variant.id]?.append(variant.slug)
            }
          } else {
            resultFilters[variant.id] = [variant.slug]
          }
      }
    }
    
    for (key, value) in filterAttr {
      attr[key] = value
    }
    
    return attr
  }
}

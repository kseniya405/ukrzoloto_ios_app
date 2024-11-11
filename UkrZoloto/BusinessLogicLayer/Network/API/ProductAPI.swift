//
//  ProductAPI.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

struct MainPageData {
  let banners: [Banner]
  let cateogries: [Category]
  let compilations: [Banner]
  let novelties: [Product]
  let certs: [Product]
  let saleHits: [Product]
  let superPrice: [Banner]
  let discounts: [Product]
}

struct FilterPageData {
  let products: [Product]
  let banners: [Banner]
  let rangeFilters: [RangeFilter]
  let selectFilters: [SelectFilter]
  let pagination: Pagination
  
  static let zero = FilterPageData(products: [], banners: [], rangeFilters: [], selectFilters: [], pagination: Pagination.zero)
}

typealias ProductsBanners = (products: [Product], banners: [Banner])

typealias FilterResponseKey = (page: Int, categoryId: Int, sort: SortKind, rangeFilters: [RangeFilter], selectFilters: [SelectFilter])

class ProductAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = ProductAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let main = "/home"
    static let goods = "/goods"
    static let getSaleHits = "/sales_hits"
    static let getNoveltiesHits = "/novelties"
    static let getDiscountHits = "/discounts"
    static let favorites = "/favorites"

    static func getSaleHits(with categoryId: Int) -> String {
      return "/categories/\(categoryId)"
    }
    
    static func getProduct(with id: String) -> String {
      return "/goods/\(id)"
    }
    
    static func getAssociatedProducts(productId: String) -> String {
      return "/associated_goods/\(productId)"
    }

    static func deleteProductFromFavorite(productId: String) -> String {
      return "/favorites/\(productId)"
    }
  }
  
  func getMainPage(completion: @escaping (_ result: Result<MainPageData>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.main,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let categories = data[NetworkResponseKey.Category.categories].arrayValue.compactMap { Category(json: $0) }
                        let banners = data[NetworkResponseKey.Banner.banners].arrayValue.compactMap { Banner(json: $0) }
                        let compilation = data[NetworkResponseKey.Product.compilation].arrayValue.compactMap { Banner(json: $0) }
                        let novelties = data[NetworkResponseKey.Product.novelties].arrayValue.compactMap { Product(json: $0) }
                        let certs = data[NetworkResponseKey.Product.certificates].arrayValue.compactMap { Product(json: $0) }
                        let saleHits = data[NetworkResponseKey.Product.salesHits].arrayValue.compactMap { Product(json: $0) }
                        let superPrice = data[NetworkResponseKey.Banner.superprice].arrayValue.compactMap { Banner(json: $0) }
                        let discounts = data[NetworkResponseKey.Product.discounts].arrayValue.compactMap { Product(json: $0) }
                        completion(.success(MainPageData(banners: banners,
                                                         cateogries: categories,
                                                         compilations: compilation,
                                                         novelties: novelties,
                                                         certs: certs,
                                                         saleHits: saleHits,
                                                         superPrice: superPrice,
                                                         discounts: discounts)))
                      }
    }
  }
  
  func getSaleHits(for categoryId: Int, completion: @escaping (_ result: Result<ProductsBanners>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.getSaleHits(with: categoryId),
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let products = data[NetworkResponseKey.Product.bestsellers].arrayValue.compactMap { Product(json: $0) }
                        let banners = data[NetworkResponseKey.Banner.banners].arrayValue.compactMap { Banner(json: $0) }
                        completion(.success((products, banners)))
                      }
    }
  }
  
  func getProduct(productId: String, completion: @escaping (_ result: Result<Product>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.getProduct(with: productId),
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        guard let product = Product(json: data) else {
                          completion(.failure(ServerError.unknown))
                          return
                        }
                        completion(.success(product))
                      }
    }
  }
  
  func getAssociatedProducts(productId: String, completion: @escaping (_ result: Result<ProductsBanners>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.getAssociatedProducts(productId: productId),
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let products = data[NetworkResponseKey.Product.goods].arrayValue.compactMap { Product(json: $0) }
                        let banners = data[NetworkResponseKey.Banner.banners].arrayValue.compactMap { Banner(json: $0) }
                        completion(.success((products, banners)))
                      }
    }
  }
  
  func getFilterProducts(for filterKey: FilterResponseKey, completion: @escaping (_ result: Result<FilterPageData>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.goods,
                     method: .get,
                     parameters: getFilterParameters(for: filterKey)) { [weak self] dataResponse in
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
                        let banners = data[NetworkResponseKey.Banner.banners].arrayValue.compactMap { Banner(json: $0) }
                        let pagination = Pagination(json: data[NetworkResponseKey.Pagination.pagination])
                        completion(.success(FilterPageData(products: products,
                                                           banners: banners,
                                                           rangeFilters: rangeFilters,
                                                           selectFilters: selectFilters,
                                                           pagination: pagination)))
                      }
    }
  }

  func getFavoritesProducts(completion: @escaping (_ result: Result<[Product]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.favorites,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let result = self.parseResponse(dataResponse)
      self.parseFavoritesProducts(response: result, completion: completion)
    }
  }

  func addProductToFavorites(with productId: String, completion: @escaping (_ result: Result<[Product]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }

    alamofireRequest(endpoint: Endpoint.favorites,
                     method: .post,
                     parameters: getAddToFavoriteParameters(with: productId)) { [weak self] dataResponse in
      guard let self = self else { return }
      let result = self.parseResponse(dataResponse)
      self.parseFavoritesProducts(response: result, completion: completion)
    }
  }

  func deleteProductFromFavorites(with productId: String, completion: @escaping (_ result: Result<[Product]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }

    alamofireRequest(endpoint: Endpoint.deleteProductFromFavorite(productId: productId),
                     method: .delete,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let result = self.parseResponse(dataResponse)
      self.parseFavoritesProducts(response: result, completion: completion)
    }
  }

  // MARK: - Hits
  func getSaleHits(completion: @escaping (_ result: Result<[Product]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.getSaleHits,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let products = data[NetworkResponseKey.Product.salesHits].arrayValue.compactMap { Product(json: $0) }
                        completion(.success(products))
                      }
    }
  }
  
  func getNoveltiesHits(completion: @escaping (_ result: Result<[Product]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.getNoveltiesHits,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let products = data[NetworkResponseKey.Product.novelties].arrayValue.compactMap { Product(json: $0) }
                        completion(.success(products))
                      }
    }
  }
  
  func getDiscountHits(completion: @escaping (_ result: Result<[Product]>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.getDiscountHits,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
                      guard let self = self else { return }
                      let parsedResult = self.parseResponse(dataResponse)
                      switch parsedResult {
                      case .failure(let error):
                        completion(.failure(error))
                      case .success(let data):
                        let products = data[NetworkResponseKey.Product.discounts].arrayValue.compactMap { Product(json: $0) }
                        completion(.success(products))
                      }
    }
  }
  
  // MARK: - Private methods
  private func getFilterParameters(for filterKey: FilterResponseKey) -> [String: Any] {
    var attr: [String: Any] = [
      NetworkRequestKey.Filter.subcategoryId: filterKey.categoryId,
      NetworkRequestKey.Filter.page: filterKey.page,
      NetworkRequestKey.Filter.sort: filterKey.sort.rawValue
    ]
    
    if let rangeFilter = filterKey.rangeFilters.first {
      attr[NetworkRequestKey.Filter.minPrice] = rangeFilter.minPrice * 100
      attr[NetworkRequestKey.Filter.maxPrice] = rangeFilter.maxPrice * 100
    }
    
    let filterAttr = filterKey.selectFilters.reduce(into: [String: [String]]()) { (resultFilters, filter) in
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

  private func getAddToFavoriteParameters(with productId: String) -> [String: Any] {
    return [NetworkRequestKey.Favorites.productId: productId]
  }

  private func parseFavoritesProducts(response result: Result<JSON>, completion: @escaping (_ result: Result<[Product]>) -> Void) {
    switch result {
    case .success(let data):
      let products = data[NetworkResponseKey.Favorites.favorites].arrayValue.compactMap { Product(json: $0) }
      completion(.success(products))
    case .failure(let error):
      completion(.failure(error))
    }
  }
}

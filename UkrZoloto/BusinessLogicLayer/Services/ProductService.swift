//
//  ProductService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum HitsType {
  case saleHits
  case novelties
  case discounts
}

class ProductService {
  
  // MARK: - Public variables
  static let shared = ProductService()
  
  // MARK: - Life cycle
  private init() { }
  
  // MARK: - Interface
  func getMainPage(completion: @escaping (_ mainResponse: Result<MainPageData>) -> Void) {
    ProductAPI.shared.getMainPage(completion: completion)
  }
  
  func getSaleHits(for categoryId: Int, completion: @escaping (_ result: Result<ProductsBanners>) -> Void) {
    ProductAPI.shared.getSaleHits(for: categoryId, completion: completion)
  }
  
  func getProduct(productId: String, completion: @escaping (_ result: Result<Product>) -> Void) {
    ProductAPI.shared.getProduct(productId: productId, completion: completion)
  }
  
  func getAssociatedProducts(productId: String, completion: @escaping (_ result: Result<ProductsBanners>) -> Void) {
    ProductAPI.shared.getAssociatedProducts(productId: productId, completion: completion)
  }
  
  func getFilterProducts(for filterKey: FilterResponseKey, completion: @escaping (_ result: Result<FilterPageData>) -> Void) {
    ProductAPI.shared.getFilterProducts(for: filterKey, completion: completion)
  }
  
  func getHits(ofType type: HitsType, completion: @escaping (_ result: Result<[Product]>) -> Void) {
    switch type {
    case .saleHits:
      ProductAPI.shared.getSaleHits(completion: completion)
    case .novelties:
      ProductAPI.shared.getNoveltiesHits(completion: completion)
    case .discounts:
      ProductAPI.shared.getDiscountHits(completion: completion)
    }
  }

  func getFavoritesProducts(completion: @escaping (_ result: Result<[Product]>) -> Void) {
    ProductAPI.shared.getFavoritesProducts(completion: completion)
  }

  func addProductToFavorites(with productId: String, sku: String, completion: @escaping (_ result: Result<[Product]>) -> Void) {
    
    EventService.shared.logAddToWithlist(productSKU: sku)
    
    ProductAPI.shared.addProductToFavorites(with: productId) { [weak self] result in
      switch result {
      case .success(let products):
        completion(.success(products))
        self?.postNewProductFavoritesStatus(productId: productId, isFavorite: true)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func deleteProductFromFavorites(with productId: String, completion: @escaping (_ result: Result<[Product]>) -> Void) {
    ProductAPI.shared.deleteProductFromFavorites(with: productId) { [weak self] result in
      switch result {
      case .success(let products):
        completion(.success(products))
        self?.postNewProductFavoritesStatus(productId: productId, isFavorite: false)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  private func postNewProductFavoritesStatus(productId: String, isFavorite: Bool) {
    NotificationCenter.default.post(name: .didUpdateProductFavoriteStatus,
                                    object: nil,
                                    userInfo: [Notification.Key.productId: productId,
                                               Notification.Key.newFavoriteStatus: isFavorite])
  }
}

//
//  SearchService.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 05.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

class SearchService {
  
  // MARK: - Public variables
  static let shared = SearchService()
  
  // MARK: - Life cycle
  private init() { }
  
  // MARK: - Interface
  func search(for searchInfo: SearchResponseInfo, completion: @escaping (_ result: Result<SearchPageData>) -> Void) {
    SearchAPI.shared.search(for: searchInfo) { result in
      completion(result)
      switch result {
      case .failure: break
      case .success:
        var isFound: Bool = false
        
        if let foundedProducts = result.value?.products {
          isFound = !foundedProducts.isEmpty
        }

        EventService.shared.logSearch(search: searchInfo.searchText, isFound: isFound)
      }
    }
  }
}

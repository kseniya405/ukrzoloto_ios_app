//
//  Pagination.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pagination {
  
  // MARK: - Static
  static let zero = Pagination(count: 0, currentPage: 0, lastPage: 0, perPage: 0, total: 0)
  
  // MARK: - Public variables
  let count: Int
  let currentPage: Int
  let lastPage: Int
  let perPage: Int
  let total: Int
  
  // MARK: - Life cycle
  init(json: JSON) {
    count = json[NetworkResponseKey.Pagination.count].intValue
    currentPage = json[NetworkResponseKey.Pagination.currentPage].intValue
    lastPage = json[NetworkResponseKey.Pagination.lastPage].intValue
    perPage = json[NetworkResponseKey.Pagination.perPage].intValue
    total = json[NetworkResponseKey.Pagination.total].intValue
  }
  
  init(count: Int,
       currentPage: Int,
       lastPage: Int,
       perPage: Int,
       total: Int) {
    self.count = count
    self.currentPage = currentPage
    self.lastPage = lastPage
    self.perPage = perPage
    self.total = total
  }
  
}

//
//  BannerViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/15/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

struct BannerViewModel: Hashable {
  
  let id: Int
  let image: ImageViewModel
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: BannerViewModel, rhs: BannerViewModel) -> Bool {
    return lhs.id == rhs.id
  }
}

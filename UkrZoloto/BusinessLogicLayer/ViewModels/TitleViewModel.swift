//
//  TitleViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

struct TitleViewModel: HashableTitle {
  let id: String
  let title: String
  
  init(id: String = UUID().uuidString, title: String) {
    self.id = id
    self.title = title
  }
}

//
//  ImageTitleViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/7/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

struct ImageTitleViewModel: HashableTitle {
  let id: String
  let title: String
  let image: ImageViewModel
  
  init(id: String = UUID().uuidString, title: String, image: ImageViewModel) {
    self.id = id
    self.title = title
    self.image = image
  }
}

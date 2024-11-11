//
//  UnderlinePlaceholderViewModel.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/11/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

struct UnderlinePlaceholderViewModel {
  var text: String?
  let placeholder: String
  let description: String?
  let image: ImageViewModel?
  let error: String?
  
  // MARK: - Life cycle
  init(text: String? = nil, placeholder: String, description: String? = nil, image: ImageViewModel? = nil, error: String? = nil) {
    self.text = text
    self.placeholder = placeholder
    self.description = description
    self.image = image
    self.error = error
  }
  
}

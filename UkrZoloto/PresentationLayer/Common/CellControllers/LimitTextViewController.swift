//
//  LimitTextViewController.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 28.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import AUIKit

class LimitTextViewController: AUIDefaultTextViewController {

  // MARK: - Public variables
  var maxCharacters: Int
  
  // MARK: - Life cycle
  init(maxCharacters: Int) {
    self.maxCharacters = maxCharacters
  }
  
  override func textView(shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let textView = textView else { return true }
    let newString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
    let stringLength = newString?.count ?? 0
    return stringLength <= maxCharacters
  }
}

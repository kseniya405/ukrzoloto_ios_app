//
//  BaseSearchBar.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 9/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class BaseSearchBar: UISearchBar {
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if let searchTextField = getSearchTextField() {
      getSearchTextField()?.layer.cornerRadius = searchTextField.bounds.height / 2
    }
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.backgroundColor
    setBackgroundImage(UIImage(),
                       for: .any,
                       barMetrics: .default)
    getSearchTextField()?.clipsToBounds = true
    getSearchTextField()?.backgroundColor = .white
    getSearchTextField()?.autocorrectionType = .no
    getSearchTextField()?.doneAccessory = false
  }
  
  // MARK: - Private methods
  private func getSearchTextField() -> UITextField? {
    return searchTextField
  }
  
}

private enum UIConstants {
  static let backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
}

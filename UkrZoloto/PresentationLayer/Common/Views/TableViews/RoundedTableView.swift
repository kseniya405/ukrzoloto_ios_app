//
//  RoundedTableView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/26/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class RoundedTableView: UITableView {

  // MARK: - Life cycle
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.backgroundColor
    clipsToBounds = true
    alwaysBounceVertical = false
    bounces = false
  }
}

private enum UIConstants {
  static let backgroundColor = UIColor.clear
}

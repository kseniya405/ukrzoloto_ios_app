//
//  SelectShopTableViewCell.swift
//  UkrZoloto
//
//  Created by user on 25.08.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

class SelectShopTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  let selfView = SelectionView()
  
  // MARK: - Life cycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      initConfigure()
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      initConfigure()
  }
  
  // MARK: - Init configure
  
  func initConfigure() {
    configureSelfView()
  }
  
  private func configureSelfView() {
    contentView.addSubview(selfView)
    selfView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.SelfView.sides)
    }
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let sides: CGFloat = 24
  }
}

//
//  SpaceTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/5/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class SpaceTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Private variables
  private let view = UIView()
  private var height: CGFloat = 0
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initConfigure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initConfigure()
  }
  
  private func initConfigure() {
    selectionStyle = .none
    autoresizingMask = .flexibleHeight
    configureView()
  }
  
  private func configureView() {
    contentView.addSubview(view)
    view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    backgroundColor = UIConstants.backgroundColor
    view.backgroundColor = UIConstants.backgroundColor
  }
  
  // MARK: - Interface
  func configure(space: CGFloat, backgroundColor: UIColor = .clear) {
    height = space
    view.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(space).priority(999)
    }
    self.backgroundColor = backgroundColor
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  static let backgroundColor = UIColor.clear
}

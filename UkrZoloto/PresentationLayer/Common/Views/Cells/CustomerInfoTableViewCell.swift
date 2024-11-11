//
//  CustomerInfoTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/4/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class CustomerInfoTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Private variables
  private let infoView = SelectionView()
  
  // MARK: - Life Cycle
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
    setupCategoryView()
  }
  
  private func setupCategoryView() {
    contentView.addSubview(infoView)
    infoView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Title.insets)
    }
    infoView.setFont(UIConstants.Title.font)
    infoView.setTextColor(UIConstants.Title.color)
  }
  
  // MARK: - Interface
  func configure(viewModel: ImageTitleViewModel, separatorPosition: SeparatorPosition) {
    infoView.setTitle(viewModel.title)
    infoView.setRightImage(viewModel.image)
    infoView.setSeparatorPosition(separatorPosition)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum Title {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 16)
    
    static let insets: CGFloat = 24
  }
}

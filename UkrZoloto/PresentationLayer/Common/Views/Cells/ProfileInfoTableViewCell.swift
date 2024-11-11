//
//  ProfileInfoTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/3/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Private variables
  private let profileInfoView = SelectionView()
  
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
    setupProfileView()
  }
  
  private func setupProfileView() {
    contentView.addSubview(profileInfoView)
    profileInfoView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.equalToSuperview()
        .inset(UIConstants.Title.insets)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    profileInfoView.setFont(UIConstants.Title.font)
    profileInfoView.setTextColor(UIConstants.Title.color)
    profileInfoView.setLineHeight(UIConstants.Title.lineHeight)
  }
  
  // MARK: - Interface
  func configure(viewModel: ImageTitleImageViewModel, separatorPosition: SeparatorPosition) {
    profileInfoView.setTitle(viewModel.title)
    profileInfoView.setLeftImage(viewModel.leftImageViewModel)
    profileInfoView.setRightImage(viewModel.rightImageViewModel)
    profileInfoView.setSeparatorPosition(separatorPosition)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum Title {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 16)
    static let lineHeight: CGFloat = 24
    
    static let top: CGFloat = 10 * Constants.Screen.heightCoefficient
    static let insets: CGFloat = 24
  }
}


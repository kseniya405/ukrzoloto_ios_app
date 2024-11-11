//
//  DeleteAccountTableViewCell.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 25.07.2022.
//  Copyright © 2022 Brander. All rights reserved.
//

import Foundation
import UIKit

class DeleteAccountTableViewCell: UITableViewCell, Reusable {

  // MARK: - Private variables
  private let deleteAccountView = SelectionView()

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
    contentView.addSubview(deleteAccountView)
    deleteAccountView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.equalToSuperview()
        .inset(UIConstants.Title.insets)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    deleteAccountView.setFont(UIConstants.Title.font)
    deleteAccountView.setTextColor(UIConstants.Title.color)
    deleteAccountView.setLineHeight(UIConstants.Title.lineHeight)
  }

  // MARK: - Interface
  func configure(viewModel: ImageTitleImageViewModel, separatorPosition: SeparatorPosition) {
    deleteAccountView.setTitle(viewModel.title)
    deleteAccountView.setLeftImage(viewModel.leftImageViewModel)
    deleteAccountView.setRightImage(viewModel.rightImageViewModel)
    deleteAccountView.setSeparatorPosition(separatorPosition)
  }

}

// MARK: - UIConstants
private enum UIConstants {
  enum Title {
    static let color = UIColor.red
    static let font = UIFont.regularAppFont(of: 16)
    static let lineHeight: CGFloat = 24

    static let top: CGFloat = 10 * Constants.Screen.heightCoefficient
    static let insets: CGFloat = 24
  }
}

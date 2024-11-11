//
//  TitleImagesTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/5/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol ImageTitleImagesTableViewCellDelegate: AnyObject {
  func didTapOnImage(with index: Int)
}

class ImageTitleImagesTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: ImageTitleImagesTableViewCellDelegate?
  
  // MARK: - Private variables
  private let socialView = SupportSocialView()
  
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
    configureSocialView()
  }
  
  private func configureSocialView() {
    contentView.addSubview(socialView)
    socialView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.top)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
        .inset(UIConstants.bottom)
    }
    socialView.delegate = self
  }

  // MARK: - Configuration
  func configure(viewModel: ImageTitleImagesViewModel) {
    socialView.configure(viewModel: viewModel)
  }
  
  func updateBottomOffset() {
    socialView.snp.updateConstraints { make in
      make.bottom.equalToSuperview()
        .inset(UIConstants.bottom)
    }
  }
  
}

// MARK: - SupportSocialViewDelegate
extension ImageTitleImagesTableViewCell: SupportSocialViewDelegate {
  func didTapOnImage(with index: Int) {
    delegate?.didTapOnImage(with: index)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  static let top: CGFloat = 14
  static let bottom: CGFloat = 100
}

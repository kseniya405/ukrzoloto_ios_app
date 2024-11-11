//
//  ImageTitleImagesView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 06.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class ImageTitleImagesView: InitView {
  
  // MARK: - Public variables
  weak var delegate: ImageTitleImagesTableViewCellDelegate?
  
  // MARK: - Private variables
  private let socialView = SupportSocialView()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureSocialView()
  }
  
  private func configureSocialView() {
    addSubview(socialView)
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
extension ImageTitleImagesView: SupportSocialViewDelegate {
  func didTapOnImage(with index: Int) {
    delegate?.didTapOnImage(with: index)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  static let top: CGFloat = 14
  static let bottom: CGFloat = 100
}

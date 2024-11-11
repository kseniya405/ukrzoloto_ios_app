//
//  StickersView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 27.06.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation

import UIKit

class StickersView: InitView {

  // MARK: - Private variables
  private let stickersStackView = UIStackView() // UICollectionView(frame: .zero,
                                                    // collectionViewLayout: UICollectionViewLayout())

  override func initConfigure() {
    super.initConfigure()
    configureCollectionView()
  }

  private func configureCollectionView() {
    addSubview(stickersStackView)

    stickersStackView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.height.equalTo(UIConstants.StackView.height)
    }

    stickersStackView.backgroundColor = UIConstants.StackView.backgroundColor
    stickersStackView.axis = .horizontal
    stickersStackView.distribution = .equalSpacing
    stickersStackView.alignment = .leading
    stickersStackView.spacing = UIConstants.StackView.interitemSpacing
  }

  // MARK: - Interface
  func getStickersStackView() -> UIStackView {
    return stickersStackView
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum StackView {
    static let height: CGFloat = 24
    static let backgroundColor = UIColor.white

    static let horizontalInset: CGFloat = 24
    static let interitemSpacing: CGFloat = 10
  }
}

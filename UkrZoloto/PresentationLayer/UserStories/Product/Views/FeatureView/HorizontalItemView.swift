//
//  HorizontalItemView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 04.08.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit

class HorizontalItemView: InitView {
  private let imageView = UIImageView()
  private let titleLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.TitleLabel.font
    label.textColor = UIConstants.TitleLabel.textColor
    label.numberOfLines = UIConstants.TitleLabel.numberOfLines
    label.textAlignment = .center

    return label
  }()

  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureImageViewLabel()
    configureTitleLabel()
  }

  private func configureImageViewLabel() {
    addSubview(imageView)

    imageView.contentMode = .scaleAspectFill

    imageView.snp.makeConstraints { make in
      make.height.width.equalTo(UIConstants.ImageView.size)
      make.leading.trailing.top.equalToSuperview()
    }
  }

  private func configureTitleLabel() {
    addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(imageView.snp.bottom).offset(UIConstants.TitleLabel.top)
    }
  }

  func configure(imageName: String, titleText: String) {
    imageView.image = #imageLiteral(resourceName: imageName)
    titleLabel.text = titleText
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum TitleLabel {
    static let font = UIFont.regularAppFont(of: 12)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let numberOfLines: Int = 3
    static let top: CGFloat = 10
  }

  enum ImageView {
    static let size: CGFloat = 48
  }
}

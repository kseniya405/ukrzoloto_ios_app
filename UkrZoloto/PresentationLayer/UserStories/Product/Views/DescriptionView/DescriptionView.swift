//
//  DescriptionView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 03.07.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation

class DescriptionView: InitView {
  private let topLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.TopLabel.font
    label.textColor = UIConstants.TopLabel.textColor
    label.numberOfLines = 0

    return label
  }()

  private let desciptionLabel: UILabel = {
    let label = UILabel()

    label.font = UIConstants.DesciptionLabel.font
    label.textColor = UIConstants.DesciptionLabel.textColor
    label.numberOfLines = 0

    return label
  }()

  private let collapseButton = UIButton()

  override func initConfigure() {
    super.initConfigure()

    self.backgroundColor = .white

    addSubview(topLabel)
    topLabel.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.TopLabel.height)
      make.top.leading.trailing.equalToSuperview()
    }

    addSubview(desciptionLabel)
    desciptionLabel.snp.makeConstraints { make in
      make.top.equalTo(topLabel.snp.bottom).offset(UIConstants.DesciptionLabel.top)
      make.leading.trailing.bottom.equalToSuperview()
    }

    addSubview(collapseButton)

    collapseButton.setTitle("", for: .normal)
    collapseButton.setImage(#imageLiteral(resourceName: "iconsDropDownUp"), for: .normal)

    collapseButton.snp.makeConstraints { make in
      make.height.equalTo(30)
      make.width.equalTo(30)
      make.trailing.equalToSuperview() // .offset(0)
      make.centerY.equalTo(topLabel.snp.centerY)
    }
  }

  // MARK: - Interface
  func getCollapseButton() -> UIButton {
    return self.collapseButton
  }

  func setCollapsedState() {
    collapseButton.setImage(#imageLiteral(resourceName: "iconsDropDownDown"), for: .normal)
    desciptionLabel.isHidden = true

    topLabel.snp.remakeConstraints { make in
      make.height.equalTo(UIConstants.TopLabel.height)
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

  func setUncollapsedState() {
    collapseButton.setImage(#imageLiteral(resourceName: "iconsDropDownUp"), for: .normal)
    desciptionLabel.isHidden = false

    topLabel.snp.remakeConstraints { make in
      make.height.equalTo(UIConstants.TopLabel.height)
      make.top.leading.trailing.equalToSuperview()
    }

    desciptionLabel.snp.remakeConstraints { make in
      make.top.equalTo(topLabel.snp.bottom).offset(UIConstants.DesciptionLabel.top)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  public func updateViewStateWith(_ productDescription: String) {
    topLabel.text = Localizator.standard.localizedString("Описание").uppercased()
    desciptionLabel.text = productDescription
  }
}

private enum UIConstants {
  enum TopLabel {
    static let font = UIFont.boldAppFont(of: 14.0)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let height: CGFloat = 24
    static let top: CGFloat = 25
  }

  enum DesciptionLabel {
    static let font = UIFont.regularAppFont(of: 14)
    static let textColor = UIColor(named: "textDarkGreen")!
    static let top: CGFloat = 20
  }
}

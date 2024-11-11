//
//  LabelTableViewCell.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/5/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell, Reusable {

  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.height
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.color)
      .numberOfLines(UIConstants.Title.numbersOfLines)
    return label
  }()
  
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
    selectionStyle = .none
    backgroundColor = UIConstants.backgroundColor
    setupTitle()
  }
  
  private func setupTitle() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.Title.leading)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(UIConstants.Title.bottom)
    }
  }
  
  // MARK: - Interface
  func configure(title: String) {
    titleLabel.text = title
  }
}

// MARK: - UIConstants
private enum UIConstants {
  static let backgroundColor = UIColor.clear
  
  enum Title {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 22)
    static let height: CGFloat = 26.4
    static let numbersOfLines: Int = 0
    
    static let top: CGFloat = 24
    static let leading: CGFloat = 24
    static let bottom: CGFloat = 20
  }
}

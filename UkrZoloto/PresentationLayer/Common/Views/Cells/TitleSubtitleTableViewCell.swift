//
//  TitleSubtitleTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/11/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class TitleSubtitleTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.lineHeight
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
      .numberOfLines(UIConstants.Title.numberOfLines)
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Subtitle.lineHeight
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.textColor)
      .numberOfLines(UIConstants.Subtitle.numberOfLines)
    return label
  }()
  
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
    configureSelfView()
    configureTitle()
    configureSubtitle()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTitle() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
        .inset(UIConstants.Title.insets)
    }
  }
  
  private func configureSubtitle() {
    contentView.addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Subtitle.top)
      make.leading.trailing.equalTo(titleLabel)
      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func configure(viewModel: TitleSubtitleViewModel) {
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum Title {
    static let textColor = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.boldAppFont(of: 22)
    static let lineHeight: CGFloat = 26.4
    static let numberOfLines = 0
    
    static let insets: CGFloat = 24
  }
  enum Subtitle {
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 15)
    static let lineHeight: CGFloat = 19.5
    static let numberOfLines = 0
    
    static let top: CGFloat = 6
  }
}

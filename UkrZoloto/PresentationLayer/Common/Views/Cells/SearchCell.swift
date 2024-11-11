//
//  SearchCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 22.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell, Reusable {
  
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
  
  private let underlineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIConstants.Underline.color
    return view
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
    setupTitle()
    setupUnderline()
  }
  
  private func setupTitle() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.Title.top)
      make.leading.equalToSuperview()
        .offset(UIConstants.Title.leading)
      make.centerX.equalToSuperview()
    }
  }
  
  private func setupUnderline() {
    contentView.addSubview(underlineView)
    underlineView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Underline.top)
      make.leading.trailing.equalTo(titleLabel)
      make.height.equalTo(UIConstants.Underline.height)
      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func configure<T: HashableTitle>(viewModel: T, isBold: Bool = false) {
    titleLabel.text = viewModel.title
    
    if isBold {
      titleLabel.font = UIFont.semiBoldAppFont(of: 16)
    } else {
			titleLabel.font = UIFont.regularAppFont(of: 16)
    }
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum Title {
    static let color = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.regularAppFont(of: 16)
    static let height: CGFloat = 24
    static let numbersOfLines: Int = 0
    
    static let top: CGFloat = 13
    static let leading: CGFloat = 24
  }
  
  enum Underline {
    static let color = UIColor.color(r: 230, g: 230, b: 230)
    
    static let height: CGFloat = 1
    static let top: CGFloat = 14
  }
}

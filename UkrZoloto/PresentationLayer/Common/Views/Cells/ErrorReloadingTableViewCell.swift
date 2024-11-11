//
//  ErrorReloadingTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/18/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol ErrorReloadingTableViewCellDelegate: AnyObject {
  func didTapOnReload()
}

class ErrorReloadingTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: ErrorReloadingTableViewCellDelegate?
  
  // MARK: - Private variables
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.Title.lineHeight
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
      .numberOfLines(UIConstants.Title.numberOfLines)
      .textAlignment(.center)
    return label
  }()
  private let greyButton = GreyButton()
  
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
    configureTitleLabel()
    configureButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      .inset(UIConstants.Title.insets)
      make.top.equalToSuperview()
    }
  }
  
  private func configureButton() {
    contentView.addSubview(greyButton)
    greyButton.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
      .offset(UIConstants.Button.top)
      make.leading.trailing.equalTo(titleLabel)
      make.height.equalTo(UIConstants.Button.height)
      make.bottom.equalToSuperview()
    }
    greyButton.addTarget(self,
                         action: #selector(didTapOnButton),
                         for: .touchUpInside)
  }
  
  // MARK: - Interface
  func configure(description: String, buttonTitle: String) {
    titleLabel.text = description
    greyButton.setTitle(buttonTitle, for: .normal)
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnButton() {
    delegate?.didTapOnReload()
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum Title {
    static let numberOfLines = 0
    static let font = UIFont.regularAppFont(of: 14)
    static let lineHeight: CGFloat = 16.8
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    
    static let insets: CGFloat = 24
  }
  enum Button {
    static let height: CGFloat = 52
    static let top: CGFloat = 20
  }
}

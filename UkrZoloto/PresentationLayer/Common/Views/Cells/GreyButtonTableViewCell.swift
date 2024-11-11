//
//  GreyButtonTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol GreyButtonTableViewCellDelegate: AnyObject {
  func didTapOnGreyButton()
}

class GreyButtonTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: GreyButtonTableViewCellDelegate?
  
  // MARK: - Private variables
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
    configureButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureButton() {
    contentView.addSubview(greyButton)
    greyButton.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalToSuperview()
        .inset(UIConstants.Button.insets)
      make.trailing.lessThanOrEqualToSuperview()
        .inset(UIConstants.Button.insets)
      make.height.equalTo(UIConstants.Button.height)
    }
    greyButton.layer.borderColor = UIConstants.Button.borderColor.cgColor
    
    greyButton.addTarget(self,
                          action: #selector(didTapOnButton),
                          for: .touchUpInside)
  }
  
  // MARK: - Interface
  func configure(title: String) {
    greyButton.setTitle(title, for: .normal)
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnButton() {
    delegate?.didTapOnGreyButton()
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum Button {
    static let borderColor = UIColor.clear
    static let insets: CGFloat = 27
    static let height: CGFloat = 25
  }
}

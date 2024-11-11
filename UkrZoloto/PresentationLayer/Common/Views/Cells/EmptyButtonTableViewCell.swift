//
//  EmptyButtonTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/11/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol EmptyButtonTableViewCellDelegate: AnyObject {
  func didTapOnEmptyButton()
}

class EmptyButtonTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: EmptyButtonTableViewCellDelegate?
  
  // MARK: - Private variables
  private let emptyButton = EmptyButton()
  
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
    contentView.addSubview(emptyButton)
    emptyButton.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalToSuperview()
        .inset(UIConstants.Button.insets)
      make.trailing.lessThanOrEqualToSuperview()
        .inset(UIConstants.Button.insets)
      make.height.equalTo(UIConstants.Button.height)
    }
    emptyButton.layer.borderColor = UIConstants.Button.borderColor.cgColor
    
    emptyButton.addTarget(self,
                          action: #selector(didTapOnButton),
                          for: .touchUpInside)
  }
  
  // MARK: - Interface
  func configure(title: String) {
    emptyButton.setTitle(title, for: .normal)
  }
  
  // MARK: - Actions
  @objc
  private func didTapOnButton() {
    delegate?.didTapOnEmptyButton()
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
//
//  ProfileMainInfoTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 18.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

protocol ProfileMainInfoTableViewCellDelegate: AnyObject {
  func didTapOnDiscountAgreement()
}

class ProfileMainInfoTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: ProfileMainInfoTableViewCellDelegate?
  
  // MARK: - Private variables
  private let noDiscountView = AuthorizedNoDiscountView()
  
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
    setupProfileView()
  }
  
  private func setupProfileView() {
    contentView.addSubview(noDiscountView)
    noDiscountView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    noDiscountView.addTarget(
      self, action: #selector(didTapOnDiscountAgreement))
  }
  
  // MARK: - Interface
  func configure(bonusesVMs: [BonusesViewModel],
                 buttonTitle: String) {
    noDiscountView.setBonusesViewModel(bonusesVMs)
    noDiscountView.setButtonTitle(buttonTitle)
  }
  
  // MARK: - private methods
  @objc
  private func didTapOnDiscountAgreement() {
    delegate?.didTapOnDiscountAgreement()
  }
  
}

// MARK: - UIConstants
private enum UIConstants {

}


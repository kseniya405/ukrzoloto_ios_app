//
//  ProfileMainInfoDiscountTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 18.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

protocol ProfileMainInfoDiscountTableViewCellDelegate: AnyObject {
  func didTapOnDiscountAgreement()
}

class ProfileMainInfoDiscountTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: ProfileMainInfoDiscountTableViewCellDelegate?
  
  // MARK: - Private variables
  private let discountView = AuthorizedDiscountView()
  
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
    contentView.addSubview(discountView)
    discountView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    discountView.addTarget(
      self, action: #selector(didTapOnDiscountAgreement))
  }
  
  // MARK: - Interface
  func configure(discountVMs: [DiscountViewModel],
                 bonusesVMs: [BonusesViewModel],
                 buttonTitle: String) {
    discountView.setDiscounts(discountVMs)
    discountView.setBonuses(bonusesVMs)
    discountView.setButtonTitle(buttonTitle)
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

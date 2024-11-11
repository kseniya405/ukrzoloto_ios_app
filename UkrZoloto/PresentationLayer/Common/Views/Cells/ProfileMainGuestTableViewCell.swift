//
//  ProfileMainGuestTableViewCell.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 18.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class ProfileMainGuestTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: GuestHeaderViewDelegate? {
    didSet {
      guestHeaderView.delegate = delegate
    }
  }
  
  // MARK: - Private variables
  private let guestHeaderView = GuestHeaderView()
  
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
    contentView.addSubview(guestHeaderView)
    guestHeaderView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func configure(textValues: GuestViewTextValues) {
    guestHeaderView.setTitle(textValues.title)
    guestHeaderView.setSubtitle(textValues.subtitle, clickedText: textValues.clickedTitle)
    guestHeaderView.setButtonTitle(textValues.buttonTitle)
  }

}

// MARK: - UIConstants
private enum UIConstants {

}


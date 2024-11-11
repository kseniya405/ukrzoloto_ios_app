//
//  RoundedButtonTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 06.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

protocol RoundedButtonTableViewCellDelegate: AnyObject {
  
  func roundedButtonTapped()
}

class RoundedButtonTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: RoundedButtonTableViewCellDelegate?
  
  // MARK: - Private variables
  private let button = UIButton()
  
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
  
  //MARK: - Private methods
  private func initConfigure() {
    selectionStyle = .none
    configureSelfView()
    configureButton()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.backgroundColor
  }
  
  private func configureButton() {
    
    contentView.addSubview(button)
    
    button.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalToSuperview().offset(UIConstants.leadingOffset)
      make.centerX.equalToSuperview()
      make.height.equalTo(UIConstants.height)
    }
    
    button.layer.cornerRadius = UIConstants.cornerRadius
    button.clipsToBounds = true
    
    button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
  }
  
  @objc private func onButtonTap(_ sender: UIButton) {
    
    delegate?.roundedButtonTapped()
  }
  
  //MARK: - Public methods
  func set(title: String, fillColor: UIColor) {
    
    button.backgroundColor = fillColor
    
    let attributedTitle = NSAttributedString(string: title.uppercased(),
                                             attributes: [.font: UIConstants.buttonTitleFont as Any,
                                                          .foregroundColor: UIConstants.textColor])
    button.setAttributedTitle(attributedTitle, for: .normal)
  }
}

fileprivate enum UIConstants {
  
  static let backgroundColor = UIColor.clear
  static let buttonTitleFont = UIFont.boldAppFont(of: 14.0)
  static let cornerRadius: CGFloat = 22.0
  static let leadingOffset: CGFloat = 24.0
  static let height: CGFloat = 52.0
  static let textColor = UIColor.white
}

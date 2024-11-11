//
//  CenteredEmptyButtonTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 06.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

protocol CenteredEmptyButtonTableViewCellDelegate: AnyObject {
  func didTapOnEmptyButton(title: String)
}

class CenteredEmptyButtonTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Public variables
  weak var delegate: CenteredEmptyButtonTableViewCellDelegate?
  
  // MARK: - Private variables
  private let emptyButton = UIButton()
  
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
    backgroundColor = UIConstants.backgroundColor
  }
  
  private func configureButton() {
    contentView.addSubview(emptyButton)
    emptyButton.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.buttonHeight)
      make.top.bottom.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    emptyButton.addTarget(self,
                          action: #selector(onButtonTap(_:)),
                          for: .touchUpInside)
  }
  
  @objc private func onButtonTap(_ sender: UIButton) {
    delegate?.didTapOnEmptyButton(title: emptyButton.attributedTitle(for: .normal)!.string)
  }
  
  // MARK: - Public methods
  
  func setTitle(_ title: String) {
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let attributedTitle = NSAttributedString(string: title,
                                             attributes: [.font: UIConstants.font as Any,
                                                          .foregroundColor: UIConstants.textColor,
                                                          .paragraphStyle: paragraphStyle])
    emptyButton.setAttributedTitle(attributedTitle, for: .normal)
  }
}

private extension CenteredEmptyButtonTableViewCell {
  
  enum UIConstants {
    
    static let backgroundColor = UIColor.clear
    static let font = UIFont.semiBoldAppFont(of: 12)
    static let textColor = UIColor(hex: "0D6843")
    static let buttonHeight: CGFloat = 24.0
  }
}

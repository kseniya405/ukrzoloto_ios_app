//
//  FilledButtonTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 06.10.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit


class FilledButtonTableViewCell: UITableViewCell, Reusable {
  
  private let button: UIButton = {
    
    let button = UIButton(type: .custom)
    button.backgroundColor = UIColor(named: "darkGreen")!
    button.isEnabled = false
    return button
  }()
  
  
  
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
  
  func initConfigure() {
    setupSubviews()
    selectionStyle = .none
    contentView.clipsToBounds = true
  }
  
  func setupSubviews() {
    
    contentView.addSubview(button)
    button.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(60)
      make.bottom.equalToSuperview().offset(-50.0)
    }
    
    let title = Localizator.standard.localizedString("Оформить заказ")
    button.setTitle(title.uppercased(), for: .normal)
  }
}

//
//  CartPriceTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 06.10.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit


class CartPriceTableViewCell: UITableViewCell, Reusable {
  
  private let priceView = DetailedPriceView()
  
  private let bgView: UIView = {
    
    let view = UIView()
    view.layer.cornerRadius = 16.0
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.backgroundColor = UIColor(hex: "#F6F6F6")
    return view
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
  
  func configure(viewModel: PriceDetailsViewModel) {
    
    priceView.configure(with: viewModel)
  }
}

fileprivate extension CartPriceTableViewCell {
  
  func initConfigure() {
    setupSubviews()
    selectionStyle = .none
    contentView.clipsToBounds = true
  }
  
  func setupSubviews() {
    
    contentView.clipsToBounds = true
    contentView.addSubview(priceView)
    priceView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

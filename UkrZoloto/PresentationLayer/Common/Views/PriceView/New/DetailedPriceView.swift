//
//  DetailedPriceView.swift
//  UkrZoloto
//
//  Created by Mykola on 15.11.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

class DetailedPriceView: InitView {
  
  private let bgView: UIView = {
    
    let view = UIView()
    view.backgroundColor = UIConstants.Background.color
    view.layer.cornerRadius = UIConstants.Background.cornerRadius
    view.clipsToBounds = true
    
    return view
  }()
  
  private let mainStackView: UIStackView = {
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10.0
    stackView.prepareForStackView()
    
    return stackView
  }()
  
  private let discountStackView: UIStackView = {
     
    let stackView = UIStackView()
    stackView.prepareForStackView()
    stackView.axis = .vertical
    stackView.spacing = 10.0
    
    return stackView
  }()

  private let goodsStackView = UIStackView()
  
  private let goodsView = IconedPriceView()
	private let exchangeView = IconedPriceView()
  private let deliveryView = IconedPriceView()
  private let cashbackView = IconedPriceView()
  private let totalView = TotalPriceView()
  
  override func initConfigure() {
    super.initConfigure()
    
    configure()
  }
  
  private func configure() {
    
    prepareForStackView()
    
    addSubview(bgView)
    bgView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16.0)
      make.trailing.equalToSuperview().offset(-16.0)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview().offset(-20.0)
    }
    
    addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.leading.equalTo(bgView).offset(15.0)
      make.top.equalTo(bgView).offset(25.0)
      make.trailing.equalTo(bgView).offset(-15.0)
      make.bottom.equalTo(bgView).offset(-25.0)
    }
    
//    let goodsStackView = UIStackView()
    goodsStackView.axis = .vertical
    goodsStackView.spacing = 10.0
    goodsStackView.prepareForStackView()
    
    goodsStackView.addArrangedSubview(goodsView)
    
    let goodsSeparator = createSeparator()
    goodsStackView.addArrangedSubview(goodsSeparator)
    
    mainStackView.addArrangedSubview(goodsStackView)
    
    mainStackView.addArrangedSubview(discountStackView)
    mainStackView.addArrangedSubview(createSeparator())
    mainStackView.addArrangedSubview(deliveryView)
    mainStackView.addArrangedSubview(createSeparator())
    mainStackView.addArrangedSubview(cashbackView)
    mainStackView.addArrangedSubview(createSeparator())
    mainStackView.addArrangedSubview(totalView)
  }
  
  // MARK: - Interface
  func configure(with viewModel: PriceDetailsViewModel) {
      
    //header view: total goods count and total price before discount
    
    if let header = viewModel.header {
      
      switch header {
      case .header(let goodsNumber, _):
  
        goodsView.setup(title: header.title,
                        valueString: header.valueString,
                        icon: header.icon,
                        additionalText: "\(goodsNumber)",
                        textColor: nil)
        
      default: break
        
      }
    }

		if let exchange = viewModel.exchange {
			switch exchange {
			case .exchange(let goodsNumber, _):
				exchangeView.setup(title: exchange.title,
												valueString: exchange.valueString,
												icon: exchange.icon,
												additionalText: "\(goodsNumber)",
												textColor: nil)
				exchangeView.isHidden = false
			default: break
				
			}
			goodsStackView.addArrangedSubview(exchangeView)
		} else {
			exchangeView.isHidden = true
 }
		
		
    goodsStackView.setNeedsLayout()
    goodsStackView.layoutIfNeeded()
    
    discountStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    
    let discountSeparatorIndex = mainStackView.arrangedSubviews.firstIndex(of: discountStackView)! + 1
    
    if viewModel.discounts.count > 0 {
      
      discountStackView.isHidden = false
      mainStackView.arrangedSubviews[discountSeparatorIndex].isHidden = false
      
      viewModel.discounts
        .forEach { item in
        
        switch item {
        case .discount(let discount, let amount):
          
          if amount > 0 {
            
            let view = IconedPriceView()
            view.setup(title: item.title,
                       valueString: item.valueString,
                       icon: item.icon,
                       additionalText: nil,
                       textColor: discount.shouldHighlightValue ? UIColor(named: "red")! : nil)
            
            
            discountStackView.addArrangedSubview(view)
          }
          
        default: break
        }
      }
    
    } else {
      
      mainStackView.arrangedSubviews[discountSeparatorIndex].isHidden = true
      discountStackView.isHidden = true
    }
        
    let deliverySeparatorIndex = mainStackView.arrangedSubviews.firstIndex(of: deliveryView)! + 1
    
    if let delivery = viewModel.delivery, delivery.valueString != "" {
      
      deliveryView.isHidden = false
      mainStackView.arrangedSubviews[deliverySeparatorIndex].isHidden = false
      
      deliveryView.setup(title: delivery.title,
                         valueString: delivery.valueString,
                         icon: delivery.icon,
                         additionalText: nil,
                         textColor: nil)
    } else {
      deliveryView.isHidden = true
      mainStackView.arrangedSubviews[deliverySeparatorIndex].isHidden = true
    }
    
    let cashbackSeparatorIndex = mainStackView.arrangedSubviews.firstIndex(of: cashbackView)! + 1
    
    if let cashback = viewModel.cashback,
       let value = cashback.value,
       value > 0 {
      
      cashbackView.isHidden = false
      mainStackView.arrangedSubviews[cashbackSeparatorIndex].isHidden = false
      cashbackView.setup(title: cashback.title,
                         valueString: cashback.valueString,
                         icon: nil,
                         additionalText: nil,
                         textColor: UIColor(named: "green"))
      cashbackView.setNeedsLayout()
      cashbackView.layoutIfNeeded()
    } else {
      cashbackView.isHidden = true
      mainStackView.arrangedSubviews[cashbackSeparatorIndex].isHidden = true
    }
    
    guard let total = viewModel.total else { return }
    
    totalView.setup(title: total.title, valueString: total.valueString)
    
    [mainStackView, discountStackView, self].forEach { v in
    
      v.setNeedsLayout()
      v.layoutIfNeeded()
    }
    
    setNeedsLayout()
    layoutIfNeeded()
  }
}

fileprivate extension DetailedPriceView {
  
  func createSeparator() -> UIView {
    
    let view = UIView()
    view.backgroundColor = UIColor(named: "card")!
    view.prepareForStackView()
    view.snp.makeConstraints { make in make.height.equalTo(1) }
    
    return view
  }
}


fileprivate enum UIConstants {
  
  enum Background {
    static let color = UIColor(hex: "#F6F6F6")
    static let cornerRadius: CGFloat = 16.0
  }
}

extension UIView {
  
  func prepareForStackView() {
    setContentCompressionResistancePriority(.required, for: .vertical)
    setContentHuggingPriority(.required, for: .vertical)
  }
}

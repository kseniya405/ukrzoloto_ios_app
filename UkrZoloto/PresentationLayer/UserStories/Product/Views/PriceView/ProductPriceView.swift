//
//  ProductPriceView.swift
//  UkrZoloto
//
//  Created by Mykola on 31.10.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

class ProductPriceView: InitView {
  
  private let mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.spacing = UIConstants.MainStackView.spacing
    
    return stackView
  }()
  
  private let priceStackView: UIStackView = {
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 0.0
    stackView.distribution = .fillProportionally
    return stackView
  }()
  
  private let creditStackView: UIStackView = {
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = UIConstants.CreditStackView.spacing
    
    return stackView
  }()
  
  private let creditOptionsStackView: UIStackView = {
      
    let stackView = UIStackView()
    
    stackView.axis = .horizontal
    stackView.spacing = UIConstants.CreditStackView.spacing
    
    return stackView
  }()
  
  private let separatorView: UIView = {
    
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIConstants.Separator.color

    view.snp.makeConstraints { make in
      make.width.equalTo(1.0)
    }
    
    view.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    return view
  }()
  
  private let monthlyPaymentLabel = UILabel()
  
  private let priceLabel = UILabel()
  private let oldPriceLabel = UILabel()
    
  override func initConfigure() {
    super.initConfigure()
    
    configureSelf()
  }
  
  func setupContent(price: Price,
                    credits: [CreditOption]) {
    
    priceLabel.attributedText = StringComposer.shared.getPriceAttributedString(price: price)
    oldPriceLabel.attributedText = StringComposer.shared.getOldPriceAttriburedString(price: price)

		let displayableCredits = credits.filter({ $0.showAsIcon })
    
    guard !displayableCredits.isEmpty else {
      
      mainStackView.removeArrangedSubviews([separatorView, creditStackView])
      priceStackView.snp.removeConstraints()
      
      return
    }
    
    creditOptionsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    
    displayableCredits.forEach { credit in
      let currentCreditView = CreditView()
			if let iconImage = Bank(rawValue: credit.code)?.getIcon() {
				currentCreditView.setup(icon: iconImage)
			} else {
				currentCreditView.setup(icon: credit.icon)
			}
			
      creditOptionsStackView.addArrangedSubview(currentCreditView)
    }
    
    if let monthlyPayment = CreditCalculator.getLowestMonthlyPayment(price: price, credits: credits) {
      
      monthlyPaymentLabel.attributedText = StringComposer.shared.getLowestMonthlyPaymentAttributedString(payment: monthlyPayment)
      
    }
  }
  
  private func configureSelf() {
    
    let sectionWidth = UIScreen.main.bounds.width / 2
    - 24 // component leading offset
    - UIConstants.MainStackView.spacing
    - 1 // separatorWidth
    
    priceStackView.snp.makeConstraints { make in
      make.width.equalTo(sectionWidth)
    }
    
    creditStackView.snp.makeConstraints { make in
      make.width.equalTo(sectionWidth)
    }
    
    backgroundColor = .white
    
    addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.bottom.equalToSuperview()
    }

    priceLabel.textAlignment = .center
    oldPriceLabel.textAlignment = .center
    
    priceStackView.addArrangedSubview(oldPriceLabel)
    priceStackView.addArrangedSubview(priceLabel)
        
    priceStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    let creditsContainerView = UIView()
    creditsContainerView.addSubview(creditOptionsStackView)
    creditOptionsStackView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    creditStackView.addArrangedSubview(creditsContainerView)
    creditStackView.addArrangedSubview(monthlyPaymentLabel)
    
    mainStackView.addArrangedSubview(priceStackView)
    mainStackView.addArrangedSubview(separatorView)
    mainStackView.addArrangedSubview(creditStackView)
    
    monthlyPaymentLabel.textAlignment = .left
  }
}

private enum UIConstants {
  enum MainStackView {
    static let spacing: CGFloat = 10.0
  }
  
  enum CreditStackView {
    static let spacing: CGFloat = -2.0
  }
  
  enum Separator {
    static let color = UIColor(hex: "#F1F1F1")
  }
}

private class CreditView: InitView {
  private let imageView: UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  override func initConfigure() {
    super.initConfigure()
  
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.height.width.equalTo(16.0)
      make.trailing.equalToSuperview()
    }
  }
  
  func setup(icon: String?) {
		if let path = icon {
			imageView.contentMode = .center
			imageView.setImage(path: path, size:
													CGSize(width: 16,
																 height: 16))
			imageView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
			imageView.roundCorners(radius: 12,
														 borderWidth: 1,
														 borderColor: #colorLiteral(red: 0.892, green: 0.892, blue: 0.892, alpha: 1).cgColor)
			imageView.contentMode = .center
		} else {
			imageView.image = nil
		}
  }
	
	func setup(icon: UIImage?) {
		if let icon = icon {
			imageView.contentMode = .scaleAspectFit
			imageView.image = icon
			imageView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
			imageView.roundCorners(radius: 12,
													 borderWidth: 1,
													 borderColor: #colorLiteral(red: 0.892, green: 0.892, blue: 0.892, alpha: 1).cgColor)
		} else {
			imageView.image = nil
		}
	}
}

//
//  RegisteredUserView.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 30.06.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit

class RegisteredUserView: InitView {
    private let discountStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = UIConstants.DiscountStackView.spacing
        stackView.backgroundColor = .clear
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.setContentHuggingPriority(.required, for: .vertical)
        return stackView
    }()
    
    private let discountLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIConstants.DiscountStackView.titlesLabelFont
        label.textColor = UIConstants.DiscountStackView.textColor
        label.numberOfLines = 0
        label.backgroundColor = .clear

      label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    private let discountValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIConstants.DiscountStackView.numbersLabelFont
        label.textColor = UIConstants.DiscountStackView.textColor
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow-1, for: .horizontal)
        
        return label
    }()
    
    private let cashbackLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIConstants.DiscountStackView.titlesLabelFont
        label.textColor = UIConstants.DiscountStackView.textColor
        label.numberOfLines = 0
        label.backgroundColor = .clear
      label.setContentCompressionResistancePriority(.required, for: .horizontal)

        return label
    }()
    
    private let cashbackValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIConstants.DiscountStackView.numbersLabelFont
        label.textColor = UIConstants.DiscountStackView.textColor
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow-1, for: .horizontal)
        
        return label
    }()
    
    override func initConfigure() {
        super.initConfigure()
        
        configureDiscountView()
    }
    
    private func configureDiscountView() {
        localize()
        addSubview(discountStackView)
        
        discountStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIConstants.DiscountStackView.top)
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(UIConstants.DiscountStackView.height)
        }
        
        let persentsImageView = UIImageView(image: UIImage(named: "discount_icon"))
        persentsImageView.backgroundColor = .clear
        discountStackView.addArrangedSubview(persentsImageView)
        persentsImageView.snp.makeConstraints { make in
            make.height.width.equalTo(UIConstants.DiscountStackView.height)
        }
        discountValueLabel.text = "  "
        discountValueLabel.snp.makeConstraints { make in
            make.height.width.equalTo(UIConstants.DiscountStackView.height)
        }
        discountStackView.addArrangedSubview(discountLabel)
        discountStackView.addArrangedSubview(discountValueLabel)
        
        let cashbackImageView = UIImageView(image: UIImage(named: "bonus_usage_icon"))
        cashbackImageView.backgroundColor = .clear
      cashbackImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        discountStackView.addArrangedSubview(cashbackImageView)
        cashbackImageView.snp.makeConstraints { make in
            make.height.width.equalTo(UIConstants.DiscountStackView.height)
        }
        cashbackValueLabel.text = "  "

        cashbackValueLabel.snp.makeConstraints { make in
          make.height.width.equalTo(40)
          make.width.equalTo(40)
          make.width.width.equalTo(40)
        }
        discountStackView.addArrangedSubview(cashbackLabel)
        discountStackView.addArrangedSubview(cashbackValueLabel)
    }
    
    public func update(_ price: Price, discount: Int) {
        localize()
        
        discountValueLabel.text = "\(discount)" + "%"
        cashbackValueLabel.text = calculateCashback(price)
    }
    
    private func localize() {
        discountLabel.text = Localizator.standard.localizedString("Скидка")
        cashbackLabel.text = Localizator.standard.localizedString("Кэшбэк")
    }
    
    private func calculateCashback(_ price: Price) -> String? {
        let updatedPrice = Price(
            current: PriceCalculationService.shared.calculateCashback(price),
            old: price.old,
            discount: price.discount)
        
        return StringComposer.shared.getPriceAttributedString(price: updatedPrice, isLongCurrency: false)?.string
    }
    
    private func roundCurrenPrice(_ priceValue: Decimal) -> Decimal {
        let roundingBehavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let decimalNumber = NSDecimalNumber(decimal: priceValue)
        let roundedNumber = decimalNumber.rounding(accordingToBehavior: roundingBehavior)
        
        return roundedNumber.decimalValue
    }
}

fileprivate enum UIConstants {
    enum MainView {
        static let height: CGFloat = 148
        static let imageSize: CGFloat = 85
        static let cornerRadius: CGFloat = 22
        static let icon = UIImage(named: "bigPercentsIcon")!
        static let gradient = [.white, UIColor(red: 1, green: 0.95, blue: 0.89, alpha: 1)]
        static let borderColor = UIColor(named: "card")!
        static let borderWidth: CGFloat = 1
    }
    
    enum DiscountStackView {
        static let height: CGFloat = 24
        static let top: CGFloat = 5
        static let spacing: CGFloat = 5
        static let leading: CGFloat = 20
        static let textColor = UIColor(hex: "#1F2323")
        static let titlesLabelFont = UIFont.regularAppFont(of: 16)
        static let numbersLabelFont = UIFont.boldAppFont(of: 14)
    }
}

//
//  CartItemTableViewCell.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/5/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol CartItemTableViewCellDelegate: AnyObject {
  func didTapOnRemoveFromCart(in tableViewCell: CartItemTableViewCell)
	func didTapOnExchange(exchangeVariant: ExchangeItem, in tableViewCell: CartItemTableViewCell)
	func exchangeOptionInfoTapped(_ cell: CartItemTableViewCell, rect: CGRect)
	func exchangeCellTappedMonths(_ cell: CartItemTableViewCell)
}

class CartItemTableViewCell: UITableViewCell, Reusable {

  // MARK: - Public variables
  var delegate: CartItemTableViewCellDelegate?
  
  // MARK: - Private variables
  private let itemImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = UIConstants.ItemImageView.backgroundColor
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.TitleLabel.height
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.color)
      .numberOfLines(UIConstants.TitleLabel.numbersOfLines)
    return label
  }()
  
  private let sizeTitleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.SizeTitleLabel.font)
      .textColor(UIConstants.SizeTitleLabel.color)
      .numberOfLines(UIConstants.SizeTitleLabel.numbersOfLines)
    return label
  }()
  
  private let sizeValueLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.SizeValueLabel.font)
      .textColor(UIConstants.SizeValueLabel.color)
      .numberOfLines(UIConstants.SizeValueLabel.numbersOfLines)
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.config
      .textColor(UIConstants.PriceLabel.color)
      .numberOfLines(UIConstants.PriceLabel.numbersOfLines)
    return label
  }()
  
  private let oldPriceLabel: UILabel = {
    let label = UILabel()
    label.config
      .textColor(UIConstants.OldPriceLabel.color)
      .numberOfLines(UIConstants.OldPriceLabel.numbersOfLines)
    return label
  }()
	
	private let exchangeContainerView = UIView()
	
	private let checkboxImageView = UIImageView()
	
	private let exchangeTitleLabel: UILabel = {
		let label = UILabel()
		label.config
			.font(UIConstants.ExchangeTitle.font)
			.textColor(UIConstants.ExchangeTitle.color)
		return label
	}()
	
	private let exchangeVariantsView: UIView = {
		let view = UIView()
		view.roundCorners(corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 12, borderWidth: 1, borderColor: UIConstants.ExchangeVariantsLabel.borderColor)
		return view
	}()
	
	private let exhangeVariantTextLabel: UILabel = {
		let label = UILabel()
		label.config
			.font(UIConstants.ExchangeVariantsLabel.font)
			.textColor(UIConstants.ExchangeVariantsLabel.color)
		return label
	}()
	
	private let exchangeVariantImageView = UIImageView()
	
	private let exchangeTooltipView = UIView()
	
	private let exchangeTooltipImageView = UIImageView()
	
	private let exchangeTooltipText: UILabel = {
		let label = UILabel()
		label.config
			.font(UIConstants.ExchangeTooltipLabel.font)
			.textColor(UIConstants.ExchangeTooltipLabel.color)
		return label
	}()
  
  private let removeButton = UIButton()
	
	private var cartItem: CartItem? = nil
  
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
    backgroundColor = UIConstants.backgroundColor
    setupItemImageView()
    setupTitleLabel()
    setupSizeTitleLabel()
    setupSizeValueLabel()
    setupPriceLabel()
    setupOldPriceLabel()
    setupRemoveButton()
		setupExchangeView()
		setupExchangeActions()
  }
	
	private func setupExchangeView() {
		contentView.addSubview(exchangeContainerView)
		exchangeContainerView.backgroundColor = .white
		exchangeContainerView.snp.makeConstraints { make in
			make.top.equalTo(priceLabel.snp.bottom).offset(12)
			make.bottom.equalToSuperview().inset(12)
			make.height.equalTo(30)
			make.leading.trailing.equalToSuperview().inset(UIConstants.ItemImageView.leading)
		}
		exchangeContainerView.addSubview(checkboxImageView)
		checkboxImageView.snp.makeConstraints { make in
			make.leading.equalToSuperview()
			make.centerY.equalToSuperview()
			make.height.width.equalTo(24)
		}
		exchangeContainerView.addSubview(exchangeTitleLabel)
		exchangeTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(checkboxImageView.snp.trailing).offset(4)
			make.centerY.equalToSuperview()
		}
		exchangeContainerView.addSubview(exchangeVariantsView)
		exchangeVariantsView.snp.makeConstraints { make in
			make.leading.equalTo(exchangeTitleLabel.snp.trailing).offset(4)
			make.top.bottom.equalToSuperview()
		}
		exchangeVariantsView.addSubview(exhangeVariantTextLabel)
		exhangeVariantTextLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(8)
			make.centerY.equalToSuperview()
		}
		exchangeVariantsView.addSubview(exchangeVariantImageView)
		exchangeVariantImageView.snp.makeConstraints { make in
			make.leading.equalTo(exhangeVariantTextLabel.snp.trailing)
			make.trailing.equalToSuperview().inset(8)
			make.height.width.equalTo(14)
			make.centerY.equalToSuperview()
		}
		exchangeContainerView.addSubview(exchangeTooltipView)
		exchangeTooltipView.snp.makeConstraints { make in
			make.leading.equalTo(exchangeVariantsView.snp.trailing).offset(4)
			make.centerY.equalToSuperview()
			make.trailing.lessThanOrEqualToSuperview()
			make.height.equalToSuperview()
		}
		exchangeTooltipView.addSubview(exchangeTooltipImageView)
		exchangeTooltipImageView.snp.makeConstraints { make in
			make.leading.equalToSuperview()
			make.centerY.equalToSuperview()
			make.height.width.equalTo(20)
		}
		exchangeTooltipView.addSubview(exchangeTooltipText)
		exchangeTooltipText.snp.makeConstraints { make in
			make.leading.equalTo(exchangeTooltipImageView.snp.trailing).offset(4)
			make.trailing.equalToSuperview()
			make.centerY.equalToSuperview()
		}
	}
  
  private func setupItemImageView() {
    itemImageView.contentMode = .scaleAspectFit
    itemImageView.layer.borderColor = UIConstants.ItemImageView.borderColor.cgColor
    itemImageView.layer.borderWidth = UIConstants.ItemImageView.borderWidth
    itemImageView.layer.cornerRadius = UIConstants.ItemImageView.cornerRadius
    contentView.addSubview(itemImageView)
    itemImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().inset(UIConstants.ItemImageView.leading)
      make.height.width.equalTo(UIConstants.ItemImageView.side)
    }
  }
  
  private func setupTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(itemImageView)
      make.leading.equalTo(itemImageView.snp.trailing).offset(UIConstants.TitleLabel.leading)
    }
  }
  
  private func setupSizeTitleLabel() {
    contentView.addSubview(sizeTitleLabel)
    sizeTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.SizeTitleLabel.top)
      make.leading.equalTo(titleLabel)
    }
    sizeTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
    sizeTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  private func setupSizeValueLabel() {
    contentView.addSubview(sizeValueLabel)
    sizeValueLabel.snp.makeConstraints { make in
      make.firstBaseline.equalTo(sizeTitleLabel)
      make.leading.equalTo(sizeTitleLabel.snp.trailing)
    }
  }
  
  private func setupPriceLabel() {
    contentView.addSubview(priceLabel)
    priceLabel.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel)
      make.bottom.equalTo(itemImageView)
    }
  }
  
  private func setupOldPriceLabel() {
    contentView.addSubview(oldPriceLabel)
    oldPriceLabel.snp.makeConstraints { make in
      make.leading.equalTo(priceLabel.snp.trailing).offset(UIConstants.OldPriceLabel.leading)
      make.trailing.lessThanOrEqualTo(titleLabel)
      make.firstBaseline.equalTo(priceLabel)
    }
  }
  
  private func setupRemoveButton() {
    removeButton.setTitle(nil, for: .normal)
    removeButton.setImage(#imageLiteral(resourceName: "removeFromCart"), for: .normal)
    removeButton.addTarget(self, action: #selector(remove), for: .touchUpInside)
    contentView.addSubview(removeButton)
    removeButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(titleLabel.snp.trailing).offset(UIConstants.RemoveButton.leading)
      make.width.height.equalTo(UIConstants.RemoveButton.side)
      make.trailing.equalToSuperview().inset(UIConstants.RemoveButton.trailing)
    }
  }
	
	private func setupExchangeActions() {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(CartItemTableViewCell.tapOnExchange))
		exchangeContainerView.isUserInteractionEnabled = true
		exchangeContainerView.addGestureRecognizer(gesture)
		exchangeVariantsView.isUserInteractionEnabled = true
		exchangeVariantsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnVariants)))
		exchangeTooltipView.isUserInteractionEnabled = true
		exchangeTooltipView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onInfoButtonTap)))
		
	}
	
	private func configureExchangeView(cartItem: CartItem) {
		if cartItem.availableExchangeVariants.isEmpty {
			exchangeContainerView.snp.updateConstraints{ make in
				make.height.equalTo(0)
			}
			exchangeContainerView.isHidden = true
			return
		}
		exchangeContainerView.isHidden = false
		exchangeContainerView.snp.updateConstraints{ make in
			make.height.equalTo(30)
		}
		exchangeTitleLabel.text = Localizator.standard.localizedString("Обмен украшений")
		let preselectedExchangeVariant = cartItem.preselectedExchangeVariant
		switch preselectedExchangeVariant {
		case .sixMonths:
			exhangeVariantTextLabel.text = Localizator.standard.localizedString("6 мес")
		case .nineMonths:
			exhangeVariantTextLabel.text = Localizator.standard.localizedString("9 мес")
		case .none:
			exhangeVariantTextLabel.text = " - "
		}
		if let option = cartItem.exchangeOptions[preselectedExchangeVariant.rawValue] {
			exchangeTooltipText.text = "+" + String(option.price)
		}
		exchangeVariantImageView.image = #imageLiteral(resourceName: "bottomArrowSlim")
		exchangeTooltipImageView.image = #imageLiteral(resourceName: "info_icon_highlighted")
		var selectedExchangeVariant: ExchangeItem = .none
		for service in cartItem.services ?? [] {
			for option in service.options {
					if option.selected {
						if let item = ExchangeItem(rawValue: option.code), option.price != 0 {
							selectedExchangeVariant = item
						}
					}
			}
		}
		if preselectedExchangeVariant != selectedExchangeVariant {
			checkboxImageView.image = 	#imageLiteral(resourceName: "iconsCheckBoxDisactive")
			return
		}
		switch selectedExchangeVariant {
		case .sixMonths:
			checkboxImageView.image = #imageLiteral(resourceName: "iconsCheckBoxActive")
		case .nineMonths:
			checkboxImageView.image = #imageLiteral(resourceName: "iconsCheckBoxActive")
			exhangeVariantTextLabel.text = Localizator.standard.localizedString("9 мес")
		case .none:
			checkboxImageView.image = 	#imageLiteral(resourceName: "iconsCheckBoxDisactive")
			if cartItem.preselectedExchangeVariant == .nineMonths {
				exhangeVariantTextLabel.text = Localizator.standard.localizedString("9 мес")
			}
		}
	}
  
  // MARK: - Interface
  func configure(cartItem: CartItem) {
		self.cartItem = cartItem
    itemImageView.setImage(url: cartItem.imageURL, placeholder: #imageLiteral(resourceName: "placeholderProductTIle"))
    titleLabel.text = cartItem.name
    if let size = cartItem.size,
      !size.isEmpty {
      sizeTitleLabel.text = Localizator.standard.localizedString("Размер:") + " "
      sizeValueLabel.text = size
    } else {
      sizeTitleLabel.text = nil
      sizeValueLabel.text = nil
    }
    priceLabel.attributedText = StringComposer.shared.getPriceAttributedString(price: cartItem.price,
                                                                               style: UIConstants.PriceLabel.style)
    oldPriceLabel.attributedText = StringComposer.shared.getOldPriceAttriburedString(price: cartItem.price,
                                                                                     style: UIConstants.OldPriceLabel.style)
		configureExchangeView(cartItem: cartItem)
  }
  
  // AMRK: - Actions
  @objc
  private func remove() {
    delegate?.didTapOnRemoveFromCart(in: self)
  }
	
	@objc
	private func tapOnExchange() {
		var _: ExchangeItem = .none
		guard let item = self.cartItem else { return }
		for service in item.services ?? [] {
			for option in service.options {
				if option.selected, option.code == item.preselectedExchangeVariant.rawValue {
						delegate?.didTapOnExchange(exchangeVariant: .none, in: self)
						return
					}
			}
		}
		delegate?.didTapOnExchange(exchangeVariant: item.preselectedExchangeVariant, in: self)
	}
	
	@objc func onInfoButtonTap() {
		let rect = self.convert(exchangeTooltipImageView.frame, 
														to: UIApplication.shared.windows.filter {$0.isKeyWindow}.first)
				delegate?.exchangeOptionInfoTapped(self, rect: rect)
	}
	
	@objc func tapOnVariants() {
		delegate?.exchangeCellTappedMonths(self)
	}
}

// MARK: - UIConstants
private enum UIConstants {
  static let backgroundColor = UIColor.clear
  
  enum ItemImageView {
    static let backgroundColor = UIColor.white
    static let cornerRadius: CGFloat = 16
    static let borderColor = UIColor.color(r: 246, g: 246, b: 246)
    static let borderWidth: CGFloat = 1

    static let leading: CGFloat = 24
    static let bottom: CGFloat = 12
    static let side: CGFloat = 100
  }
  
  enum TitleLabel {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.regularAppFont(of: 13)
    static let height: CGFloat = 16.9
    static let numbersOfLines: Int = 2
    static let leading: CGFloat = 16
  }
  
  enum SizeTitleLabel {
    static let color = UIColor.color(r: 132, g: 149, b: 147)
    static let font = UIFont.regularAppFont(of: 12)
    static let numbersOfLines: Int = 1
    static let top: CGFloat = 8
  }
  
  enum SizeValueLabel {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let font = UIFont.regularAppFont(of: 13)
    static let height: CGFloat = 16.9
    static let numbersOfLines: Int = 0
  }
  
  enum PriceLabel {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let numbersOfLines: Int = 0
    static let style = PriceStyle(font: UIFont.boldAppFont(of: 16),
                                  currencyFont: UIFont.semiBoldAppFont(of: 12))
  }
  
  enum OldPriceLabel {
    static let color = UIColor.color(r: 4, g: 35, b: 32)
    static let numbersOfLines: Int = 0
    static let style = PriceStyle(font: UIFont.regularAppFont(of: 12),
                                  currencyFont: UIFont.regularAppFont(of: 14))
    static let leading: CGFloat = 12
  }
  
  enum RemoveButton {
    static let leading: CGFloat = 8
    static let trailing: CGFloat = 16
    static let side: CGFloat = 28
  }
	
	enum ExchangeTitle {
		static let font = UIFont.semiBoldAppFont(of: 13)
		static let color = UIColor.color(r: 4, g: 35, b: 32)
	}
	
	enum ExchangeVariantsLabel {
		static let font = UIFont.boldAppFont(of: 13)
		static let color = UIColor.color(r: 4, g: 35, b: 32)
		static let borderColor = UIColor(red: 0.122, green: 0.137, blue: 0.137, alpha: 0.25).cgColor
	}
	
	enum ExchangeTooltipLabel {
		static let font = UIFont.semiBoldAppFont(of: 13)
		static let color = UIColor.color(r: 136, g: 144, b: 143)
	}
}

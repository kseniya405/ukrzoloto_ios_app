//
//  CreditOptionTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 25.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

protocol CreditOptionTableViewCellDelegate: AnyObject {
  
  func bankOptionInfoTapped(_ cell: CreditOptionTableViewCell, rect: CGRect)
  func bankOptionSelected(_ cell: CreditOptionTableViewCell)
  func bankOptionCellTappedMonths(_ cell: CreditOptionTableViewCell)
}

class CreditOptionTableViewCell: UITableViewCell, Reusable {
  
  private(set) var bank: Bank!
    
  weak var delegate: CreditOptionTableViewCellDelegate?
  
  private let bankImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  private let label: LineHeightLabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.TitleLabel.font)
      .textColor(UIConstants.TitleLabel.textColor)
      .numberOfLines(0)
    label.lineHeight = UIConstants.TitleLabel.lineHeight
    
    return label
  }()
  
  private let infoButton: UIButton = {
    
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "info_icon"), for: .normal)
    
    return button
  }()
  
  private let comissionTextLabel: LineHeightLabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.ComissionTextLabel.font)
      .textColor(UIConstants.ComissionTextLabel.textColor)
    label.lineHeight = UIConstants.ComissionTextLabel.lineHeight
    return label
  }()
  
  private let comissionValueLabel: LineHeightLabel = {
    
    let label = LineHeightLabel()
    label.config
      .font(UIConstants.ComissionValueLabel.font)
      .textColor(UIConstants.ComissionValueLabel.textColor)
    return label
  }()
  
  private let expandIndicatorView: UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = #imageLiteral(resourceName: "arrow_down_black")
    return imageView
  }()
  
  private let monthsView: CreditMonthView = {
    
    let view = CreditMonthView()
    view.backgroundColor = .white
    view.layer.cornerRadius = UIConstants.Dropdown.corderRadius
    view.layer.borderWidth = 1.0
    view.layer.borderColor = UIConstants.Dropdown.borderColor.cgColor
      
    view.clipsToBounds = true
    
    return view
  }()
  
  private let monthPaymentLabel: UILabel = {
    
    let label = UILabel()
    label.config
      .font(UIConstants.MonthPaymentLabel.font)
      .textColor(UIConstants.MonthPaymentLabel.textColor)
    
    return label
  }()
  
  private let button: UIButton = {
    
    let button = UIButton()
    button.layer.cornerRadius = UIConstants.Button.height / 2
    button.clipsToBounds = true
    button.backgroundColor = UIConstants.Button.backgroundColor
    button.titleLabel?.font = UIConstants.Button.font
    
    return button
  }()
  
  private var viewsToAnimate = [UIView]()
  
  private(set) var expanded: Bool = false
  
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
    setupSubviews()
    selectionStyle = .none
    contentView.clipsToBounds = true
  }
  
  private func setupSubviews() {
    
    contentView.addSubview(bankImageView)
    bankImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.BankIcon.leftPadding)
      make.top.equalToSuperview().offset(UIConstants.BankIcon.topOffset)
      make.width.height.equalTo(UIConstants.BankIcon.width)
    }
    
    contentView.addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.equalTo(bankImageView.snp.trailing).offset(UIConstants.TitleLabel.leftPadding)
      make.width.equalTo(120.0)
      make.centerY.equalTo(bankImageView.snp.centerY)
    }
    
    contentView.addSubview(infoButton)
    infoButton.snp.makeConstraints { make in
      make.leading.equalTo(label.snp.trailing).offset(UIConstants.InfoButton.leftPadding)
      make.centerY.equalTo(bankImageView.snp.centerY)
      make.width.height.equalTo(UIConstants.InfoButton.width)
    }
    infoButton.addTarget(self, action: #selector(onInfoButtonTap(_:)), for: .touchUpInside)
    
    contentView.addSubview(expandIndicatorView)
    expandIndicatorView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-UIConstants.Arrow.rightPadding)
      make.height.width.equalTo(UIConstants.Arrow.size)
      make.centerY.equalTo(infoButton.snp.centerY)
    }
    
    contentView.addSubview(comissionTextLabel)
    comissionTextLabel.snp.makeConstraints { make in
      make.leading.equalTo(label.snp.leading)
      make.top.equalTo(label.snp.bottom).offset(UIConstants.ComissionTextLabel.topPadding)
    }
    
    contentView.addSubview(comissionValueLabel)
    comissionValueLabel.snp.makeConstraints { make in
      make.leading.equalTo(comissionTextLabel.snp.trailing).offset(UIConstants.ComissionValueLabel.leftPadding)
      make.bottom.equalTo(comissionTextLabel.snp.bottom).offset(2)
    }
    
    contentView.addSubview(monthsView)
    monthsView.snp.makeConstraints { make in
      make.leading.equalTo(label.snp.leading)
      make.top.equalTo(comissionTextLabel.snp.bottom).offset(UIConstants.Dropdown.topPadding)
      make.width.equalTo(UIConstants.Dropdown.width)
      make.height.equalTo(UIConstants.Dropdown.height)
    }
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(onMonthsTapped(_:)))
    monthsView.addGestureRecognizer(tap)
    monthsView.isUserInteractionEnabled = true 
    
    contentView.addSubview(monthPaymentLabel)
    monthPaymentLabel.snp.makeConstraints { make in
      make.leading.equalTo(monthsView.snp.trailing).offset(UIConstants.MonthPaymentLabel.leftPadding)
      make.centerY.equalTo(monthsView.snp.centerY)
    }
    
    contentView.addSubview(button)
    button.snp.makeConstraints { make in
      make.leading.equalTo(monthsView.snp.leading)
      make.trailing.equalToSuperview().offset(-UIConstants.Button.rightPadding)
      make.height.equalTo(UIConstants.Button.height)
      make.top.equalTo(monthsView.snp.bottom).offset(UIConstants.Button.topPadding)
    }

    button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
    
    viewsToAnimate.append(comissionTextLabel)
    viewsToAnimate.append(comissionValueLabel)
    viewsToAnimate.append(monthsView)
    viewsToAnimate.append(monthPaymentLabel)
    viewsToAnimate.append(button)
  }
  
  func configure(bank: Bank, title: String, comissionRate: Double, months: Int, monthlyPayment: Int, expanded: Bool) {
    
    self.bank = bank

    bankImageView.image = bank.getIcon()
		bankImageView.contentMode = .scaleAspectFit
		bankImageView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
		bankImageView.roundCorners(radius: UIConstants.BankIcon.width / 2,
												 borderWidth: 1,
												 borderColor: #colorLiteral(red: 0.892, green: 0.892, blue: 0.892, alpha: 1).cgColor)
    label.text = title
    comissionTextLabel.text = Localizator.standard.localizedString("Ежемесячная комиссия")
        
    comissionValueLabel.text = {
      if comissionRate == 0 {
        return "0 %"
      } else {
        return NSString(format: "%1.1f%%", comissionRate) as String
      }
    }()
    
    monthPaymentLabel.text = "по \(monthlyPayment) ₴"
    
    let buttonTitle = Localizator.standard.localizedString("Оформить").uppercased()
    button.setTitle(buttonTitle, for: .normal)
    button.setTitleColor(UIConstants.Button.textColor, for: .normal)
    
    monthsView.updateMonths(months)
    
    setExpanded(expanded, animated: true)
  }
  
  func setExpanded(_ expanded: Bool, animated: Bool) {
    
    self.expanded = expanded
    
    UIView.animate(withDuration: animated ? 0.25 : 0.0) {
      
      self.expandIndicatorView.transform = expanded ? .identity : CGAffineTransform(rotationAngle: .pi)
      
      self.viewsToAnimate.forEach { view in
        view.alpha = self.expanded ? 1.0 : 0.0
      }
    }
  }
  
  func setInfoIcon(highlighted: Bool) {
    let image = highlighted ? UIConstants.InfoButton.infoIconHighlighted : UIConstants.InfoButton.infoIcon
    infoButton.setImage(image, for: .normal)
  }
  
  @objc func onInfoButtonTap(_ sender: UIButton) {

    let rect = self.convert(sender.frame, to: UIApplication.shared.windows.filter {$0.isKeyWindow}.first)
    
    delegate?.bankOptionInfoTapped(self, rect: rect)
  }
  
  @objc func onButtonTap(_ sender: UIButton) {
    delegate?.bankOptionSelected(self)
  }
  
  @objc func onMonthsTapped(_ sender: UITapGestureRecognizer) {
    delegate?.bankOptionCellTappedMonths(self)
  }
}

private enum UIConstants {
  
  enum TitleLabel {
    static let font = UIFont.semiBoldAppFont(of: 15)
    static let textColor = UIColor(hex: "#1F2323")
    static let lineHeight: CGFloat = 18.0
    static let leftPadding: CGFloat = 33.0
  }
  
  enum BankIcon {
    static let width: CGFloat = 32.0
    static let leftPadding: CGFloat = 38.0
    static let topOffset: CGFloat = 33.0
  }
  
  enum InfoButton {
    static let leftPadding: CGFloat = 10.0
    static let width: CGFloat = 24.0
    static let infoIcon = #imageLiteral(resourceName: "info_icon")
    static let infoIconHighlighted = #imageLiteral(resourceName: "info_icon_highlighted")
  }
  
  enum ComissionTextLabel {
    static let font = UIFont.regularAppFont(of: 12)
    static let textColor = UIColor.black.withAlphaComponent(0.45)
    static let topPadding: CGFloat = 12.0
    static let lineHeight: CGFloat = 15.6
  }
  
  enum ComissionValueLabel {
    static let font = UIFont.semiBoldAppFont(of: 18)
    static let textColor = UIColor(hex: "#1F2323")
    static let leftPadding: CGFloat = 6.0
  }
  
  enum Arrow {
    static let rightPadding: CGFloat = 50.0
    static let size: CGFloat = 24.0
  }
  
  enum Dropdown {
    static let width: CGFloat = 80.0
    static let height: CGFloat = 40.0
    static let topPadding: CGFloat = 25.0
    static let corderRadius: CGFloat = 20.0
    static let borderColor = UIColor(hex: "#C7C8C8")
  }
  
  enum MonthPaymentLabel {
    static let leftPadding: CGFloat = 15.0
    static let font = UIFont.semiBoldAppFont(of: 18)
    static let textColor = UIColor(hex: "#1F2323")
  }
  
  enum Button {
    static let backgroundColor = UIColor(hex: "#FFDC88")
    static let textColor = UIColor(hex: "#1F2323")
    static let height: CGFloat = 40.0
    static let topPadding: CGFloat = 10.0
    static let rightPadding: CGFloat = 53.0
    static let font = UIFont.semiBoldAppFont(of: 12)
    static let bottomPadding: CGFloat = 24.0
  }
}

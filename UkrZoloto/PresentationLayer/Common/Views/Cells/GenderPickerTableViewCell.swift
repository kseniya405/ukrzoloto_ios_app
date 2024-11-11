//
//  GenderPickerTableViewCell.swift
//  UkrZoloto
//
//  Created by Mykola on 06.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import UIKit

protocol GenderPickerTableViewCellDelegate: AnyObject {
  
  func genderPickerChangeSelection(to gender: Gender)
}

class GenderPickerTableViewCell: UITableViewCell, Reusable {
  
  weak var delegate: GenderPickerTableViewCellDelegate?
  
  private let stackView: UIStackView = {
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = UIConstants.stackViewSpacing
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let label: UILabel = {
    
    let label = UILabel()
    label.textColor = UIConstants.titleColor
    label.font = UIConstants.titleFont
    label.text = Localizator.standard.localizedString("Пол")
    label.alpha = 0.45
    
    return label
  }()
  
  private let errorLabel: UILabel = {
    let label = UILabel()
    label.config
      .textAlignment(.left)
      .font(.regularAppFont(of: 12))
      .textColor(UIConstants.Error.color)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentHuggingPriority(.required, for: .vertical)
    label.text = Localizator.standard.localizedString("Выберите ваш пол")

    return label
  }()
  
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
  
  //MARK: - Public methods
  
  func setGenderSelected(gender: Gender) {
    
    stackView.arrangedSubviews.forEach { container in
      
      guard let imageView = container.subviews.filter({ $0 is UIImageView}).first as? UIImageView else { return }
      imageView.image = nil
    }
    
    let index = indexFor(gender: gender)
    let view = stackView.arrangedSubviews[index]
    
    let imageView = view.subviews.filter({ $0 is UIImageView}).first as? UIImageView
    imageView?.image = UIConstants.selectedIcon
  }
  
  func setError() {
    errorLabel.isHidden = false
  }
  
  func resetError() {
    errorLabel.isHidden = true
  }
  
  //MARK: - Private methods
  private func initConfigure() {
    selectionStyle = .none
    configureSelfView()
    configureTitleLabel()
    configureStackView()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.backgroundColor
  }
  
  private func configureTitleLabel() {
    contentView.addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.offset)
      make.top.equalToSuperview()
    }
  }
  
  private func configureStackView() {
    
    contentView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.top.equalTo(label.snp.bottom).offset(UIConstants.topOffset)
      make.leading.equalToSuperview().offset(UIConstants.offset)
      make.centerX.equalToSuperview()
      make.height.equalTo(UIConstants.height)
    }
    
    contentView.addSubview(errorLabel)
    errorLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(UIConstants.offset)
      make.top.equalTo(stackView.snp.bottom).offset(4.0)
      make.bottom.equalToSuperview().offset(-4.0)
    }
    resetError()
    
    var counter = 0
    Gender.allCases.forEach { gender in
      
      let view = constructContentView(title: gender.stringRepresentation)
      let tap = UITapGestureRecognizer(target: self, action: #selector(onArrangedSubviewTap(_:)))
      
      view.addGestureRecognizer(tap)
      view.tag = counter
      
      stackView.addArrangedSubview(view)
      counter += 1
    }
  }
  
  private func constructContentView(title: String) -> UIView {
    
    let view = UIView()
    
    let imageView = UIImageView()
    imageView.backgroundColor = UIConstants.indicatorEmptyBackgroundColor
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = UIConstants.height/2
    view.addSubview(imageView)
    
    imageView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.height)
      make.width.equalTo(UIConstants.height)
      make.leading.equalToSuperview()
      make.top.bottom.equalToSuperview()
    }
    
    let label = UILabel()
    label.font = UIConstants.font
    label.textColor = UIConstants.textColor
    label.text = title
    
    view.addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.equalTo(imageView.snp.trailing).offset(UIConstants.stackViewInnerSpacing)
      make.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    return view
  }
  
  @objc private func onArrangedSubviewTap(_ sender: UITapGestureRecognizer) {
    
    let gender = genderFor(index: sender.view!.tag)
    setGenderSelected(gender: gender)
    
    delegate?.genderPickerChangeSelection(to: gender)
  }
  
  private func genderFor(index: Int) -> Gender {
    return Gender.allCases[index]
  }
  
  private func indexFor(gender: Gender) -> Int {
    
    var counter = 0
    var index = 0
    
    Gender.allCases.forEach { g in
      
      if g == gender {
        index = counter
        return
      }
      
      counter += 1
    }
    
    return index
  }
  
}

fileprivate enum UIConstants {
  
  static let backgroundColor = UIColor.clear
  static let stackViewSpacing: CGFloat = 5.0
  static let stackViewInnerSpacing: CGFloat = 10.0
  static let textColor = UIColor(named: "textDarkGreen")!
  static let offset: CGFloat = 24.0
  static let height: CGFloat = 24.0
  static let font = UIFont.semiBoldAppFont(of: 13)
  static let indicatorEmptyBackgroundColor = UIColor(hex: "#E7E7E7")
  static let selectedIcon = UIImage(named: "radio_icon")
  static let titleColor = UIColor.black
  static let titleFont = UIFont.semiBoldAppFont(of: 13)
  static let topOffset: CGFloat = 16.0
  
  enum Error {
    static let color = UIColor.color(r: 255, g: 95, b: 95)
  }
}

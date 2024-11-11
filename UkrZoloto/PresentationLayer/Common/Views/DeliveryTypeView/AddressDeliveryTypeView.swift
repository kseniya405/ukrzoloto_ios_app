//
//  AddressDeliveryTypeView.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class AddressDeliveryTypeView: DeliveryTypeView {
  
  // MARK: - Private variables
  private let containerView = UIView()
  private let cityView = SelectionView(withoutLeftSpace: true)
  private let streetView = SelectionView(withoutLeftSpace: true)
  private let houseTextField = UnderlinedTextField()
  private let apartmentTextField = UnderlinedTextField()
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    configureContainerView()
    configureCityView()
    configureStreetView()
    configureHouseTextField()
    configureApartmentTextField()
  }
  
  private func configureContainerView() {
    containerView.backgroundColor = UIConstants.containerViewColor
    addBottomView(containerView)
  }

  private func configureCityView() {
    cityView.setFont(UIConstants.CityView.font)
    cityView.setNumberOfLines(UIConstants.CityView.numberOfLines)
    containerView.addSubview(cityView)
    cityView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
  }
  
  private func configureStreetView() {
    streetView.setFont(UIConstants.StreetView.font)
    streetView.setNumberOfLines(UIConstants.StreetView.numberOfLines)
    containerView.addSubview(streetView)
    streetView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalTo(cityView.snp.bottom).offset(UIConstants.StreetView.top)
    }
  }
  
  private func configureHouseTextField() {
    houseTextField.font = UIConstants.TextField.font
    containerView.addSubview(houseTextField)
    houseTextField.snp.makeConstraints { make in
      make.top.equalTo(streetView.snp.bottom).offset(UIConstants.TextField.top)
      make.leading.equalToSuperview()
      make.height.equalTo(UIConstants.TextField.height)
    }
    houseTextField.returnKeyType = .next
  }
  
  private func configureApartmentTextField() {
    apartmentTextField.font = UIConstants.TextField.font
    containerView.addSubview(apartmentTextField)
    apartmentTextField.snp.makeConstraints { make in
      make.top.equalTo(streetView.snp.bottom).offset(UIConstants.TextField.top)
      make.leading.equalTo(houseTextField.snp.trailing).offset(UIConstants.TextField.spacing)
      make.trailing.equalToSuperview()
      make.height.equalTo(UIConstants.TextField.height)
      make.width.equalTo(houseTextField)
      make.bottom.equalToSuperview()
    }
    apartmentTextField.returnKeyType = .done
  }
  
  // MARK: - Interface
  func setCityTitle(_ title: String) {
    cityView.setTitle(title)
  }

  func setStreetTitle(_ title: String?) {
    streetView.setTitle(title)
  }

  func setCityTextColor(_ color: UIColor) {
    cityView.setTextColor(color)
  }

  func setStreetTextColor(_ color: UIColor) {
    streetView.setTextColor(color)
  }

  func addCityTarget(_ target: Any, action: Selector) {
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(target, action: action)
    cityView.addGestureRecognizer(gesture)
  }

  func addStreetTarget(_ target: Any, action: Selector) {
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(target, action: action)
    streetView.addGestureRecognizer(gesture)
  }
  
  func setHouse(_ title: String?) {
    houseTextField.text = title
  }
  
  func setApartment(_ title: String?) {
    apartmentTextField.text = title
  }
  
  func setHousePlaceholder(_ placeholder: String?) {
    houseTextField.placeholder = placeholder
  }
  
  func setApartmentPlaceholder(_ placeholder: String?) {
    apartmentTextField.placeholder = placeholder
  }
  
  func getHouse() -> String? {
    return houseTextField.text
  }
  
  func getApartment() -> String? {
    return apartmentTextField.text
  }
  
  func getHouseTextField() -> UITextField {
    return houseTextField
  }
  
  func getApartmentTextField() -> UITextField {
    return apartmentTextField
  }

  func removeCityTarget() {
    cityView.gestureRecognizers?.forEach { cityView.removeGestureRecognizer($0) }
  }

  func removeStreetTarget() {
    streetView.gestureRecognizers?.forEach { streetView.removeGestureRecognizer($0) }
  }
}


// MARK: - UIConstants
private enum UIConstants {
  static let containerViewColor = UIColor.clear
  
  enum TextField {
    static let top: CGFloat = 20
    static let height: CGFloat = 53
    static let spacing: CGFloat = 9
    static let font = UIFont.semiBoldAppFont(of: 16)
  }

  enum CityView {
    static let font = UIFont.semiBoldAppFont(of: 16)
    static let numberOfLines = 0
  }

  enum StreetView {
    static let font = UIFont.semiBoldAppFont(of: 16)
    static let numberOfLines = 0

    static let top: CGFloat = 10
    static let bottom: CGFloat = 8
  }
}

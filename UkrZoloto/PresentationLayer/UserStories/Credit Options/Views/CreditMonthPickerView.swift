//
//  CreditMonthPickerView.swift
//  UkrZoloto
//
//  Created by Mykola on 30.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class CreditMonthPickerView: InitView {
  
  var onDoneTap: ((Int) -> Void)?
  
  private var months: [Int]!
  private var selectedMonth: Int!
  
  private var pickerView: UIPickerView!
  
  convenience init(months: [Int], selectedMonth: Int) {
    
    self.init()
    self.months = months
    self.selectedMonth = selectedMonth
    setup()
  }
  
  func setup() {
    
    let border = UIView()
    border.backgroundColor = UIConstants.borderColor
    addSubview(border)
    border.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalTo(1.0)
    }
  
    let headerView = UIView()
    headerView.backgroundColor = .white
    addSubview(headerView)
    headerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(border.snp.bottom)
      make.height.equalTo(UIConstants.headerHeight)
    }
    
    let button = UIButton()
    button.setTitle(Localizator.standard.localizedString("Готово"), for: .normal)
    button.setTitleColor(UIConstants.doneButtonColor, for: .normal)
    button.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
    headerView.addSubview(button)
    button.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(UIConstants.rightpadding)
      make.top.bottom.equalToSuperview()
      make.width.equalTo(UIConstants.buttonWidth)
    }
    
    pickerView = UIPickerView()
    pickerView.dataSource = self
    pickerView.delegate = self
    
    addSubview(pickerView)
    pickerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(button.snp.bottom)
      make.bottom.equalToSuperview()
    }
  }
  
  func displayIn(container: UIView) {
    
    container.addSubview(self)
    snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(UIConstants.height)
    }
  }
  
  @objc private func doneButtonTapped(_ sendere: UIButton) {
    let index = pickerView.selectedRow(inComponent: 0)
    let value = months[index]
    
    onDoneTap?(value)
    self.removeFromSuperview()
  }
}

extension CreditMonthPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return months.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(months[row])"
  }
}

private enum UIConstants {
  static let height: CGFloat = 180.0
  static let borderColor = UIColor(named: "card")!
  static let headerHeight: CGFloat = 30.0
  static let doneButtonColor = UIColor(named: "textDarkGreen")!.withAlphaComponent(0.8)
  static let rightpadding: CGFloat = -20.0
  static let buttonWidth: CGFloat = 60.0
}

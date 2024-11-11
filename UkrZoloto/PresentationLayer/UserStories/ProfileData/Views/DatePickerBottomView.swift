//
//  DatePickerBottomView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/11/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol DatePickerBottomViewDelegate: AnyObject {
  func didDateWasChanged(to date: Date)
}

class DatePickerBottomView: InitView {
  
  // MARK: - Public variables
  weak var delegate: DatePickerBottomViewDelegate?
  
  // MARK: - Private varialbes
  private let bottomView = UIView()
  private let gestureView = UIView()
  private let datePicker = DatePickerFactory.birthdayDatePicker
  private let lineView = UIView()
  
  // MARK: - Configuration
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureDatePicker()
    configureLine()
    configureBottomView()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  
  private func configureDatePicker() {
    addSubview(datePicker)
    datePicker.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.height.equalTo(UIConstants.DatePicker.height)
      make.leading.trailing.equalToSuperview()
    }
    datePicker.backgroundColor = UIConstants.DatePicker.backgroundColor
    datePicker.setValue(UIConstants.DatePicker.textColor,
                        forKey: "textColor")
    datePicker.addTarget(self,
                         action: #selector(didDateChanged),
                         for: .valueChanged)
  }
  
  private func configureLine() {
    addSubview(lineView)
    lineView.snp.makeConstraints { make in
      make.top.equalTo(datePicker.snp.bottom)
      make.height.equalTo(UIConstants.Line.height)
      make.leading.trailing.equalToSuperview()
    }
    lineView.backgroundColor = UIConstants.Line.backgroundColor
  }
  
  private func configureBottomView() {
    addSubview(bottomView)
    bottomView.snp.makeConstraints { make in
      make.top.equalTo(lineView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(UIConstants.BottomView.height)
      make.bottom.equalToSuperview()
    }
    bottomView.backgroundColor = UIConstants.BottomView.backgroundColor
  }
  
  // MARK: - Actions
  @objc
  private func didDateChanged() {
    delegate?.didDateWasChanged(to: datePicker.date)
  }
  
  // MARK: - Interface
  func setDate(_ date: Date) {
    datePicker.setDate(date, animated: false)
  }
  
}

// MARK: - UIConstants
private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  enum Line {
    static let height: CGFloat = 1
    static let backgroundColor = UIColor.black.withAlphaComponent(0.2)
  }
  enum DatePicker {
    static let height: CGFloat = 216
    static let backgroundColor = UIColor.color(r: 239, g: 239, b: 244)
    static let textColor = UIColor.color(r: 51, g: 51, b: 51)
    static let font = UIFont.regularAppFont(of: 23)
  }
  enum BottomView {
    static let backgroundColor = UIColor.color(r: 240, g: 240, b: 245)
    static let height: CGFloat = 60
  }
}

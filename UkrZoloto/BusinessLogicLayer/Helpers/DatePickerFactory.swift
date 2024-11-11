//
//  DatePickerFactory.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 1/3/20.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation

class DatePickerFactory {
  
  static var birthdayDatePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.sizeToFit()
    datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
    datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
    return datePicker
  }()
  
}

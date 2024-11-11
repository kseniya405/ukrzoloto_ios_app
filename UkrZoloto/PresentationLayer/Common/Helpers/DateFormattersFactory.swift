//
//  DateFormattersFactory.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/13/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class DateFormattersFactory {
  class func dateOnlyFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
    return formatter
  }
  
  class func eventDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM"
    return formatter
  }
  
  class func serverDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    return formatter
  }
}

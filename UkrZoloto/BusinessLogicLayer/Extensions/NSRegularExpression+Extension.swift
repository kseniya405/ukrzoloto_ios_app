//
//  NSRegularExpression+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 8/9/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

extension NSRegularExpression {
  convenience init(_ pattern: String) {
    do {
      try self.init(pattern: pattern)
    } catch {
      preconditionFailure("Illegal regular expression: \(pattern).")
    }
  }
  
  func matches(_ string: String) -> Bool {
    let range = NSRange(location: 0, length: string.utf16.count)
    return firstMatch(in: string, options: [], range: range) != nil
  }
}

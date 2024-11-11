//
//  Event.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/13/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UkrZolotoInternalEvent: Equatable {

  let title: String
  let date: Date

  init(title: String, date: Date) {
    self.title = title
    self.date = date
  }

  static func == (lhs: UkrZolotoInternalEvent, rhs: UkrZolotoInternalEvent) -> Bool {
    return lhs.title == rhs.title && lhs.date == rhs.date
  }

}

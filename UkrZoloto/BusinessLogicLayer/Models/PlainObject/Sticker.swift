//
//  Sticker.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 27.06.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON

struct Sticker: Hashable {
  let colorCode: String
  let title: String

  init(colorCode: String,
       title: String) {
    self.colorCode = colorCode
    self.title = title
  }

  init?(json: JSON) {
    guard let title = json[NetworkResponseKey.Sticker.title].string,
      let colorCode = json[NetworkResponseKey.Sticker.colorCode].string else {
        return nil
    }
    self.title = title
    self.colorCode = colorCode
  }
}

// MARK: - Equatable
extension Sticker: Equatable {
  static func == (lhs: Sticker, rhs: Sticker) -> Bool {
    return lhs.colorCode == rhs.colorCode && lhs.title == rhs.title
  }
}

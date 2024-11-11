//
//  Reusable.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol Reusable: AnyObject {
  static var defaultReuseIdentifier: String { get }
}

extension Reusable where Self: UIView {
  static var defaultReuseIdentifier: String {
    return String(describing: Self.self)
  }
}

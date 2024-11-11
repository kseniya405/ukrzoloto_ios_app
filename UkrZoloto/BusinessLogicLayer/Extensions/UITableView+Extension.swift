//
//  UITableView+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension UITableView {
  
  func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
    register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
    guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
    }
    return cell
  }
  
  func dequeueReusableCell<T: UITableViewCell>(withReuseIdentifier reuseIdentifier: String,
                                               for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
    }
    return cell
  }
}

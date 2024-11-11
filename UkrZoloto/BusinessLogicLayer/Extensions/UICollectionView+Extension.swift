//
//  UICollectionView+Extension.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  func register<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String) {
    register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(
    withReuseIdentifier reuseIdentifier: String,
    for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
    }
    return cell
  }
}

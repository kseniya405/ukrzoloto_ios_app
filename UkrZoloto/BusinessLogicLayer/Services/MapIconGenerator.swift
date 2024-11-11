//
//  MapIconGenerator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import GoogleMaps

class MapIconGenerator: NSObject, GMUClusterIconGenerator {
  func icon(forSize size: UInt) -> UIImage! {
    let view = ShopClusterView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: UIConstants.width,
                                             height: UIConstants.height))
    view.layoutIfNeeded()
    view.setTitle("\(size)")
    return view.image()
  }
}

private enum UIConstants {
  static let width: CGFloat = 34
  static let height: CGFloat = 44
}

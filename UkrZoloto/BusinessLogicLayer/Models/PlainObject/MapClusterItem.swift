//
//  MapClusterItem.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/22/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Foundation

class MapClusterItem: NSObject, GMUClusterItem {
  var position: CLLocationCoordinate2D
  var icon: UIImage?
  
  init(position: CLLocationCoordinate2D, icon: UIImage? = nil) {
    self.position = position
    self.icon = icon
  }
}

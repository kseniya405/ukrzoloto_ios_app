//
//  OSVersion.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 08.04.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

struct OSVersion {
    
  let major: Int
  let minor: Int?
  let patch: Int?
  
  init?(_ string: String) {
    let paths = string.components(separatedBy: ".").compactMap { Int($0) }
    guard let major = paths.first else {
      return nil
    }
    
    self.major = major
    minor = paths.indices.contains(1) ? paths[1] : nil
    patch = paths.indices.contains(2) ? paths[2] : nil
  }
}

extension OSVersion: Comparable {
  static func < (lhs: OSVersion, rhs: OSVersion) -> Bool {
    if lhs.major != rhs.major {
      return lhs.major < rhs.major
    } else if lhs.minor != rhs.minor {
      return lhs.minor < rhs.minor
    } else if lhs.patch != rhs.patch {
      return lhs.patch < rhs.patch
    }
    return false
  }
}

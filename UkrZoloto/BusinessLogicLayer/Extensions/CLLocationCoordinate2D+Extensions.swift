//
//  CLLocationCoordinate2D+Extensions.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 07.06.2022.
//  Copyright © 2022 Brander. All rights reserved.
//

import Foundation
import CoreLocation

public extension Array where Element == CLLocationCoordinate2D {
  func center() -> CLLocationCoordinate2D {
    var maxLatitude: Double = -200
    var maxLongitude: Double = -200
    var minLatitude: Double = Double(MAXFLOAT)
    var minLongitude: Double = Double(MAXFLOAT)

    for location in self {
        if location.latitude < minLatitude {
            minLatitude = location.latitude
        }

        if location.longitude < minLongitude {
            minLongitude = location.longitude
        }

        if location.latitude > maxLatitude {
            maxLatitude = location.latitude
        }

        if location.longitude > maxLongitude {
            maxLongitude = location.longitude
        }
    }

    return CLLocationCoordinate2DMake(
      CLLocationDegrees((maxLatitude + minLatitude) * 0.5),
      CLLocationDegrees((maxLongitude + minLongitude) * 0.5))
  }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
  static public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
      return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}

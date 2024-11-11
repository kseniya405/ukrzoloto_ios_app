//
//  Constants.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import CoreLocation

enum Constants {
  
  enum Screen {
    static let iPhone6Height: CGFloat = 667.0
    static let iPhone6Width: CGFloat = 375.0
    static let heightCoefficient = UIScreen.main.bounds.height / Screen.iPhone6Height
    static let widthCoefficient = UIScreen.main.bounds.width / Screen.iPhone6Width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenWidth = UIScreen.main.bounds.size.width
    static var bottomSafeAreaInset: CGFloat {
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    return window?.safeAreaInsets.bottom ?? 0

    }
    static var topSafeAreaInset: CGFloat {
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    return window?.safeAreaInsets.top ?? 0
    }
  }
  
  static var baseURL: String {
    return baseURLWithoutAPI + "/" + currentVersion
  }

  enum AppColors {
    static let mainGreenColor = UIColor.color(r: 0, g: 80, b: 47)
  }
  
  static var baseURLWithoutAPI: String {
    #if DEBUG
    return "https://staging.ukrzoloto.ua/mobile"
    #else
    return "https://ukrzoloto.ua/mobile"
    #endif
  }
  
  static var currentVersion: String {
    return "v1"
  }
  
  enum Keychain {
    static let name = "UkrZoloto"
    static let token = "Token"
    static let pushTokenKey = "PushToken"
    static let userId = "UserId"
    static let guid = "GUID"
  }
  
  enum RemoteConfig {
    static let minOSVersion = "min_version_of_app_iOS"
    static var minimumFetchInterval: TimeInterval {
      #if DEBUG
      return 0
      #else
      return 6 * 60 * 60
      #endif
    }
  }
  
  static let formattedSupportPhone = "0 800 75 92 29"
  
  static let googleApiKey = "AIzaSyCjcTilhpq-T1KMic2H4iP_x_AqSav4mRs"
  
  static let appStoreURL = "itms-apps://itunes.apple.com/ru/app/ukrzoloto/id1487945870"
  
  enum Location {
    static let kievLatitude = 50.450001
    static let kievLongitude = 30.523333
    static let kievCenter = CLLocationCoordinate2D(latitude: kievLatitude, longitude: kievLongitude)
    static let defaultZoom: Float = 10
    static let zoomStep: Float = 1
    static let currentLocationThresholdZoom: Float = 10
    static let currentLocationDefaultZoom: Float = 15
    static let shopZoom: Float = 13
  }
  
  enum Filter {
    static let itemsForManyOptions = 6
  }
  
  static let rangeTimeInterval = 3
  static let searchTimeInterval = 1.4
  
  enum Regex {
    static let email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    static let numbersOnly = "[0-9]"
  }
  
  enum Info {
    static let phone = "0800759229"
    static let formattedPhone = "0 800 75 92 29"
  }
  
  enum Timer {
    static let defaultTime = 60
    static let otpCodeLength = 6
  }
  
  enum Map {
    static let mapStyle = """
        [
          {
            "elementType": "geometry",
            "stylers": [
              {
                "color": "#f5f5f5"
              }
            ]
          },
          {
            "elementType": "labels.icon",
            "stylers": [
              {
                "visibility": "off"
              }
            ]
          },
          {
            "elementType": "labels.text.fill",
            "stylers": [
              {
                "color": "#616161"
              }
            ]
          },
          {
            "elementType": "labels.text.stroke",
            "stylers": [
              {
                "color": "#f5f5f5"
              }
            ]
          },
          {
            "featureType": "administrative.land_parcel",
            "elementType": "labels.text.fill",
            "stylers": [
              {
                "color": "#bdbdbd"
              }
            ]
          },
          {
            "featureType": "poi",
            "elementType": "geometry",
            "stylers": [
              {
                "color": "#eeeeee"
              }
            ]
          },
          {
            "featureType": "poi",
            "elementType": "labels.text.fill",
            "stylers": [
              {
                "color": "#757575"
              }
            ]
          },
          {
            "featureType": "poi.park",
            "elementType": "geometry",
            "stylers": [
              {
                "color": "#e5e5e5"
              }
            ]
          },
          {
            "featureType": "poi.park",
            "elementType": "labels.text.fill",
            "stylers": [
              {
                "color": "#9e9e9e"
              }
            ]
          },
          {
            "featureType": "road",
            "elementType": "geometry",
            "stylers": [
              {
                "color": "#ffffff"
              }
            ]
          },
          {
            "featureType": "road.arterial",
            "elementType": "labels.text.fill",
            "stylers": [
              {
                "color": "#757575"
              }
            ]
          },
          {
            "featureType": "road.highway",
            "elementType": "geometry",
            "stylers": [
              {
                "color": "#dadada"
              }
            ]
          },
          {
            "featureType": "road.highway",
            "elementType": "labels.text.fill",
            "stylers": [
              {
                "color": "#616161"
              }
            ]
          },
          {
            "featureType": "road.local",
            "elementType": "labels.text.fill",
            "stylers": [
              {
                "color": "#9e9e9e"
              }
            ]
          },
          {
            "featureType": "transit.line",
            "elementType": "geometry",
            "stylers": [
              {
                "color": "#e5e5e5"
              }
            ]
          },
          {
            "featureType": "transit.station",
            "elementType": "geometry",
            "stylers": [
              {
                "color": "#eeeeee"
              }
            ]
          },
          {
            "featureType": "water",
            "elementType": "geometry",
            "stylers": [
              {
                "color": "#c9c9c9"
              }
            ]
          },
          {
            "featureType": "water",
            "elementType": "labels.text.fill",
            "stylers": [
              {
                "color": "#9e9e9e"
              }
            ]
          }
        ]
    """
  }
}

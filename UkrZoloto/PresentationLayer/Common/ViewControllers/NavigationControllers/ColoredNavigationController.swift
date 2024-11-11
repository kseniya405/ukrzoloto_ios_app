//
//  ColoredNavigationController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 11.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum ColorStyle {
  case green
  case clear
  case transparent
  case goldText
  case white
}

class ColoredNavigationController: SwipableNavigationController {
  
  // MARK: - Life cycle
  init(rootViewController: UIViewController, style: ColorStyle = .green) {
    super.init(rootViewController: rootViewController)
    configure(with: style)
    modalPresentationStyle = .fullScreen
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
    modalPresentationStyle = .fullScreen
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    configure()
    modalPresentationStyle = .fullScreen
  }
  
  convenience init(style: ColorStyle = .green) {
    self.init(nibName: nil, bundle: nil)
    configure()
    modalPresentationStyle = .fullScreen
  }
  
  // MARK: - Configure
  func configure(with style: ColorStyle = .green, preventChangingOpacity: Bool = false) {
    var barColor = UIColor.color(r: 0, g: 80, b: 47)
    var barStyle = UIBarStyle.default
    var textColor: UIColor
    var opacity: Float
    var isTranslucent: Bool = false
    switch style {
    case .green:
      textColor = .white
      opacity = 1
      barStyle = .black
//      if #available(iOS 13.0, *) {
//        let appear = UINavigationBarAppearance()
//
//        appear.backgroundColor = barColor
//
//        navigationBar.isTranslucent = false
//        navigationBar.standardAppearance = appear
//        navigationBar.scrollEdgeAppearance = appear
//      }
    case .clear:
      textColor = .clear
      barColor = .clear
      opacity = 1
      isTranslucent = true
    case .transparent:
      textColor = .clear
      barColor = .clear
      opacity = 1
      isTranslucent = true
      barStyle = .black
    case .goldText:
      textColor = UIColor.color(r: 255, g: 220, b: 136)
      opacity = 1
      barStyle = .black
    case .white:
      textColor = UIColor.color(r: 62, g: 76, b: 75)
      barColor = .white
      opacity = 1
      barStyle = .default
    }
    navigationBar.isTranslucent = isTranslucent
    navigationBar.backgroundColor = barColor
    navigationBar.barTintColor = barColor
    navigationBar.barStyle = barStyle
    navigationBar.tintColor = textColor
    if !preventChangingOpacity {
      navigationBar.layer.opacity = opacity
    }
    if navigationBar.titleTextAttributes == nil {
      navigationBar.titleTextAttributes = [:]
    }
    navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] = textColor
    navigationBar.titleTextAttributes?[NSAttributedString.Key.font] = UIFont.semiBoldAppFont(of: 16)
    edgesForExtendedLayout = []
    navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationBar.shadowImage = UIImage()
  }
  
}

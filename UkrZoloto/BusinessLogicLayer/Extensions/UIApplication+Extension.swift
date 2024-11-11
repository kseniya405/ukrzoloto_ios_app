//
//  UIApplication+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 2/28/20.
//  Copyright © 2020 Brander. All rights reserved.
//

import UIKit

extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
  
  class func getLastNavigationController() -> UINavigationController? {
    guard let topVC = topViewController() else { return nil }
    if let navigationController = topVC as? UINavigationController {
      return navigationController
    } else {
      return topVC.navigationController
    }
    
  }
}

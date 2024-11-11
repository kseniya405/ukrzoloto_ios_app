//
//  UIViewController+Extension.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 10/4/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

extension UIViewController {
  
  var isModal: Bool {
    let presentingIsModal = presentingViewController != nil
    let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
    let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
    
    return presentingIsModal || presentingIsNavigation || presentingIsTabBar
  }
  
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  func disableSwipeToBack() {
      navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
  
  func enableSwipeToBack() {
      navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }

}

//
//  AlertDisplayable.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol AlertDisplayable: AnyObject {
  func showAlert(title: String?, subtitle: String?)
  func showAlert(title: String?, subtitle: String?, cancelAction: (() -> Void)?)
  func showAlert(title: String?, subtitle: String?, actions: [AlertAction])
  func showAlert(title: String?, subtitle: String?, actions: [AlertAction], cancelAction: (() -> Void)?)
}

extension AlertDisplayable where Self: UIViewController {
  
  func showAlert(title: String?, subtitle: String?) {
    showAlert(title: title, subtitle: subtitle, actions: [])
  }
  
  func showAlert(title: String?, subtitle: String?, cancelAction: (() -> Void)?) {
    showAlert(title: title, subtitle: subtitle, actions: [], cancelAction: cancelAction)
  }
  
  func showAlert(title: String?, subtitle: String? = nil, actions: [AlertAction] = []) {
    showAlert(title: title, subtitle: subtitle, actions: actions, cancelAction: nil)
  }
  
  func showAlert(title: String?, subtitle: String? = nil, actions: [AlertAction] = [], cancelAction: (() -> Void)?) {
    let contentView = ActionContentView(isSubtitleAvailable: subtitle != nil)
    contentView.title = title
    contentView.subtitle = subtitle
    for action in actions {
      contentView.addAction(action)
    }
    
    let blurAlertController = createAlertViewController(contentView: contentView)
    blurAlertController.cancelAction = cancelAction
    contentView.delegate = blurAlertController
    if let tabBarController = tabBarController {
      tabBarController.present(blurAlertController,
                               animated: true,
                               completion: nil)
    } else {
      present(blurAlertController, animated: true, completion: nil)
    }
  }
  
  private func createAlertViewController(contentView: BaseContentView) -> BlurAlertController {
    let blurAlertView = BlurAlertView(contentView: contentView)
    let blurAlertController = BlurAlertController(blurAlertView: blurAlertView)
    return blurAlertController
  }
  
}

enum ActionStyle {
  case filled
  case unfilled
  case unfilledGreen
}

struct AlertAction {
  let style: ActionStyle
  let title: String
  let isEmphasized: Bool
  let completion: () -> Void
}

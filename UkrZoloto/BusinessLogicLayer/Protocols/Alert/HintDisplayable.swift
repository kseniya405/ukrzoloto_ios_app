//
//  HintDisplayable.swift
//  UkrZoloto
//
//  Created by V.Fesenko on 28.07.2023.
//  Copyright © 2023 Dita-Group. All rights reserved.
//

import UIKit

protocol HintDisplayable: AnyObject {
  func showDiscountHintAlert(
    title: String?,
    subtitle: String?,
    bottomTitle: String?,
    price: Price,
    actions: [AlertAction],
    cancelAction: (() -> Void)?)
}

extension HintDisplayable where Self: UIViewController {
  func showDiscountHintAlert(
    title: String?,
    subtitle: String? = nil,
    bottomTitle: String? = nil,
    price: Price,
    actions: [AlertAction] = [],
    cancelAction: (() -> Void)? = nil) {
      let contentView = ActionDiscountContentView(
        isSubtitleAvailable: subtitle != nil,
        isBottomTitleAvailable: bottomTitle != nil)

      contentView.title = title
      contentView.subtitle = subtitle
      contentView.bottomTitle = bottomTitle
      contentView.update(price)

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

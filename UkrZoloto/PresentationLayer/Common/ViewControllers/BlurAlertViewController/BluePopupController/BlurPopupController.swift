//
//  BlurPopupController.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 08.04.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

class BlurPopupController: BlurTransitionController {
  // MARK: - Fields
  var blurPopupView: BlurPopupView? {
      return self.view as? BlurPopupView
  }
  
  // MARK: - Life Cycle
  
  init(blurPopupView: BlurPopupView) {
      super.init(blurTransitionView: blurPopupView)
      initConfigure()
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    blurPopupView?.hideContentView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      self.blurPopupView?.showContentView()
      UIView.animate(withDuration: AnimationConstants.duration) { [weak self] in
          guard let weakSelf = self else { return }
          weakSelf.blurPopupView?.layoutIfNeeded()
      }
  }
  
  // MARK: - Private
  private func initConfigure() {
      modalPresentationStyle = .overCurrentContext
  }
  
  private func animateHiding(completion: BlurAlertCompletionFunction?) {
      blurPopupView?.hideContentView()
      UIView.animate(withDuration: AnimationConstants.duration, animations: { [weak self] in
          guard let self = self else { return }
          self.blurPopupView?.layoutIfNeeded()
          }, completion: { _ in
              super.dismiss(animated: true, completion: completion)
      })
  }
  
  // MARK: - BlurTransitionViewDelegate
  override func didTapOnBlurView(_ view: BlurTransitionView) { }
}

// MARK: - Constants
private enum AnimationConstants {
    static let duration = 0.65
}

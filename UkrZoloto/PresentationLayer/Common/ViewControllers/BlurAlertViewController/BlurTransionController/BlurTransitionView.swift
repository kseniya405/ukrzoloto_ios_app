//
//  BlurTransitionView.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol BlurTransitionViewDelegate: AnyObject {
  func didTapOnBlurView(_ view: BlurTransitionView)
}

protocol BlurTransition: AnimationTransitionView {
  var blurDelegate: BlurTransitionViewDelegate? { get set }
}

class BlurTransitionView: InitView, AnimationTransitionView, BlurTransition {
  
  // MARK: - Public variables
  
  weak var blurDelegate: BlurTransitionViewDelegate?
  
  // MARK: - UI elements
  
  let blurView = UIView()
  
  private let backgroundTapRecognizer = UITapGestureRecognizer()
  
  // MARK: - Init configure
  
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
    configureBlurView()
    configureTapRecognizer()
  }
  
  private func configureSelf() {
    backgroundColor = .clear
  }
  
  private func configureBlurView() {
    addSubview(blurView)
    blurView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func configureTapRecognizer() {
    backgroundTapRecognizer.addTarget(self, action: #selector(didTapOnBlurView))
    blurView.addGestureRecognizer(backgroundTapRecognizer)
  }
  
  // MARK: - Actions
  
  @objc private func didTapOnBlurView() {
    blurDelegate?.didTapOnBlurView(self)
  }
  
  // MARK: - AnimationTransitionView
  
  func applyPresentAnimationChanges() {
    // blurView.blurRadius = 3
    blurView.backgroundColor = UIColor.color(r: 4, g: 35, b: 32, a: 0.15)
  }
  
  func applyDismissAnimationChanges() {
    // blurView.blurRadius = 0
    blurView.backgroundColor = UIColor.clear
  }

}

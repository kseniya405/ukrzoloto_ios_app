//
//  BlurAlertController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

typealias BlurAlertCompletionFunction = () -> Void

class BlurAlertController: BlurTransitionController {
    // MARK: - Fields
    var blurAlertView: BlurAlertView? {
        return self.view as? BlurAlertView
    }
    var cancelAction: BlurAlertCompletionFunction?
    var closeCompletionBlock: BlurAlertCompletionFunction?
    
    // MARK: - Life Cycle
    
    init(blurAlertView: BlurAlertView) {
        super.init(blurTransitionView: blurAlertView)
        initConfigure(view: view)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        blurAlertView?.hideContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.blurAlertView?.showContentView()
        UIView.animate(withDuration: AnimationConstants.duration) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.blurAlertView?.layoutIfNeeded()
        }
    }
    
    // MARK: - Private
    private func initConfigure(view: UIView) {
        guard let blurView = view as? BlurAlertView else {
            return
        }
        modalPresentationStyle = .overCurrentContext
        let contentViewPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognize(with:)))
        blurView.contentView?.addGestureRecognizer(contentViewPanRecognizer)
    }
    
    func animateHiding(completion: BlurAlertCompletionFunction?) {
        blurAlertView?.hideContentView()
        UIView.animate(withDuration: AnimationConstants.duration, animations: { [weak self] in
            guard let weakSelf = self
                else { return }
            weakSelf.blurAlertView?.layoutIfNeeded()
            }, completion: { (_) in
                super.dismiss(animated: true, completion: completion)
        })
    }
    
    // MARK: - BlurTransitionViewDelegate
    
    override func didTapOnBlurView(_ view: BlurTransitionView) {
        closeAction()
    }
    
    // MARK: - Actions
    @objc func closeAction() {
        animateHiding { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.cancelAction?()
            weakSelf.closeCompletionBlock?()
        }
    }
    
    @objc func panRecognize(
        with recognizer: UIPanGestureRecognizer) {
        guard
            let selfView = blurAlertView else {
                return
        }
        let translation = recognizer.translation(in: selfView)
        switch recognizer.state {
        case .began, .changed:
            panContentView(to: translation)
        case .cancelled, .ended:
            closeContentViewIfNeeded(translation: translation)
        default:
            break
        }
    }
    
    private func panContentView(to point: CGPoint) {
        let offset = point.y > 0 ?
            point.y :
            -sqrt(abs(point.y * AnimationConstants.speedScrollCoefficient))
        blurAlertView?.updateContentViewFrame(offset: offset)
    }
    
    private func closeContentViewIfNeeded(translation: CGPoint) {
        guard let contentView = blurAlertView?.contentView
            else { return }
        if translation.y > contentView.frame.size.height / AnimationConstants.backHeightCoefficient {
            closeAction()
        } else {
            blurAlertView?.finishContentViewMove()
        }
    }
    
    // MARK: - Public
    override func dismiss(
        animated: Bool, completion: BlurAlertCompletionFunction? = nil) {
        if animated {
            closeCompletionBlock = completion
            closeAction()
        }
    }
    
    // MARK: - Constants
    private enum AnimationConstants {
        static let duration = 0.15
        static let backHeightCoefficient: CGFloat = 5
        static let speedScrollCoefficient: CGFloat = 30
    }
}

// MARK: - ActionContentViewDelegate
extension BlurAlertController: ActionContentViewDelegate {
  func hideView() {
     closeAction()
  }
}

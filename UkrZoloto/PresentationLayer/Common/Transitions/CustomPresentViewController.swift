//
//  CustomPresentViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 09.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class CustomPresentViewController: UIViewController {

    private let transitionController = AnimationTransitionController()
    
    // MARK: - Life Cycle
    init(view: (UIView & AnimationTransitionView)) {
        super.init(nibName: nil, bundle: nil)
        initConfigure(with: view)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension CustomPresentViewController {
    func initConfigure(with newView: UIView) {
        newView.frame = view.frame
        view = newView
        transitioningDelegate = transitionController
        modalPresentationStyle = .overCurrentContext
    }
}

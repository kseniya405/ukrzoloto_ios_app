//
//  SwipableNavigationController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 11.07.2019.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class SwipableNavigationController: UINavigationController {
    
    // MARK: - Public variables
    
    // MARK: - Private variables
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MAKR: - Setup
    
    private func configure() {
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension SwipableNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

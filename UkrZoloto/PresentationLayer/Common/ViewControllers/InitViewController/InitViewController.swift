//
//  InitViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {

  // MARK: - Private constants
  private let shouldDisplayOnFullScreen: Bool
  
  // MARK: - Life cycle
  init(shouldDisplayOnFullScreen: Bool) {
    self.shouldDisplayOnFullScreen = shouldDisplayOnFullScreen
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initConfigure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = shouldDisplayOnFullScreen
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tabBarController?.tabBar.isHidden = shouldDisplayOnFullScreen
  }
  
  // MARK: - Init configure
  func initConfigure() {
    
  }
  
}

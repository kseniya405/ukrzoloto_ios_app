//
//  LocalizableViewController.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import Localize_Swift

class LocalizableViewController: InitViewController {
  
  private var wasAppeared = false
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLocalization()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !wasAppeared {
      wasAppeared = true
      viewFirstAppear(animated)
    }
  }

  func viewFirstAppear(_ animated: Bool) { }
  
  // MARK: - Private
  private func setupLocalization() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(localize),
                                           name: Notification.Name(LCLLanguageChangeNotification),
                                           object: nil)
  }
  
  // MARK: - Localization
  @objc
  func localize() { }
}

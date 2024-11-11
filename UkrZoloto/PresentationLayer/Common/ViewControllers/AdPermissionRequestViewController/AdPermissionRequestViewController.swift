//
//  AdPermissionRequestViewController.swift
//  UkrZoloto
//
//  Created by Mykola on 24.07.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit

protocol AdPermissionRequestViewControllerOutput: AnyObject {
  
  func onProceedButtonTapped(viewController: AdPermissionRequestViewController)
}

class AdPermissionRequestViewController: LocalizableViewController {
  
  private var statusBarStyle: UIStatusBarStyle = .darkContent {
      didSet {
          setNeedsStatusBarAppearanceUpdate()
      }
  }
  
  // MARK: - Public variables
  var output: AdPermissionRequestViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = AdPermissionView()
  
  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    statusBarStyle = .darkContent
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
      return statusBarStyle
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    statusBarStyle = .lightContent
  }

  override func initConfigure() {
    setupView()
    localizeContent()
  }
  
  override func localize() {
    localizeContent()
  }
}

// MARK: - UI Routine
private extension AdPermissionRequestViewController {

  func setupView() {
    selfView.addTargetOnProceedButton(self, action: #selector(onProceedButtonTapped(_:)), for: .touchUpInside)
  }
  
  func localizeContent() {
    
    let title = Localizator.standard.localizedString("Обновление\nдля iOS 14.5")
    let subtitle = Localizator.standard.localizedString("Разрешив собирать данные на следующем  экране, вы получите: ")
    
    let text1 = Localizator.standard.localizedString("Рекомендации товаров по вашим интересам")
    let text2 = Localizator.standard.localizedString("Уведомление про бонусы и персональные скидки")
    let text3 = Localizator.standard.localizedString("Релевантная реклама на сторонних ресурсах")
    
    let buttonTitle = Localizator.standard.localizedString("Продолжить").uppercased()
    
    selfView.setTitle(title)
    selfView.setSubtitle(subtitle)
    selfView.setButtonTitle(buttonTitle)
    selfView.setTopLabelText(text1)
    selfView.setMiddleLabelText(text2)
    selfView.setBottomLabelText(text3)
  }
  
  @objc func onProceedButtonTapped(_ sender: UIButton) {
    output?.onProceedButtonTapped(viewController: self)
  }
}

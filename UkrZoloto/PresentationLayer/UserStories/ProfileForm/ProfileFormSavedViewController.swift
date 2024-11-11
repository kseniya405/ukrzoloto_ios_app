//
//  ProfileFormSavedViewController.swift
//  UkrZoloto
//
//  Created by Mykola on 07.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

extension ProfileFormSavedViewController {
  
  class func createInstance() -> ProfileFormSavedViewController {
    
    let viewController = ProfileFormSavedViewController(shouldDisplayOnFullScreen: true)
    viewController.modalPresentationStyle = .overFullScreen
    
    return viewController
  }
}

protocol ProfileFormSavedViewControllerDelegate: AnyObject {
  
  func profileFormSavedViewControllerTappedClose()
  func profileFormSavedViewControllerTappedProceed()
}

class ProfileFormSavedViewController: LocalizableViewController {
  
  weak var output: ProfileFormSavedViewControllerDelegate?
  
  private let selfView = ProfileFormSaveView()
  
  private var statusBarStyle: UIStatusBarStyle = .darkContent {
      didSet {
          setNeedsStatusBarAppearanceUpdate()
      }
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    statusBarStyle = .darkContent
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    statusBarStyle = .lightContent
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
      return statusBarStyle
  }
  
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  override func localize() {
    selfView.localize()
  }
  
  func configureSelf() {
    
    selfView.onOkTap = { [weak self] in
      self?.output?.profileFormSavedViewControllerTappedProceed()
    }
    
    selfView.onCloseTap = { [weak self] in
      self?.output?.profileFormSavedViewControllerTappedClose()
    }
  }
}

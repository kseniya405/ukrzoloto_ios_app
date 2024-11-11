//
//  AuthCoordinator.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/16/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

protocol AuthCoordinatorOutput: AnyObject {
  func didAuthorize()
}

class AuthCoordinator: Coordinator {
  
  // MARK: - Public variables
  weak var output: AuthCoordinatorOutput?
  
  // MARK: - Private variables
  private weak var phoneViewController: PhoneViewController?
  
  // MARK: - Life cycle
  override func start(completion: (() -> Void)? = nil) {
    start(animated: false, completion: nil)
  }
  
  func start(animated: Bool, completion: (() -> Void)?) {
    showPhoneVC(animated: animated, completion: completion)
  }
  
  private func showPhoneVC(animated: Bool, completion: (() -> Void)?) {
    let phoneVC = PhoneViewController(shouldDisplayOnFullScreen: true)
    phoneVC.hidesBottomBarWhenPushed = true
    phoneVC.output = self
    
    navigationController.pushViewController(phoneVC, animated: animated) {
      completion?()
    }
    self.phoneViewController = phoneVC
  }
  
}

// MARK: - PhoneViewControllerOutput
extension AuthCoordinator: PhoneViewControllerOutput {
  func didTapOnClose(from vc: PhoneViewController) {
    if vc.isModal {
      navigationController.dismiss(animated: true)
    } else {
      navigationController.popViewController(animated: true)
    }
  }
  
  func didSMSWasSent(phoneNumber: String, from vc: PhoneViewController) {
    let smsVC = SMSViewController(phoneNumber: phoneNumber, shouldDisplayOnFullScreen: true)
    smsVC.output = self
    phoneViewController?.navigationController?.pushViewController(smsVC, animated: true)
  }
  
  func didTapOnPrivacyLink(from vc: PhoneViewController) {
    guard let webVC = ViewControllersFactory.webViewVC(
            ofType: .agreement,
            keyLocalizator: KeyLocalizator(key: "Пользовательское соглашение")) else { return }
    webVC.output = self
    navigationController.pushViewController(webVC, animated: true)
  }
  
}

// MARK: - SMSViewControllerOutput
extension AuthCoordinator: SMSViewControllerOutput {
  func smsWasConfirmed(from vc: SMSViewController) {
    navigationController.dismiss(animated: true) {
      self.output?.didAuthorize()
    }
  }
  
  func didTapOnBack(from vc: SMSViewController) {
    phoneViewController?.navigationController?.popViewController(animated: true)
  }
  
}

// MARK: - WebViewControllerOutput
extension AuthCoordinator: WebViewControllerOutput {
  func back(from: WebViewController) {
    navigationController.popViewController(animated: true)
  }
  
  func successRedirect(from: WebViewController) { }
}

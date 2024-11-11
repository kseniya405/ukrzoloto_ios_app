//
//  AdvertisingService.swift
//  UkrZoloto
//
//  Created by Mykola on 24.07.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation
import AppTrackingTransparency
import FBSDKCoreKit

class AdvertisingService {
  
  static let shared = AdvertisingService()
  
  func willDisplayIdfaDialog() -> Bool {
    return idfaFeatureAvailable()
  }
    
  func displayAdRequestDialogue(viewContext: UIViewController) {
    guard idfaFeatureAvailable() else {
      return
    }
    
    let dialog = AdPermissionRequestViewController(shouldDisplayOnFullScreen: false)

    dialog.modalPresentationCapturesStatusBarAppearance = true
    dialog.output = self
    dialog.modalPresentationStyle = .overFullScreen

    viewContext.present(dialog, animated: true, completion: nil)
  }
  
  func getTrackingPermissionState() -> Bool {
    return ATTrackingManager.trackingAuthorizationStatus == .authorized
  }
}

// MARK: - Internal logic
private extension AdvertisingService {
  func idfaFeatureAvailable() -> Bool {
      let actualStatus = ATTrackingManager.trackingAuthorizationStatus
      
      switch actualStatus {
      case .notDetermined: return true
      default: break
      }
    return false
  }
    
  func requestSystemDialog() {
    ATTrackingManager.requestTrackingAuthorization { [weak self] status in
      self?.handleSystemDialogResult(success: status == .authorized)
    }
  }
  
  func handleSystemDialogResult(success: Bool) {
    Settings.shared.isAdvertiserTrackingEnabled = success
  }
}

extension AdvertisingService: AdPermissionRequestViewControllerOutput {
  func onProceedButtonTapped(viewController: AdPermissionRequestViewController) {
    
    viewController.dismiss(animated: true, completion: nil)
    requestSystemDialog()
  }
}

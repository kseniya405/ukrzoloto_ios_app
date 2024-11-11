//
//  AppStoreReviewService.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 16.01.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import UIKit
import StoreKit

class AppStoreReviewService {

  // Public variables
  static let shared = AppStoreReviewService()
  
  // MARK: - Life cycle
  private init() { }
  
  func requestReviewIfNeeded() {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        DispatchQueue.main.async {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
  }
}

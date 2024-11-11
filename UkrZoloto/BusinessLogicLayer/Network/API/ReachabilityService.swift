//
//  ReachabilityService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import Reachability

class ReachabilityService {
  
  // MARK: - Public variables
  static let shared = ReachabilityService()
  
  var isInternetAvailable: Bool {
    guard let reachability = reachability else {
      return false
    }
    return reachability.connection != .unavailable
  }
  
  // MARK: - Private variables
  private let reachability: Reachability? = try? Reachability()
  
  // MARK: - Life cycle
  init() {
    setup()
    startListenReachabilityStatus()
    setupAppStateListeners()
  }
  
  // MARK: - Init configure
  
  private func setup() {
    reachability?.allowsCellularConnection = true
    do {
      try reachability?.startNotifier()
    } catch {
			debugPrint("Unable to start notifier")
    }
  }
  
  // MARK: - Private
  private func startListenReachabilityStatus() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(reachabilityChanged),
                                           name: Notification.Name.reachabilityChanged,
                                           object: nil)
  }
  
  private func setupAppStateListeners() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(appDidBecomeActive),
                                           name: UIApplication.didBecomeActiveNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(appDidEnterBackground),
                                           name: UIApplication.didEnterBackgroundNotification,
                                           object: nil)
  }
  
  @objc
  private func reachabilityChanged(note: Notification) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if self.isInternetAvailable {
        self.postNetworkBecomeAvaliable()
      } else {
        self.postNetworkBecomeNotAvailable()
      }
    }
  }
  
  @objc
  private func appDidBecomeActive() {
    try? reachability?.startNotifier()
  }
  
  @objc
  private func appDidEnterBackground() {
    reachability?.stopNotifier()
  }
  
  private func postNetworkBecomeAvaliable() {
    NotificationCenter.default.post(name: Notification.Name.networkBecomeAvailable,
                                    object: nil)
  }
  
  private func postNetworkBecomeNotAvailable() {
    NotificationCenter.default.post(name: Notification.Name.networkBecomeNotAvailable,
                                    object: nil)
  }
}

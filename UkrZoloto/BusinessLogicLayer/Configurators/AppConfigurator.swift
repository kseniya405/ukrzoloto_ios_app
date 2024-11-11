//
//  AppConfigurator.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/10/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleMaps
import FirebaseRemoteConfig
import Reteno
import Adjust
import AdServices
import FirebaseSessions

class AppConfigurator {
  
  // MARK: - Singleton
  static let shared = AppConfigurator()
  
  // MARK: - Public variables
  
  // MARK: - Private variables
  private weak var appCoordinator: AppCoordinator?

  // MARK: - Life cycle
  
  private init() {
    DeeplinkService.shared.output = self
  }

  // MARK: - Actions
  func configure(appDelegate: AppDelegate,
                 application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//    ApplicationDelegate.shared.initializeSDK()
    configureGoogleMaps()
    configureFirebase()
//    configureAdjust()
    configureReteno(application: application)
    configureGoogleAnalytics()
//    UserNotificationService.shared.registerForRemoteNotifications(application: application)

    configureAppCoordinator(appDelegate: appDelegate, launchOptions: launchOptions)
    configureAppWindow(appDelegate: appDelegate)
    configureRemoteConfig()

    updateCart()
    updateProfile()
    updateContacts()
    
    FirstLaunchHelper().trackFirstLaunchIfNeeded()
  }

  private func configureAdjust() {
    AdjustAnalyticsService.configureApp()
  }

  private func configureReteno(application: UIApplication) {
    // Reteno initialization
    Reteno.start(
      apiKey: "265a3b78-eb0f-4dd3-b83c-f70c52335936",
      isAutomaticScreenReportingEnabled: false,
      isDebugMode: false)

    // Register for receiving push notifications
    // registerForRemoteNotifications will show the native iOS notification permission prompt
    // Provide UNAuthorizationOptions or use default
    Reteno.userNotificationService.registerForRemoteNotifications(
      with: [.sound, .alert, .badge],
      application: application)
  }
  
  private func configureGoogleMaps() {
    GMSServices.provideAPIKey(Constants.googleApiKey)
  }
  
	private func configureFirebase() {
#if DEBUG
		let factory = AppCheckDebugProviderFactory()
		AppCheck.setAppCheckProviderFactory(factory)
#endif
		FirebaseApp.configure()
		if let userId = ProfileService.shared.userId {
			Analytics.setDefaultEventParameters(["user_id": "\(userId)"])
			Analytics.setUserID("\(userId)")
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
			Analytics.sessionID { sessionId, error in
				EventService.shared.sessionId = sessionId
        debugPrint(error ?? "error")
			}
		})
	}
  
  private func configureFacebook(application: UIApplication,
                                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//    ApplicationDelegate.shared.application(application,
//                                           didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func configureGoogleAnalytics() {
		GoogleAnalyticsService.configure()
  }
  
  private func configureAppCoordinator(appDelegate: AppDelegate,
                                       launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    let navigationController = ColoredNavigationController()
    navigationController.isNavigationBarHidden = true

    let appCoordinator = AppCoordinator(
      navigationController: navigationController,
      options: launchOptions?[.remoteNotification] as? [AnyHashable: Any])

    self.appCoordinator = appCoordinator
    appDelegate.appCoordinator = appCoordinator
  }
  
  private func configureAppWindow(appDelegate: AppDelegate) {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = UIColor.color(r: 0, g: 80, b: 47)
    appDelegate.window = window
    window.rootViewController = appDelegate.appCoordinator?.navigationController
    window.makeKeyAndVisible()

    appDelegate.appCoordinator?.start()
  }
  
  private func configureRemoteConfig() {
    let settings = RemoteConfigSettings()

    settings.minimumFetchInterval = Constants.RemoteConfig.minimumFetchInterval
    RemoteConfig.remoteConfig().configSettings = settings
    
    RemoteConfig.remoteConfig().fetchAndActivate { [weak self] (status, error) in
      let remoteConfig = RemoteConfig.remoteConfig()
      let minVersionString = remoteConfig.configValue(forKey: Constants.RemoteConfig.minOSVersion).stringValue
      let minVersion = OSVersion(minVersionString ?? "")
      let currentVersion = OSVersion(Bundle.main.releaseVersionNumber)
      if let minVersion = minVersion,
         let currentVersion = currentVersion,
         currentVersion < minVersion {
        self?.appCoordinator?.showUpdatePopup()
      }
    }
  }
  
  private func updateCart() {
    CartService.shared.getCart { _ in }
  }
  
  private func updateProfile() {
    ProfileService.shared.getProfile { _ in }
  }
  
  private func updateContacts() {
    ProfileService.shared.updateContacts()
  }

}

// MARK: - DeeplinkServiceOutput

extension AppConfigurator: DeeplinkServiceOutput {
  func showMainController() {
    appCoordinator?.showMainController()
  }
  
  func showCatalogController() {
    appCoordinator?.showCatalogController()
  }

  func showAuthorizationController() {
    appCoordinator?.showAuthorizationController()
  }

  func showCartController() {
    appCoordinator?.showCartController()
  }

  func showCategoryController(with identifier: Int) {
    appCoordinator?.showCategoryController(with: identifier)
  }

  func showProductController(with identifier: String) {
    appCoordinator?.showProductController(with: identifier)
  }

  func showProfileController() {
    appCoordinator?.showProfileController()
  }

  func showProfileDataController() {
    appCoordinator?.showProfileDataController()
  }

  func showFavoritesProductsController() {
    appCoordinator?.showFavoritesProductsController()
  }

  func showShopsController() {
    appCoordinator?.showShopsController()
  }

  func showSearchController(text: String) {
    appCoordinator?.showSearchController(text: text)
  }
}

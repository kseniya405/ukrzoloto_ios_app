//
//  AppDelegate.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/5/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Reteno
import FirebaseMessaging
import Adjust
import UserNotifications
import SDWebImageSVGKitPlugin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  var appCoordinator: Coordinator?
	var contentHandler: ((UNNotificationContent) -> Void)?
	var bestAttemptContent: UNMutableNotificationContent?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		configureApp()
    AppConfigurator.shared.configure(appDelegate: self,
                                     application: application,
                                     didFinishLaunchingWithOptions: launchOptions)
    
    // Set the delegate for UNUserNotificationCenter
    UNUserNotificationCenter.current().delegate = self
		UserNotificationService.shared.setMessagingDelegate()
    // Register for remote notifications to receive device token
    application.registerForRemoteNotifications()
		let svgCoder = SDImageSVGKCoder.shared
		SDImageCodersManager.shared.addCoder(svgCoder)
    return true
  }
  
  func configureApp() {
    let environment = ADJEnvironmentProduction // ADJEnvironmentSandbox
    
    let adjustConfig = ADJConfig(
      appToken: "jmw24vpe8lc0",
      environment: environment)
    
    adjustConfig?.logLevel = ADJLogLevelDebug
		adjustConfig?.delayStart = 20
    adjustConfig?.delegate = self
    adjustConfig?.setAppSecret(1, info1: 1350891894, info2: 1896188742, info3: 664235182, info4: 1465358503)
    Adjust.appDidLaunch(adjustConfig)
  }
  
  // MARK: - Notifications
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    UserNotificationService.shared.resetNotificationsCounter(of: application)
		Adjust.requestTrackingAuthorization()
    AppEvents.shared.activateApp()
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    UserNotificationService.shared.updateDeviceToken(deviceToken)
		Adjust.setDeviceToken(deviceToken)
		let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
		debugPrint("devicetoken \(deviceTokenString)")
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

		if url.absoluteString.contains("adj_") {
      DeeplinkService.shared.handleScreen(with: url)
      return true
    }
    return false
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

		if let incomingURL = userActivity.webpageURL {
      DeeplinkService.shared.handleScreen(with: incomingURL)
      
      // call the below method to resolve deep link
      ADJLinkResolution.resolveLink(
        with: incomingURL,
        resolveUrlSuffixArray: ["ukrzoloto.go.link", "ukrzoloto", "ukrzoloto.ua"],
        callback: { resolvedURL in
          if let resolvedURL = resolvedURL {
            Adjust.appWillOpen(resolvedURL)
          }
        })
      return true
    }
    return false
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if let adjustPurpose = userInfo["adjust_purpose"] as? String,
       adjustPurpose == "uninstall detection" {
      // No handling required for Adjust data payload
      
      completionHandler(.noData)
    } else {
      // Handle other types of push messages here
      
      // Pass the appropriate value to the completionHandler:
      // .newData, .noData, or .failed.
      completionHandler(.newData)
    }
  }
}

extension AppDelegate: AdjustDelegate {
  
  func adjustDeeplinkResponse(_ deeplink: URL?) -> Bool {
    if let deeplink = deeplink {
      DeeplinkService.shared.handleScreen(with: deeplink)
    }
    return true
  }
}

extension AppDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter,
															willPresent notification: UNNotification,
															withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
		completionHandler([.sound, .banner])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
															didReceive response: UNNotificationResponse,
															withCompletionHandler completionHandler: @escaping () -> Void) {
		Reteno.userNotificationService.processRemoteNotificationResponse(response)
		
		let userInfo = response.notification.request.content.userInfo
		
		if let categoryPush = CategoryPush(userInfo) {
			NotificationCenter.default.post(
				name: .showCategory, object: nil, userInfo: [Notification.Key.categoryPush: categoryPush])
		} else if let productPush = ProductPush(userInfo) {
			NotificationCenter.default.post(
				name: .showProduct, object: nil, userInfo: [Notification.Key.productPush: productPush])
		} else {
			let actionIdentifier = response.actionIdentifier
						
			if actionIdentifier == "com.apple.UNNotificationDefaultActionIdentifier",
				 let clickUrl = userInfo["clickUrl"] as? String,
				 let url = URL(string: clickUrl) {
				
				DeeplinkService.shared.handleScreen(with: url)
				DeeplinkService.shared.openHandledScreenIfNeeded()
								
				completionHandler()
				return
			}
			
			if let buttons = userInfo["buttons"] as? [[String: Any]] {
				
				buttons.forEach { dict in
					
					if let text = dict["text"] as? String,
						 text == actionIdentifier,
						 let urlString = dict["url"] as? String,
						 let url = URL(string: urlString),
						 let buttonUniqueId = dict["uniqueKey"] as? String {
						
						DeeplinkService.shared.handleScreen(with: url)
						DeeplinkService.shared.openHandledScreenIfNeeded()
						
						let _ = buttonUniqueId
						
						//TODO: - Replace MindBoxService with new service integration
						//MindBoxService.shared.didOpenPush(uniqueId: uniqueId, buttonUniqueId: buttonUniqueId)
					}
				}
				completionHandler()
				return
			}
		}
		completionHandler()
	}
}


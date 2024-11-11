//
//  UserNotificationService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 11/15/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import Reteno

class UserNotificationService: RetenoNotificationServiceExtension {
	
	static let shared = UserNotificationService()
	
	private override init() {
		super.init()
	}
	
	var isRegisteredForRemoteNotifications: Bool {
		return UIApplication.shared.isRegisteredForRemoteNotifications
	}
	
	func registerForRemoteNotifications(application: UIApplication) {
		UNUserNotificationCenter.current().delegate = self
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: authOptions,
																														completionHandler: {_, _ in
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				Adjust.requestTrackingAuthorization()
			}
		})
		
		configureUserNotificationCategories()
		application.registerForRemoteNotifications()
	}
	
	func setMessagingDelegate() {
		Messaging.messaging().delegate = self
	}
	
	func configureUserNotificationCategories() {
		
		let productAction = UNNotificationAction(identifier: "Product", title: "Product", options: [.foreground])
		
		let productCategory = UNNotificationCategory(identifier: "Product",
																								 actions: [productAction],
																								 intentIdentifiers: [],
																								 hiddenPreviewsBodyPlaceholder: nil,
																								 categorySummaryFormat: nil,
																								 options: [])
		
		UNUserNotificationCenter.current().setNotificationCategories([productCategory])
	}
	
	func updateDeviceToken(_ token: Data) {
		Messaging.messaging().apnsToken = token
		if let fcmToken = Messaging.messaging().fcmToken, fcmToken != ProfileService.shared.pushToken {
			ProfileService.shared.pushToken = fcmToken
			Reteno.userNotificationService.processRemoteNotificationsToken(fcmToken)
		}
	}
	
	func resetNotificationsCounter(of application: UIApplication = UIApplication.shared) {
		application.applicationIconBadgeNumber = .zero
	}
}

extension UserNotificationService: MessagingDelegate {
	  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
	    ProfileService.shared.pushToken = fcmToken
	    if let fcmToken = fcmToken {
	      Reteno.userNotificationService.processRemoteNotificationsToken(fcmToken)
	    }
	  }
}

extension UserNotificationService: UNUserNotificationCenterDelegate {
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
			
      _ = userInfo["uniqueKey"] as? String
			
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
					}
				}
				completionHandler()
				return
			}
		}
		completionHandler()
	}
}

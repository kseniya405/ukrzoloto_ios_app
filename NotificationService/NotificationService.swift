//
//  NotificationService.swift
//  NotificationService
//
//  Created by Kseniia Shkurenko on 25.07.2024.
//  Copyright © 2024 Dita-Group. All rights reserved.
//

import UserNotifications
import Reteno

class NotificationService: RetenoNotificationServiceExtension {
		override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
				Reteno.logEvent(eventTypeKey: "push_delivered", parameters: [Event.Parameter(name: "isPushDelivered", value: "true")])
				
				super.didReceive(request, withContentHandler: contentHandler)
		}
}

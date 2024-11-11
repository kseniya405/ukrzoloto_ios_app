//
//  GoogleAnalyticsService.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 15.07.2020.
//  Copyright © 2020 Brander. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class GoogleAnalyticsService {
  
  // MARK: - Private variables
  
  private static let tracker = GAI.sharedInstance()?.tracker(withName: "tracker", trackingId: "UA-26080367-1")
  
  static let date = Date()
  
  // MARK: - Life cycle
  
  private init() { }
  
  // MARK: - Static methods
  
  static func configure() { }
  
  static func track(url: URL) {
    tracker?.allowIDFACollection = true
    let builder = GAIDictionaryBuilder()
    
    builder.setCampaignParametersFromUrl(url.absoluteString)
    if let source = builder.get(kGAICampaignSource),
      let medium = builder.get(kGAICampaignMedium),
      let host = url.host,
       !host.isEmpty {
      builder.set("refferer", forKey: medium)
      builder.set(host, forKey: source)
    }
    
    tracker?.set(kGAIScreenName, value: "screen name")
    if let hitParams = builder.build() as? [AnyHashable: Any],
      let sendParams = GAIDictionaryBuilder.createScreenView()?.setAll(hitParams)?.build() as? [AnyHashable: Any] {
      tracker?.send(sendParams)
    }
  }
  
  static func getAppInstanceId() -> String? {
    return Analytics.appInstanceID()
  }
}

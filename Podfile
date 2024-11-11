source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '14.0'
use_frameworks!

def shared_pods
  pod 'Adjust'
  pod 'ActiveLabel', '1.1.0'
  pod 'Alamofire', '5.9.0'
  pod 'AUIKit', :git => 'https://github.com/uzmobteam/AUIKit.git', :branch => 'feature/ScrollViewDelegate'
  pod 'BetterSegmentedControl', '2.0.1'
  pod 'ClusterKit', '0.5.0'
  pod 'ESTabBarController-swift', '2.8.0'
  pod 'FBSDKCoreKit', '17.0.1'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/InAppMessaging'
  pod 'Firebase/Messaging'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/AppCheck'
  pod 'GoogleAnalytics', '3.23.0'
  pod 'GoogleMaps', '8.4.0'
  pod 'KeychainAccess', '4.2.2'
	pod 'libPhoneNumber-iOS', '0.9.15'
  pod 'Lightbox', '2.5.0'
  pod 'Localize-Swift', '3.2.0'
  pod 'PKHUD', '5.3.0'
	pod 'ReachabilitySwift', '5.2.2'
	pod 'Reteno', '2.0.12'
  pod 'SDWebImage'
	pod 'SDWebImageSVGKitPlugin'
  pod 'SnapKit', '5.7.1'
  pod 'SwiftyJSON', '5.0.2'
  pod 'WARangeSlider', :git => 'https://github.com/uzmobteam/RangeSlider.git', :branch => 'develop'
  pod 'SwiftLint'
end

target 'UkrZoloto' do
  shared_pods
end

target 'UkrZoloto Dev' do
  shared_pods
end

target 'NotificationService' do
	pod 'Reteno', '2.0.12'
end

target 'NotificationContentExtension' do
		pod 'Reteno', '2.0.12'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      
      if target.name == 'Cache'
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      end
    end
  end
end

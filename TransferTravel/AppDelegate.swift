//
//  AppDelegate.swift
//  TransferTravel
//
//  Created by Feng on 2023/7/29.
//

import UIKit
import IQKeyboardManagerSwift
import KRProgressHUD

var masterKey: String {
	var result = "GHI"
	result += "$%"
	result += String(3 * 8 - 1)
	result += String(2 * 2)
	result += "dba".reversed()
	var total = 0
	for _ in 0..<63 {
		total += 1
	}
	result += String(total)
	result += "#@ed".reversed()
	result = result.replacingOccurrences(of: "GHI", with: "")
	return result
}

var clientId: String {
	return try! "AwFomHXTo4Kf7ARiGgl+6I2UTFlta0IhSeO6boaRZcZKoZhhCwRhaqjR/wUlmUxeeM+c6rdAUJ+9q+mFba4YzL8c/k4BqSN3PW2asQrWwvvv/ojFqqsqZLBpENs7NSi2Caw=".decryprBase64(key: masterKey)!
}
var clientSecret: String {
	return try! "AwFQNZupbbRgwDKr6ro9W85K6Ix+xx/CX6VQvJVec9rT2D8qOJjLzIEEnl3HMQTuF+A+U6UWf+EW0oXIwDPUsMaJXB4ciUHMBtjO/uvOZuqb5pcNUU1AOS3xzPDtt7AGDTevR/lje1ZK68qs1FX4XMZ8".decryprBase64(key: masterKey)!
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//		print("home = \(NSHomeDirectory())")
		BusCommunicator.shared.getToken(id: clientId, key: clientSecret)
		KRProgressHUD.set(style: .custom(background: .clear, text: .darkGray, icon: .darkGray))
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
}


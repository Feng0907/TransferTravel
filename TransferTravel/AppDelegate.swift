//
//  AppDelegate.swift
//  TransferTravel
//
//  Created by Feng on 2023/7/29.
//

import UIKit
import IQKeyboardManagerSwift

let clientId = "workfeng0907-e1410d16-7f2b-4ac3"
let clientSecret = "d5ea944c-3075-44dd-bc08-4e55d17ded3b"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.shouldResignOnTouchOutside = true
		print("home = \(NSHomeDirectory())")
		BusCommunicator.shared.getToken(id: clientId, key: clientSecret)
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


//
//  AppDelegate.swift
//  BroadcastOnline
//
//  Created by Artyom on 08.09.2022.
//

import UIKit
import InAppStorySDK
import IQKeyboardManagerSwift
import StorifyMe
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        InAppStory.shared.initWith(serviceKey: "Bb8CAAAAAAAAAAAAABEaIThgEhYUJk9CMBlDT0RBDslI4x3FthKC61MMca18BzWlw0Spe5gEeKnsqTDs2FSy")
        setupIQKeyboardManager()
        StorifyMeInstance.shared.initialize(accountId: "hakob-6561994", apiKey: "f498b6bb-3295-41c6-949e-c64f5d4ddd69", env: StorifyMeEnv.EU)
        return true
    }
    
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 145
        
        IQKeyboardManager.shared.toolbarTintColor = Colors.backgroundColor
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
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

extension AppDelegate : UNUserNotificationCenterDelegate {
}

//
//  AppDelegate.swift
//  BroadcastOnline
//
//  Created by Artyom on 08.09.2022.
//

import UIKit
import AppsFlyerLib
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppsFlyer()
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

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
    
    func setupAppsFlyer() {
        AppsFlyerLib.shared().appsFlyerDevKey = "ebEDZ4mtpS7VfmLqQrvXVn"
        AppsFlyerLib.shared().appleAppID = "6443601769"
        
        AppsFlyerLib.shared().isDebug = false
        if #available(iOS 14, *) {
            AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        }
    }
}


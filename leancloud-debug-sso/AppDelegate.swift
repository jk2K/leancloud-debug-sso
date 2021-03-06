//
//  AppDelegate.swift
//  leancloud-debug-sso
//
//  Created by Meng Ye on 2017/4/24.
//  Copyright © 2017年 jk2K. All rights reserved.
//

import UIKit
import AVOSCloud
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initLeanCloud()
        
        let userDefaults = UserDefaults.standard
        
        if let uuid: String = userDefaults.string(forKey: UserDefaultKey.uuid.rawValue), uuid.isEmpty == false {
            LeanCloudManager.shared.setup(with: uuid)
            print("登录成功")
        } else {
            print("未登录")
        }
        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Private Helper Methods
    fileprivate func initLeanCloud() {
        AVOSCloud.setApplicationId(LeanCloudConfig.appId, clientKey: LeanCloudConfig.appKey)
        AVOSCloud.setAllLogsEnabled(false)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK:  Notification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("NotificationCenterDelegate: 获得了权限通知权限")
        AVOSCloud.handleRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
}


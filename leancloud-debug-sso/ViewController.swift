//
//  ViewController.swift
//  leancloud-debug-sso
//
//  Created by Meng Ye on 2017/4/24.
//  Copyright © 2017年 jk2K. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let UUID: String = "test-uuid"
        LeanCloudManager.shared.setup(with: UUID)
        UserDefaults.standard.set(UUID, forKey: UserDefaultKey.uuid.rawValue)
        UserDefaults.standard.synchronize()
        
        checkAppAccess {
            
        }
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        LeanCloudManager.shared.client?.close(callback: { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("退出成功")
            }
        })
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.uuid.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Private Helper Methods
    fileprivate func showGotoAppSettingAlert(with target: UIViewController?, title: String, message: String, completionHandler: ((Void) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            completionHandler?()
        }
        let gotoSettingAction = UIAlertAction(title: "去设置", style: .default) { _ in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: { (success) in
                    if (success) {
                        print("成功打开 App 的权限设置页")
                    }
                })
            } else {
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            completionHandler?()
        }
        alert.addAction(cancelAction)
        alert.addAction(gotoSettingAction)
        target?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func checkAppAccess(_ completionHandler: @escaping (Void) -> Void) {
        self.checkNotification() { status in
            switch status {
            case .authorized, .notDetermined:
                print("已给予通知权限")
            case .denied:
                self.showGotoAppSettingAlert(
                    with: self,
                    title: "需要给推送通知权限",
                    message: "请在应用设置中打开"
                ) {
                    print("没给通知权限")
                }
            }
        }
    }
    
    fileprivate enum NotificationAccessStatus {
        case notDetermined
        case denied
        case authorized
    }
    
    fileprivate func getNotificationAccessStatus(_ completionHandler: @escaping ((_ status: NotificationAccessStatus) -> Void)) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current()
                .getNotificationSettings() { settings in
                    let status: UNAuthorizationStatus = settings.authorizationStatus
                    switch status {
                    case .authorized:
                        completionHandler(.authorized)
                    case .denied:
                        completionHandler(.denied)
                    case .notDetermined:
                        completionHandler(.notDetermined)
                    }
            }
        } else {
            let application = UIApplication.shared
            if let _ = application.currentUserNotificationSettings {
                if application.isRegisteredForRemoteNotifications == true {
                    completionHandler(.authorized)
                } else {
                    completionHandler(.denied)
                }
            } else {
                completionHandler(.notDetermined)
            }
        }
    }
    
    fileprivate func checkNotification(_ completionHandler: @escaping ((_ status: NotificationAccessStatus) -> Void)) {
        let application = UIApplication.shared
        getNotificationAccessStatus() { status in
            if #available(iOS 10.0, *) {
                switch status {
                case .authorized:
                    application.registerForRemoteNotifications()
                    completionHandler(status)
                case .denied:
                    completionHandler(status)
                case .notDetermined:
                    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current()
                        .requestAuthorization(options: options) { granted, error in
                            if granted == true {
                                application.registerForRemoteNotifications()
                                completionHandler(.authorized)
                            } else {
                                completionHandler(.denied)
                            }
                            if let _error: NSError = error as NSError? {
                                print(_error.localizedDescription)
                            }
                    }
                }
            } else {
                switch status {
                case .authorized:
                    application.registerForRemoteNotifications()
                    completionHandler(status)
                case .denied:
                    completionHandler(status)
                case .notDetermined:
                    let types: UIUserNotificationType = [.alert, .badge, .sound]
                    let settings = UIUserNotificationSettings(types: types, categories: nil)
                    application.registerUserNotificationSettings(settings)
                }
            }
        }
    }
}


//
//  AppDelegate.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/12.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let userDefault = UserDefaults.standard.bool(forKey: "firstLaunchDone")
        if userDefault != true{
            showFirstLaunchVC()
        }
        attemptToRegisterForNortifications()
        return true
    }
    
    func attemptToRegisterForNortifications() {
        // set delegate
        Messaging.messaging().delegate = self
        // set delegate
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { authorized, error in
            if authorized {
                print("DEBUG: successfully registered for notification")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEBUG: registered for notifications with device token: ", deviceToken)
    }
    
    func showNavigationStoryboard() {
        let vc = UIStoryboard(name: "Navigation", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    func showOnBoardingStoryboard() {
        let vc = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }

    func showTutorialStoryboard() {
        let vc = UIStoryboard(name: "Tutorial", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    func showSettingsstoryboard() {
        let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    func showFirstLaunchVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "FirstLaunchVC")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        UserDefaults.standard.set(true, forKey: "firstLaunchDone")
    }
}


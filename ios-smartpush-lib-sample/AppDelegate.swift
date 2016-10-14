//
//  AppDelegate.swift
//  ios-smartpush-sample
//
//  Created by Rodrigo Busata on 10/10/16.
//  Copyright © 2016 br.com.smartpush. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SmartpushSDKDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let shared = SmartpushSDK.sharedInstance()
        shared?.delegate = self
        shared?.didFinishLaunching(options: launchOptions)
        shared?.registerForPushNotifications()

        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error:Error){
        SmartpushSDK.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        SmartpushSDK.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]){
        SmartpushSDK.sharedInstance().didReceiveRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings){
        SmartpushSDK.sharedInstance().didRegister(notificationSettings)
    }

    func onPushAccepted(_ push: [AnyHashable: Any]!, andOpenFromPush openFromPush: Bool) {
    
        if let info = push["aps"] as? Dictionary<String, AnyObject>{
            let msg = info["alert"] as! String
            var alert: UIAlertView!
            alert = UIAlertView(title: "Smartpush", message: msg, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else{
            var alert: UIAlertView!
            alert = UIAlertView(title: "Falhou ao pegar a msg \(openFromPush)", message: push.description, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}


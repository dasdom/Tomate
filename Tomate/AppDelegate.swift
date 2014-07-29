//
//  AppDelegate.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var focusViewController: FocusViewController?
    
    let kAlreadyStartedKey = "alreadyStarted"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        if !NSUserDefaults.standardUserDefaults().boolForKey(kAlreadyStartedKey) {
            let restAction = UIMutableUserNotificationAction()
            restAction.identifier = "BREAK_ACTION"
            restAction.title = "Start Break"
            restAction.activationMode = .Background
            
            let workAction = UIMutableUserNotificationAction()
            workAction.identifier = "WORK_ACTION"
            workAction.title = "Start Work"
            workAction.activationMode = .Background
            
            
            let category = UIMutableUserNotificationCategory()
            category.setActions([workAction, restAction], forContext: .Default)
            category.identifier = "START_CATEGORY"
            
            let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: NSSet(object: category))
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: kAlreadyStartedKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        focusViewController = FocusViewController(nibName: nil, bundle: nil)
        self.window!.rootViewController = focusViewController
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func application(application: UIApplication!, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings!) {
        println("\(notificationSettings)")
    }
    
    func application(application: UIApplication!, handleActionWithIdentifier identifier: String!, forLocalNotification notification: UILocalNotification!, completionHandler: (() -> Void)!) {
        println(identifier)
        
        if identifier == "BREAK_ACTION" {
            focusViewController!.startBreak(nil)
        } else if identifier == "WORK_ACTION" {
            focusViewController!.startWork(nil)
        }
        
        completionHandler()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


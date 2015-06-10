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
  let kRegisterNotificationSettings = "kRegisterNotificationSettings"
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    customizeAppearance()
    
    let defaultPreferences = [kRegisterNotificationSettings : true, TimerType.Work.rawValue : 1501, TimerType.Break.rawValue : 301, TimerType.Procrastination.rawValue: 601]
    NSUserDefaults.standardUserDefaults().registerDefaults(defaultPreferences)
    NSUserDefaults.standardUserDefaults().synchronize()
    
    if NSUserDefaults.standardUserDefaults().boolForKey(kRegisterNotificationSettings) {
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
      
      let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: NSSet(object: category) as Set<NSObject>)
      UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
      
      NSUserDefaults.standardUserDefaults().setBool(false, forKey: kRegisterNotificationSettings)
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
    
    if let identifier = identifier {
      if identifier == "BREAK_ACTION" {
        focusViewController!.startBreak(nil)
      } else if identifier == "WORK_ACTION" {
        focusViewController!.startWork(nil)
      }
    }
    
    completionHandler()
  }
  
  func customizeAppearance() {
    UINavigationBar.appearance().tintColor = UIColor.yellowColor()
    UINavigationBar.appearance().barTintColor = TimerStyleKit.backgroundColor
  }
}


//
//  AppDelegate.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)
  var focusViewController: FocusViewController?
  
  let kAlreadyStartedKey = "alreadyStarted"
  let kRegisterNotificationSettings = "kRegisterNotificationSettings"
  
  var session: WCSession?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    customizeAppearance()
    
    registerDefaultUserDefaults()
        
    focusViewController = FocusViewController(nibName: nil, bundle: nil)
    
    if (WCSession.isSupported()) {
      session = WCSession.defaultSession()
      session?.delegate = self
      session?.activateSession()
      focusViewController?.session = session
    }

    window!.rootViewController = focusViewController
    window!.makeKeyAndVisible()
    
    // Override point for customization after application launch.
//    var shouldPerformAdditionalDelegateHandling = true
    
    // If a shortcut was launched, display its information and take the appropriate action
    if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
        
        handleShortcut(shortcutItem.type)
        
        // This will block "performActionForShortcutItem:completionHandler" from being called.
//        shouldPerformAdditionalDelegateHandling = false
    }
    
    return true
  }
  
  func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    print("\(notificationSettings)")
  }
  
  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: (() -> Void)) {
    print(identifier)
    
    if let identifier = identifier {
      if identifier == "BREAK_ACTION" {
        focusViewController!.startBreak(nil)
      } else if identifier == "WORK_ACTION" {
        focusViewController!.startWork(nil)
      }
    }
    
    if (WCSession.isSupported()) {
      session = WCSession.defaultSession()
      session?.delegate = self
      session?.activateSession()
      focusViewController?.session = session
    }
    
    completionHandler()
  }
    
  func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
    
    let handledShortCut = handleShortcut(shortcutItem.type)
    
    completionHandler(handledShortCut)
  }
    
  func handleShortcut(shortCut: String) -> Bool {
    guard let last = shortCut.componentsSeparatedByString(".").last else { return false }

    switch last {
    case "Work":
      self.focusViewController?.startTimerWithType(.Work)
    case "Break":
      self.focusViewController?.startTimerWithType(.Break)
    default:
      return false
    }
    return true
  }
  
  func customizeAppearance() {
    UINavigationBar.appearance().tintColor = UIColor.yellowColor()
    UINavigationBar.appearance().barTintColor = TimerStyleKit.backgroundColor
    
    let titleAttributes = [NSForegroundColorAttributeName: TimerStyleKit.timerColor]
    UINavigationBar.appearance().titleTextAttributes = titleAttributes
  }
}

extension AppDelegate: WCSessionDelegate {
//  func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//    print(applicationContext)
//    guard let actionString = applicationContext["action"] as? String else { return }
//    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//      switch actionString {
//      case "work":
//        self.focusViewController?.startTimerWithType(.Work)
//      case "break":
//        self.focusViewController?.startTimerWithType(.Break)
//      case "stop":
//        self.focusViewController?.startTimerWithType(.Idle)
//      default:
//        break
//      }
//    })
//  }
  
  func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
    print(message)
    guard let actionString = message["action"] as? String else { return }
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
      switch actionString {
      case "work":
        self.focusViewController?.startTimerWithType(.Work)
      case "break":
        self.focusViewController?.startTimerWithType(.Break)
      case "stop":
        self.focusViewController?.startTimerWithType(.Idle)
      default:
        break
      }
    })
  }
}

extension AppDelegate {
  func registerDefaultUserDefaults() {
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
      
      let categories = Set([category])
      //      let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: NSSet(object: category) as Set<NSObject>)
      let notificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound], categories: categories)
      UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
      
      NSUserDefaults.standardUserDefaults().setBool(false, forKey: kRegisterNotificationSettings)
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
}


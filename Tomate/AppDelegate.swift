//
//  AppDelegate.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import WatchConnectivity
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
  var focusViewController: FocusViewController?
  
  let kAlreadyStartedKey = "alreadyStarted"
  let kRegisterNotificationSettings = "kRegisterNotificationSettings_1_6"
    
    fileprivate let breakActionIdentifier = "BREAK_ACTION"
    fileprivate let workActionIdentifier = "WORK_ACTION"
    fileprivate let startCategoryIdentifier = "START_CATEGORY"
  
  var session: WCSession?
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    customizeAppearance()
    
    registerDefaultUserDefaults()
    UNUserNotificationCenter.current().delegate = self
        
    focusViewController = FocusViewController(nibName: nil, bundle: nil)
    
    if (WCSession.isSupported()) {
      session = WCSession.default
      session?.delegate = self
      session?.activate()
      focusViewController?.session = session
    }

    window?.rootViewController = focusViewController
    window?.makeKeyAndVisible()
    
    // Override point for customization after application launch.
//    var shouldPerformAdditionalDelegateHandling = true
    
    // If a shortcut was launched, display its information and take the appropriate action
    if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
        
        _ = handleShortcut(shortcutItem.type)
        
        // This will block "performActionForShortcutItem:completionHandler" from being called.
//        shouldPerformAdditionalDelegateHandling = false
    }
    
    return true
  }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        print(identifier)
        
        if identifier == breakActionIdentifier {
            focusViewController!.startBreak(sender: nil)
        } else if identifier == workActionIdentifier {
            focusViewController!.startWork(sender: nil)
        }
        
        
        if (WCSession.isSupported()) {
          session = WCSession.default
            session?.delegate = self
            session?.activate()
            focusViewController?.session = session
        }
        
        completionHandler()
    }
    
//  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
//    
//    print(identifier ?? "No action identifier")
//    
//    if let identifier = identifier {
//      if identifier == "BREAK_ACTION" {
//        focusViewController!.startBreak(sender: nil)
//      } else if identifier == "WORK_ACTION" {
//        focusViewController!.startWork(sender: nil)
//      }
//    }
//    
//    if (WCSession.isSupported()) {
//      session = WCSession.default()
//      session?.delegate = self
//      session?.activate()
//      focusViewController?.session = session
//    }
//    
//    completionHandler()
//  }
    
  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    
    let handledShortCut = handleShortcut(shortcutItem.type)
    
    completionHandler(handledShortCut)
  }
    
  func handleShortcut(_ shortCut: String) -> Bool {
    guard let last = shortCut.components(separatedBy: ".").last else { return false }

    switch last {
    case "Work":
      self.focusViewController?.startTimer(withType: .work)
    case "Break":
      self.focusViewController?.startTimer(withType: .break)
    default:
      return false
    }
    return true
  }
  
  func customizeAppearance() {
    UINavigationBar.appearance().tintColor = UIColor.yellow
    UINavigationBar.appearance().barTintColor = TimerStyleKit.backgroundColor
    
    let titleAttributes = [NSAttributedString.Key.foregroundColor: TimerStyleKit.timerColor]
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
    
  //TODO: Apps must implement the session(_:activationDidCompleteWith:error:) method, supporting asynchronous activation. On iOS, you must also implement the sessionDidBecomeInactive(_:) and sessionDidDeactivate(_:) methods, supporting multiple Apple Watches.
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
      //TODO
  }
  func sessionDidBecomeInactive(_ session: WCSession) {
      //TODO
  }
  func sessionDidDeactivate(_ session: WCSession) {
      //TODO
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    print(message)
    guard let actionString = message["action"] as? String else { return }
    DispatchQueue.main.async {
      switch actionString {
      case "work":
        self.focusViewController?.startTimer(withType: .work)
      case "break":
        self.focusViewController?.startTimer(withType: .break)
      case "stop":
        self.focusViewController?.startTimer(withType: .idle)
      default:
        break
      }
    }
  }
}

extension AppDelegate {
    func registerDefaultUserDefaults() {
        let defaultPreferences = [kRegisterNotificationSettings : true, TimerType.work.rawValue : 1501, TimerType.break.rawValue : 301, TimerType.procrastination.rawValue: 601] as [String:Any]
        UserDefaults.standard.register(defaults: defaultPreferences)
        UserDefaults.standard.synchronize()
        
        if UserDefaults.standard.bool(forKey: kRegisterNotificationSettings) {
            
            let restAction = UNNotificationAction(identifier: breakActionIdentifier, title: "Start Break", options: [])
            
            let workAction = UNNotificationAction(identifier: workActionIdentifier, title: "Start Work", options: [])
            
            
            let category = UNNotificationCategory(identifier: startCategoryIdentifier, actions: [restAction, workAction], intentIdentifiers: [], options: [])
            
            let categories = Set([category])
            //      let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: NSSet(object: category) as Set<NSObject>)
//            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: categories)
//            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            
            UNUserNotificationCenter.current().setNotificationCategories(categories)
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { auth, error in
                
            })
            
            UserDefaults.standard.set(false, forKey: kRegisterNotificationSettings)
            UserDefaults.standard.synchronize()
        }
    }
}


//
//  FocusViewController.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import AudioToolbox
import WatchConnectivity
import UserNotifications

final class FocusViewController: UIViewController {
  
  fileprivate var focusView: FocusView! { return self.view as! FocusView }
  fileprivate var timer: Timer?
  fileprivate var endDate: Date?
  fileprivate var localNotification: UNNotificationRequest?
  fileprivate var currentType = TimerType.Idle
//  private var workPeriods = [NSDate]()
//  private var numberOfWorkPeriods = 10
  private var totalMinutes = 0
  
  private let kLastDurationKey = "kLastDurationKey"
  private let kLastEndDateKey = "kLastEndDateKey"
  
  var session: WCSession?

    //MARK: - view cycle
  override func loadView() {
    view = FocusView(frame: .zero)
  }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    focusView.workButton.addTarget(self, action: #selector(FocusViewController.startWork(sender:)), for: .touchUpInside)
    focusView.breakButton.addTarget(self, action: #selector(FocusViewController.startBreak(sender:)),
        for: .touchUpInside)
    focusView.procrastinateButton.addTarget(self, action: #selector(FocusViewController.startProcrastination(sender:)), for: .touchUpInside)
    focusView.settingsButton.addTarget(self, action: #selector(FocusViewController.showSettings), for: .touchUpInside)
    focusView.aboutButton.addTarget(self, action: #selector(FocusViewController.showAbout), for: .touchUpInside)
    
//    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "showSettingsFromLongPross:")
//    focusView.addGestureRecognizer(longPressRecognizer)
  }
  
  override func viewDidLayoutSubviews() {
    let minSizeDimension = min(view.frame.size.width, view.frame.size.height)
    focusView.timerView.timeLabel.font = focusView.timerView.timeLabel.font.withSize((minSizeDimension-2*focusView.sidePadding)*0.9/3.0-10.0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if timer == nil {
      focusView.setDuration(0, maxValue: 1)
    }
    
    let duration = UserDefaults.standard.integer(forKey: TimerType.Work.rawValue)
    print("duration: \(duration)")
  }
  
  //MARK: - button actions
  func startWork(sender: UIButton?) {
    print("startWork")
    guard currentType != .Work else { showAlert(); return }
    startTimer(withType: .Work)
  }
  
  func startBreak(sender: UIButton?) {
    guard currentType != .Break else { showAlert(); return }
    startTimer(withType: .Break)
  }
  
  func startProcrastination(sender: UIButton) {
    guard currentType != .Procrastination else { showAlert(); return }
    startTimer(withType: .Procrastination)
  }
  
  func showSettings() {
    present(DHNavigationController(rootViewController: SettingsViewController()), animated: true, completion: nil)
  }
  
  func showSettingsFromLongPross(sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
      showSettings()
    }
  }
  
  func showAbout() {
    present(DHNavigationController(rootViewController: AboutViewController()), animated: true, completion: nil)
  }
  
  func setUIMode(forTimerType timerType: TimerType) {
    UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
      switch timerType {
      case .Work:
        self.set(button: self.focusView.workButton, enabled: true)
        self.set(button: self.focusView.breakButton, enabled: false)
        self.set(button: self.focusView.procrastinateButton, enabled: false)
      case .Break:
        self.set(button: self.focusView.workButton, enabled: false)
        self.set(button: self.focusView.breakButton, enabled: true)
        self.set(button: self.focusView.procrastinateButton, enabled: false)
      case .Procrastination:
        self.set(button: self.focusView.workButton, enabled: false)
        self.set(button: self.focusView.breakButton, enabled: false)
        self.set(button: self.focusView.procrastinateButton, enabled: true)
      default:
        self.set(button: self.focusView.workButton, enabled: true)
        self.set(button: self.focusView.breakButton, enabled: true)
        self.set(button: self.focusView.procrastinateButton, enabled: true)
      }
      
      }, completion: nil)
  }
  
  func set(button: UIButton, enabled: Bool) {
    if enabled {
      button.isEnabled = true
      button.alpha = 1.0
    } else {
      button.isEnabled = false
      button.alpha = 0.3
    }
  }
  
}

//MARK: - timer methods
extension FocusViewController {
  
  func startTimer(withType timerType: TimerType) {
    
    focusView.setDuration(0, maxValue: 1)
    var typeName: String
    switch timerType {
    case .Work:
      typeName = "Work"
      currentType = .Work
//      workPeriods.append(NSDate())
    case .Break:
      typeName = "Break"
      currentType = .Break
    case .Procrastination:
      typeName = "Procrastination"
      currentType = .Procrastination
    default:
      typeName = "None"
      currentType = .Idle
      resetTimer()
//      focusView.numberOfWorkPeriodsLabel.text = "\(workPeriods.count)/\(numberOfWorkPeriods)"
      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
      return
    }
    setUIMode(forTimerType: currentType)
    
//    focusView.numberOfWorkPeriodsLabel.text = "\(workPeriods.count)/\(numberOfWorkPeriods)"
    
    let seconds = UserDefaults.standard.integer(forKey: timerType.rawValue)
    endDate = Date(timeIntervalSinceNow: Double(seconds))
    
    let endTimeStamp = floor(endDate!.timeIntervalSince1970)
    
    if let sharedDefaults = UserDefaults(suiteName: "group.de.dasdom.Tomate") {
      sharedDefaults.set(endTimeStamp, forKey: "date")
      sharedDefaults.set(seconds, forKey: "maxValue")
      sharedDefaults.synchronize()
    }
    
    if let session = session, session.isPaired && session.isWatchAppInstalled {
      do {
        try session.updateApplicationContext(["date": endTimeStamp, "maxValue": seconds])
      } catch {
        print("Error!")
      }
//      if session.complicationEnabled {
        session.transferCurrentComplicationUserInfo(["date": endTimeStamp, "maxValue": seconds])
//      }
    }
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(FocusViewController.updateTimeLabel(sender:)), userInfo: ["timerType" : seconds], repeats: true)
    
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
    let notificationContent = UNMutableNotificationContent()
    notificationContent.body = "Time for \(typeName) is up!"
    notificationContent.sound = UNNotificationSound.default()
    notificationContent.categoryIdentifier = "START_CATEGORY"
    
    localNotification = UNNotificationRequest(identifier: "TimeIsUp", content: notificationContent, trigger: nil)
    
//    localNotification!.fireDate = endDate
//    localNotification!.alertBody = "Time for " + typeName + " is up!";
//    localNotification!.soundName = UILocalNotificationDefaultSoundName
//    localNotification!.category = "START_CATEGORY"
//    UIApplication.shared.scheduleLocalNotification(localNotification!)

    if let notification = localNotification {
        UNUserNotificationCenter.current().add(notification, withCompletionHandler: nil)
    }
    
  }
  
  func updateTimeLabel(sender: Timer) {
    
    var totalNumberOfSeconds: CGFloat
    if let type = (sender.userInfo as! NSDictionary!)["timerType"] as? Int {
      totalNumberOfSeconds = CGFloat(type)
    } else {
      assert(false, "This should not happen")
      totalNumberOfSeconds = -1.0
    }
    
    let timeInterval = CGFloat(endDate!.timeIntervalSinceNow)
    if timeInterval < 0 {
      resetTimer()
      if timeInterval > -1 {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
      }
      focusView.setDuration(0, maxValue: 1)
      return
    }
    
    focusView.setDuration(timeInterval, maxValue: totalNumberOfSeconds)
  }
  
  private func resetTimer() {
    timer?.invalidate()
    timer = nil
    
    currentType = .Idle
    setUIMode(forTimerType: .Idle)
    
    if let session = session, session.isPaired && session.isWatchAppInstalled {
      do {
        try session.updateApplicationContext(["date": -1.0, "maxValue": -1.0])
      } catch {
        print("Error!")
      }
      session.transferCurrentComplicationUserInfo(["date": -1.0, "maxValue": -1.0])
    }
    
    if let sharedDefaults = UserDefaults(suiteName: "group.de.dasdom.Tomate") {
      sharedDefaults.removeObject(forKey: "date")
      sharedDefaults.synchronize()
    }
  }
}

//extension FocusViewController: WCSessionDelegate {
//  func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
//    print(userInfo)
//    guard let actionString = userInfo["action"] as? String else { return }
//    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//      switch actionString {
//      case "work":
//        self.startTimerWithType(.Work)
//      case "break":
//        self.startTimerWithType(.Break)
//      case "stop":
//        self.startTimerWithType(.Idle)
//      default:
//        break
//      }
//    })
//  }
//  func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        print(applicationContext)
//        guard let actionString = applicationContext["action"] as? String else { return }
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//          switch actionString {
//          case "work":
//            self.startTimerWithType(.Work)
//          case "break":
//            self.startTimerWithType(.Break)
//          case "stop":
//            self.startTimerWithType(.Idle)
//          default:
//            break
//          }
//        })
//  }
//}

//MARK: - alert
private extension FocusViewController {
  
  func showAlert() {
    var alertMessage = NSLocalizedString("Do you want to stop this ", comment: "first part of alert message")
    switch currentType {
    case .Work:
      alertMessage += NSLocalizedString("work timer?", comment: "second part of alert message")
    case .Break:
      alertMessage += NSLocalizedString("break timer?", comment: "second part of alert message")
    case .Procrastination:
      alertMessage += NSLocalizedString("procrastination?", comment: "second part of alert message")
    default:
      break
    }
    let alertController = UIAlertController(title: "Stop?", message: alertMessage, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
      print("\(action)")
    })
    alertController.addAction(cancelAction)
    
    let stopAction = UIAlertAction(title: "Stop", style: .default, handler: { action in
      print("\(action)")
//      if self.currentType == .Work || self.workPeriods.count > 0 {
//        self.workPeriods.removeLast()
//      }
      self.startTimer(withType: .Idle)
    })
    alertController.addAction(stopAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
}


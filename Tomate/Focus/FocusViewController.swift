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

class FocusViewController: UIViewController {
  
  private var focusView: FocusView! { return self.view as! FocusView }
  private var timer: NSTimer?
  private var endDate: NSDate?
  private var localNotification: UILocalNotification?
  private var currentType = TimerType.Idle
//  private var workPeriods = [NSDate]()
//  private var numberOfWorkPeriods = 10
  private var totalMinutes = 0
  
  private let kLastDurationKey = "kLastDurationKey"
  private let kLastEndDateKey = "kLastEndDateKey"
  
  //MARK: - view cycle
  override func loadView() {
    view = FocusView(frame: CGRectZero)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    focusView.workButton.addTarget(self, action: "startWork:", forControlEvents: .TouchUpInside)
    focusView.breakButton.addTarget(self, action: "startBreak:", forControlEvents: .TouchUpInside)
    focusView.procrastinateButton.addTarget(self, action: "startProcrastination:", forControlEvents: .TouchUpInside)
    focusView.settingsButton.addTarget(self, action: "showSettings", forControlEvents: .TouchUpInside)
    focusView.aboutButton.addTarget(self, action: "showAbout", forControlEvents: .TouchUpInside)
    
//    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "showSettingsFromLongPross:")
//    focusView.addGestureRecognizer(longPressRecognizer)
  }
  
  override func viewDidLayoutSubviews() {
    let minSizeDimension = min(view.frame.size.width, view.frame.size.height)
    focusView.timerView.timeLabel.font = focusView.timerView.timeLabel.font.fontWithSize((minSizeDimension-2*focusView.sidePadding)*0.9/3.0-10.0)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if timer == nil {
      focusView.setDuration(0, maxValue: 1)
    }
    
    let duration = NSUserDefaults.standardUserDefaults().integerForKey(TimerType.Work.rawValue)
    print("duration: \(duration)")
  }
  
  //MARK: - button actions
  func startWork(sender: UIButton?) {
    print("startWork")
    guard currentType != .Work else { showAlert(); return }
    startTimerWithType(.Work)
  }
  
  func startBreak(sender: UIButton?) {
    guard currentType != .Break else { showAlert(); return }
    startTimerWithType(.Break)
  }
  
  func startProcrastination(sender: UIButton) {
    guard currentType != .Procrastination else { showAlert(); return }
    startTimerWithType(.Procrastination)
  }
  
  func showSettings() {
    presentViewController(UINavigationController(rootViewController: SettingsViewController()), animated: true, completion: nil)
  }
  
  func showSettingsFromLongPross(sender: UILongPressGestureRecognizer) {
    if sender.state == .Began {
      showSettings()
    }
  }
  
  func showAbout() {
    presentViewController(UINavigationController(rootViewController: AboutViewController()), animated: true, completion: nil)
  }
  
  func setUIModeForTimerType(timerType: TimerType) {
    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
      switch timerType {
      case .Work:
        self.set(self.focusView.workButton, enabled: true)
        self.set(self.focusView.breakButton, enabled: false)
        self.set(self.focusView.procrastinateButton, enabled: false)
      case .Break:
        self.set(self.focusView.workButton, enabled: false)
        self.set(self.focusView.breakButton, enabled: true)
        self.set(self.focusView.procrastinateButton, enabled: false)
      case .Procrastination:
        self.set(self.focusView.workButton, enabled: false)
        self.set(self.focusView.breakButton, enabled: false)
        self.set(self.focusView.procrastinateButton, enabled: true)
      default:
        self.set(self.focusView.workButton, enabled: true)
        self.set(self.focusView.breakButton, enabled: true)
        self.set(self.focusView.procrastinateButton, enabled: true)
      }
      
      }, completion: nil)
  }
  
  func set(button: UIButton, enabled: Bool) {
    if enabled {
      button.enabled = true
      button.alpha = 1.0
    } else {
      button.enabled = false
      button.alpha = 0.3
    }
  }
  
}

//MARK: - timer methods
extension FocusViewController {
  
  private func startTimerWithType(timerType: TimerType) {
    
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
      UIApplication.sharedApplication().cancelAllLocalNotifications()
      return
    }
    setUIModeForTimerType(currentType)
    
//    focusView.numberOfWorkPeriodsLabel.text = "\(workPeriods.count)/\(numberOfWorkPeriods)"
    
    let seconds = NSUserDefaults.standardUserDefaults().integerForKey(timerType.rawValue)
    endDate = NSDate(timeIntervalSinceNow: Double(seconds))
    
    if let sharedDefaults = NSUserDefaults(suiteName: "group.de.dasdom.Tomate") {
      sharedDefaults.setDouble(endDate!.timeIntervalSince1970, forKey: "date")
      sharedDefaults.setInteger(seconds, forKey: "maxValue")
      sharedDefaults.synchronize()
    }
    
    let session = WCSession.defaultSession()
    session.delegate = self
    session.activateSession()
    session.transferUserInfo(["date": endDate!.timeIntervalSince1970, "maxValue": seconds])
    
    timer?.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTimeLabel:", userInfo: ["timerType" : seconds], repeats: true)
    
    UIApplication.sharedApplication().cancelAllLocalNotifications()
    
    localNotification = UILocalNotification()
    localNotification!.fireDate = endDate
    localNotification!.alertBody = "Time for " + typeName + " is up!";
    localNotification!.soundName = UILocalNotificationDefaultSoundName
    localNotification!.category = "START_CATEGORY"
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification!)
    
  }
  
  func updateTimeLabel(sender: NSTimer) {
    
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
    setUIModeForTimerType(.Idle)
    
    if let sharedDefaults = NSUserDefaults(suiteName: "group.de.dasdom.Tomate") {
      sharedDefaults.removeObjectForKey("date")
      sharedDefaults.synchronize()
    }
  }
}

extension FocusViewController: WCSessionDelegate {
  
}

//MARK: - alert
private extension FocusViewController {
  
  func showAlert() {
    var alertMessage = NSLocalizedString("Do you want to stop this ", comment: "first part of alert message")
    switch currentType {
    case .Work:
      alertMessage += NSLocalizedString("work timer?", comment: "second part of alert message")
    case .Break:
      alertMessage += NSLocalizedString("break timer?", comment: "secont part of alert message")
    case .Procrastination:
      alertMessage += NSLocalizedString("procrastination?", comment: "secont part of alert message")
    default:
      break
    }
    let alertController = UIAlertController(title: "Stop?", message: alertMessage, preferredStyle: .Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
      print("\(action)")
    })
    alertController.addAction(cancelAction)
    
    let stopAction = UIAlertAction(title: "Stop", style: .Default, handler: { action in
      print("\(action)")
//      if self.currentType == .Work || self.workPeriods.count > 0 {
//        self.workPeriods.removeLast()
//      }
      self.startTimerWithType(.Idle)
    })
    alertController.addAction(stopAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
}


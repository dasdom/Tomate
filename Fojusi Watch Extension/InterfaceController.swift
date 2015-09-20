//
//  InterfaceController.swift
//  Fojusi Watch Extension
//
//  Created by dasdom on 04.07.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ClockKit

class InterfaceController: WKInterfaceController {
  
  @IBOutlet var timerInterface: WKInterfaceTimer!
  @IBOutlet var backgroundGroup: WKInterfaceGroup!
  
  var timer: NSTimer?
  var currentBackgroundImageNumber = 0
  var maxValue = 1
  
  var endDate: NSDate? {
    didSet {
      if let date = endDate where endDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
        timerInterface.setDate(date)
        timerInterface.start()
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateUserInterface", userInfo: nil, repeats: true)
      } else {
        timerInterface.stop()
        timer?.invalidate()
      }
    }
  }
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    let session = WCSession.defaultSession()
    session.delegate = self
    session.activateSession()
  }
  
  override func willActivate() {
    let timeStamp = NSUserDefaults.standardUserDefaults().doubleForKey("timeStamp")
    endDate = NSDate(timeIntervalSince1970: timeStamp)
    maxValue = NSUserDefaults.standardUserDefaults().integerForKey("maxValue")
    
    currentBackgroundImageNumber = 0
    
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  func updateUserInterface() {
    if let endDate = endDate {
//      let remainingTenSecondSteps = Int(endDate.timeIntervalSinceNow/10.0) + 1
      let promillValue = Int(endDate.timeIntervalSinceNow*100.0/Double(maxValue))+1
//      if remainingTenSecondSteps == 0 {
      if promillValue == 0 {
        backgroundGroup.setBackgroundImageNamed(nil)
        return
//      } else if remainingTenSecondSteps < 0 {
      } else if promillValue < 0 {
        timer?.invalidate()
        timerInterface.stop()
        return
      }
//      if currentBackgroundImageNumber != remainingTenSecondSteps {
//        currentBackgroundImageNumber = remainingTenSecondSteps
//        let imageName = "fiveMin\(remainingTenSecondSteps)"
//        backgroundGroup.setBackgroundImageNamed(imageName)
//      }
//      if currentBackgroundImageNumber != promillValue {
        currentBackgroundImageNumber = promillValue
        let formatString = "03"
        let imageName = "fiveMin\(promillValue.format(formatString))"
        backgroundGroup.setBackgroundImageNamed(imageName)
//      }
    }
  }
  
}

extension InterfaceController: WCSessionDelegate {
//  func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
//
//    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//      let timeStamp = userInfo["date"]! as! Double
//      guard timeStamp > 0 else {
//        self.timer?.invalidate()
//        self.timerInterface.stop()
//        self.timerInterface.setDate(NSDate())
//        self.backgroundGroup.setBackgroundImageNamed(nil)
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("timeStamp")
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("maxValue")
//        return
//      }
//      
//      self.maxValue = userInfo["maxValue"] as! Int
//      self.endDate = NSDate(timeIntervalSince1970: timeStamp)
//      self.currentBackgroundImageNumber = 0
//      
//      NSUserDefaults.standardUserDefaults().setDouble(timeStamp, forKey: "timeStamp")
//      NSUserDefaults.standardUserDefaults().setInteger(self.maxValue, forKey: "maxValue")
//      NSUserDefaults.standardUserDefaults().synchronize()
//    }
//  }
  func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      let timeStamp = applicationContext["date"]! as! Double
      guard timeStamp > 0 else {
        self.timer?.invalidate()
        self.timerInterface.stop()
        self.timerInterface.setDate(NSDate())
        self.backgroundGroup.setBackgroundImageNamed(nil)
        NSUserDefaults.standardUserDefaults().removeObjectForKey("timeStamp")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("maxValue")
        return
      }
      
      let server = CLKComplicationServer.sharedInstance()
      for complication in server.activeComplications {
        server.reloadTimelineForComplication(complication)
      }
      
      self.maxValue = applicationContext["maxValue"] as! Int
      self.endDate = NSDate(timeIntervalSince1970: timeStamp)
      self.currentBackgroundImageNumber = 0
      
      NSUserDefaults.standardUserDefaults().setDouble(timeStamp, forKey: "timeStamp")
      NSUserDefaults.standardUserDefaults().setInteger(self.maxValue, forKey: "maxValue")
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
}

extension InterfaceController {
  @IBAction func startWork() {
    sendAction("work")
  }
  
  @IBAction func startBreak() {
    sendAction("break")
  }
  
  @IBAction func stopCurrent() {
    sendAction("stop")
  }
  
  func sendAction(actionSting: String) {
    let session = WCSession.defaultSession()
    session.delegate = self
    session.activateSession()
//    session.transferUserInfo(["action": actionSting])
    do {
      try session.updateApplicationContext(["action": actionSting])
    } catch {
      print("Error")
    }
  }
}

extension Int {
  func format(f: String) -> String {
    return NSString(format: "%\(f)d", self) as String
  }
}


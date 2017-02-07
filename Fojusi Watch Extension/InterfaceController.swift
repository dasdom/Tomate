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

final class InterfaceController: WKInterfaceController {
  
  @IBOutlet var timerInterface: WKInterfaceTimer!
  @IBOutlet var backgroundGroup: WKInterfaceGroup!
  
  var timer: Timer?
  var currentBackgroundImageNumber = 0
  var maxValue = 1
  
  var session: WCSession?
  
  var endDate: Date? {
    didSet {
      if let date = endDate, endDate?.compare(Date()) == ComparisonResult.orderedDescending {
        timerInterface.setDate(date as Date)
        timerInterface.start()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(InterfaceController.updateUserInterface), userInfo: nil, repeats: true)
      } else {
        timerInterface.stop()
        timer?.invalidate()
      }
    }
  }
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    session = WCSession.default()
    session?.delegate = self
    session?.activate()
  }
  
  override func willActivate() {
    let timeStamp = UserDefaults.standard.double(forKey: "timeStamp")
    endDate = Date(timeIntervalSince1970: timeStamp)
    maxValue = UserDefaults.standard.integer(forKey: "maxValue")
    
    currentBackgroundImageNumber = 0
    
    super.willActivate()
  }
  
  func updateUserInterface() {
    if let endDate = endDate {
      let promillValue = Int(endDate.timeIntervalSinceNow*100.0/Double(maxValue))+1
      if promillValue == 0 {
        backgroundGroup.setBackgroundImageNamed(nil)
        return
      } else if promillValue < 0 {
        timer?.invalidate()
        timerInterface.stop()
        return
      }
        currentBackgroundImageNumber = promillValue
        let formatString = "03"
        let imageName = "fiveMin\(promillValue.format(f: formatString))"
        backgroundGroup.setBackgroundImageNamed(imageName)
    }
  }
  
}

extension InterfaceController: WCSessionDelegate {
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //TODO
    }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    DispatchQueue.main.async {  //TODO: Not sure if this is the correct way to update to Swift 3
      let timeStamp = applicationContext["date"]! as! Double
      guard timeStamp > 0 else {
        self.timer?.invalidate()
        self.timerInterface.stop()
        self.timerInterface.setDate(Date())
        self.backgroundGroup.setBackgroundImageNamed(nil)
        UserDefaults.standard.removeObject(forKey: "timeStamp")
        UserDefaults.standard.removeObject(forKey: "maxValue")
        return
      }
      
      self.maxValue = applicationContext["maxValue"] as! Int
      self.endDate = Date(timeIntervalSince1970: timeStamp)
      self.currentBackgroundImageNumber = 0
      
      UserDefaults.standard.set(timeStamp, forKey: "timeStamp")
      UserDefaults.standard.set(self.maxValue, forKey: "maxValue")
      UserDefaults.standard.synchronize()
    }
  }
  
  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
    let server = CLKComplicationServer.sharedInstance()
    for complication in server.activeComplications! {
      server.reloadTimeline(for: complication)
    }
  }
}

extension InterfaceController {
  @IBAction func startWork() {
    sendAction(actionString: "work")
  }
  
  @IBAction func startBreak() {
    sendAction(actionString: "break")
  }
  
  @IBAction func stopCurrent() {
    sendAction(actionString: "stop")
  }
  
  func sendAction(actionString: String) {
    if let session = session, session.isReachable {
      session.sendMessage(["action": actionString], replyHandler: nil, errorHandler: nil)
    }
  }
}

extension Int {
  func format(f: String) -> String {
    return NSString(format: "%\(f)d" as NSString, self) as String
  }
}


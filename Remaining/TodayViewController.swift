//
//  TodayViewController.swift
//  Remaining
//
//  Created by dasdom on 11.03.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit
import NotificationCenter

final class TodayViewController: UIViewController, NCWidgetProviding {
  
  var endDate: NSDate?
  var timer: NSTimer?
  var maxValue: Int?
  
  var timerView: TimerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timerView = TimerView(frame: .zero)
    timerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(timerView)
    
    let button = UIButton(type: .Custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: "openApp", forControlEvents: .TouchUpInside)
    view.addSubview(button)
    
    var constraints = [NSLayoutConstraint]()
    constraints.append(timerView.widthAnchor.constraintEqualToConstant(100))
    constraints.append(timerView.heightAnchor.constraintEqualToConstant(100))
    constraints.append(timerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor))
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[timer]-10@999-|", options: [], metrics: nil, views: ["timer": timerView])
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("|[button]|", options: [], metrics: nil, views: ["button": button])
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]-0@999-|", options: [], metrics: nil, views: ["button": button])
    NSLayoutConstraint.activateConstraints(constraints)
    
    timerView.timeLabel.font = timerView.timeLabel.font.fontWithSize(CGFloat(100.0*0.9/3.0-10.0))
  }
  
  func widgetMarginInsetsForProposedMarginInsets
    (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
      return UIEdgeInsetsZero
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    if let defaults = NSUserDefaults(suiteName: "group.de.dasdom.Tomate") {
      let startDateAsTimeStamp = defaults.doubleForKey("date")
      print("startDate: \(startDateAsTimeStamp)")
      endDate = NSDate(timeIntervalSince1970: startDateAsTimeStamp)
      maxValue = defaults.integerForKey("maxValue")
    }
    //        println("endDate \(endDate)")
    
    timerView.durationInSeconds = 0.0
    timerView.maxValue = 1.0

    timer?.invalidate()
    if endDate != nil {
      timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateLabel", userInfo: nil, repeats: true)
    }
    
    completionHandler(NCUpdateResult.NewData)
  }
  
  func updateLabel() {
    let durationInSeconds = endDate!.timeIntervalSinceNow
    if durationInSeconds > 0 {
      timerView.durationInSeconds = CGFloat(durationInSeconds)
      timerView.maxValue = CGFloat(maxValue!)
      timerView.setNeedsDisplay()
    } else {
      timer?.invalidate()
    }
  }
    
  func openApp() {
    let myAppUrl = NSURL(string: "fojusi://")!
    extensionContext?.openURL(myAppUrl, completionHandler: { (success) in
      if (!success) {
        // let the user know it failed
      }
    })
  }
  
}

extension Int {
  func format(f: String) -> String {
    return NSString(format: "%\(f)d", self) as String
  }
}

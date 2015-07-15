//
//  TodayViewController.swift
//  Remaining
//
//  Created by dasdom on 11.03.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
  var endDate: NSDate?
  var timer: NSTimer?
  var maxValue: Int?
  
  var timerView: TimerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    preferredContentSize = CGSize(width: view.frame.size.width, height: 120)
    timerView = TimerView(frame: CGRect.zeroRect)
    timerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(timerView)
    
    var constraints = [NSLayoutConstraint]()
    constraints.append(timerView.widthAnchor.constraintEqualToConstant(100))
    constraints.append(timerView.heightAnchor.constraintEqualToConstant(100))
    constraints.append(timerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor))
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[timer]-10@999-|", options: [], metrics: nil, views: ["timer": timerView])
    NSLayoutConstraint.activateConstraints(constraints)
    
    timerView.timeLabel.font = timerView.timeLabel.font.fontWithSize(CGFloat(100.0*0.9/3.0-10.0))
    
//    self.view.backgroundColor = UIColor.brownColor()
  }
  
  func widgetMarginInsetsForProposedMarginInsets
    (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
      return UIEdgeInsetsZero
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    //        if let defaults = NSUserDefaults(suiteName: "group.de.dasdom.Tomate") {
    //            let startDateAsTimeStamp = defaults.doubleForKey("date")
    //            println("startDate: \(startDateAsTimeStamp)")
    //            endDate = NSDate(timeIntervalSince1970: startDateAsTimeStamp)
    //        }
    //        println("endDate \(endDate)")
    //
    //        timer?.invalidate()
    //        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateLabel", userInfo: nil, repeats: true)
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    if let defaults = NSUserDefaults(suiteName: "group.de.dasdom.Tomate") {
      let startDateAsTimeStamp = defaults.doubleForKey("date")
      print("startDate: \(startDateAsTimeStamp)", appendNewline: false)
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
//      let seconds = Int(durationInSeconds % 60)
//      let minutes = Int(durationInSeconds / 60.0)
//      let format = "02"
//      let labelText = "\(minutes.format(format))" + ":" + "\(seconds.format(format)) min"
      
//      label.text = labelText
      
      timerView.durationInSeconds = CGFloat(durationInSeconds)
      timerView.maxValue = CGFloat(maxValue!)
      timerView.setNeedsDisplay()
//      print(timerView)
    } else {
      timer?.invalidate()
//      label.text = "-"
    }
  }
}

extension Int {
  func format(f: String) -> String {
    return NSString(format: "%\(f)d", self) as String
  }
}

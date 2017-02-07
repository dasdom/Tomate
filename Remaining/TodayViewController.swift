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
  
  var endDate: Date?
  var timer: Timer?
  var maxValue: Int?
  
  var timerView: TimerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timerView = TimerView(frame: .zero)
    timerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(timerView)
    
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(TodayViewController.openApp), for: .touchUpInside)
    view.addSubview(button)
    
    var constraints = [NSLayoutConstraint]()
    constraints.append(timerView.widthAnchor.constraint(equalToConstant: 100))
    constraints.append(timerView.heightAnchor.constraint(equalToConstant: 100))
    constraints.append(timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[timer]-10@999-|", options: [], metrics: nil, views: ["timer": timerView])
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "|[button]|", options: [], metrics: nil, views: ["button": button])
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[button]-0@999-|", options: [], metrics: nil, views: ["button": button])
    NSLayoutConstraint.activate(constraints)
    
    timerView.timeLabel.font = timerView.timeLabel.font.withSize(CGFloat(100.0*0.9/3.0-10.0))
  }
  
  func widgetMarginInsetsForProposedMarginInsets
    (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
      return UIEdgeInsets.zero
  }
  
  func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    if let defaults = UserDefaults(suiteName: "group.de.dasdom.Tomate") {
      let startDateAsTimeStamp = defaults.double(forKey: "date")
      print("startDate: \(startDateAsTimeStamp)")
      endDate = Date(timeIntervalSince1970: startDateAsTimeStamp)
      maxValue = defaults.integer(forKey: "maxValue")
    }
    //        println("endDate \(endDate)")
    
    timerView.durationInSeconds = 0.0
    timerView.maxValue = 1.0

    timer?.invalidate()
    if endDate != nil {
      timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(TodayViewController.updateLabel), userInfo: nil, repeats: true)
    }
    
    completionHandler(NCUpdateResult.newData)
  }
  
  func updateLabel() {
    let durationInSeconds = endDate!.timeIntervalSinceNow
    if durationInSeconds > 0 {
      timerView.durationInSeconds = CGFloat(durationInSeconds)
      timerView.maxValue = CGFloat(maxValue!)
//      timerView.setNeedsDisplay()
        timerView.updateTimer()
    } else {
      timer?.invalidate()
    }
  }
    
  func openApp() {
    let myAppUrl = URL(string: "fojusi://")!
    extensionContext?.open(myAppUrl, completionHandler: { (success) in
      if (!success) {
        // let the user know it failed
      }
    })
  }
  
}

extension Int {
    func format(f: String) -> String {
        //        return NSString(format: "%\(f)d", self) as String
        return String(format: "%\(f)d", self)
    }
}

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

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        preferredContentSize = CGSize(width: view.frame.size.width, height: 37)
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
            print("startDate: \(startDateAsTimeStamp)")
            endDate = NSDate(timeIntervalSince1970: startDateAsTimeStamp)
        }
//        println("endDate \(endDate)")
        
        timer?.invalidate()
        if endDate != nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateLabel", userInfo: nil, repeats: true)
        }
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    func updateLabel() {
        let durationInSeconds = endDate!.timeIntervalSinceNow
        if durationInSeconds > 0 {
            let seconds = Int(durationInSeconds % 60)
            let minutes = Int(durationInSeconds / 60.0)
            let format = "02"
            let labelText = "\(minutes.format(format))" + ":" + "\(seconds.format(format)) min"
        
            label.text = labelText
        } else {
            timer?.invalidate()
            label.text = "-"
        }
    }
}

extension Int {
    func format(f: String) -> String {
        return NSString(format: "%\(f)d", self) as String
    }
}

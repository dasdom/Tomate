//
//  TodayViewController.swift
//  Remaining
//
//  Created by dasdom on 02.08.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
        
    @IBOutlet weak var label: UILabel!
    var timer: NSTimer?
    var endDate: NSDate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let sharedDefaults = NSUserDefaults(suiteName: "de.dasdom.Tomate.shared")
        endDate = sharedDefaults.objectForKey("date") as? NSDate

        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "updateTimeLabel", userInfo: nil, repeats: true)
        
        println("viewWillAppear, endDate: \(endDate)")
    }
    
    func updateTimeLabel() {
        if let remainingSeconds = endDate?.timeIntervalSinceNow {
            
            println("remainingSeconds: \(remainingSeconds)")
            
            if remainingSeconds < 1 {
                timer?.invalidate()
            }
            
            let minutes = Int(remainingSeconds) / 60
            let twoDigitsFormat = "02"
            //        let remainingTimeString = "\(minutes.format(twoDigitsFormat)):\(seconds.format(twoDigitsFormat))"
            let remainingTimeString = "\(minutes) min"
            label.text = remainingTimeString
        }
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}

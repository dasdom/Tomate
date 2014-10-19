//
//  FocusViewController.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
//import Realm
import AudioToolbox

class FocusViewController: UIViewController {

    private var focusView: FocusView! { return self.view as FocusView }
    private var timer: NSTimer?
    private var endDate: NSDate?
    private var localNotification: UILocalNotification?
    private var currentType = TimerType.Idle
    private var workPeriods = [NSDate]()
    private var numberOfWorkPeriods = 10
    private var totalMinutes = 0
    
    private let kLastDurationKey = "kLastDurationKey"
    private let kLastEndDateKey = "kLastEndDateKey"
    
    //MARK: - view cycle
    override func loadView() {
        view = FocusView(frame: CGRectZero)
        
//        let startValue = CGFloat(TimerType.Work.toRaw())
//        focusView.setDuration(startValue, maxValue: startValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        focusView.workButton.addTarget(self, action: "startWork:", forControlEvents: .TouchUpInside)
        focusView.breakButton.addTarget(self, action: "startBreak:", forControlEvents: .TouchUpInside)
        focusView.settingsButton.addTarget(self, action: "showSettings", forControlEvents: .TouchUpInside)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "showSettings")
        focusView.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if timer == nil {
            focusView.setDuration(0, maxValue: 1)
        }
        
        let duration = NSUserDefaults.standardUserDefaults().integerForKey(TimerType.Work.toRaw())
        println("duration: \(duration)")
    }
    
    //MARK: - button actions
    func startWork(sender: UIButton?) {
        if currentType == .Work {
            showAlert()
            return
        }
        
        startTimerWithType(.Work)
    }
    
    func startBreak(sender: UIButton?) {
        if currentType == .Break {
            showAlert()
            return
        }
        
        startTimerWithType(.Break)
    }
    
    func showSettings() {
        presentViewController(UINavigationController(rootViewController: SettingsViewController()), animated: true, completion: nil)
    }
    
    func setUIModeForTimerType(timerType: TimerType) {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: nil, animations: {
            switch timerType {
            case .Work:
                self.focusView.workButton.alpha = 1.0
                self.focusView.breakButton.alpha = 0.3
                self.focusView.breakButton.enabled = false
            case .Break:
                self.focusView.workButton.alpha = 0.3
                self.focusView.breakButton.alpha = 1.0
                self.focusView.workButton.enabled = false
            default:
                self.focusView.workButton.alpha = 1.0
                self.focusView.breakButton.alpha = 1.0
                self.focusView.workButton.enabled = true
                self.focusView.breakButton.enabled = true
            }
            
            }, completion: nil)
    }
    
}

//MARK: - timer methods
extension FocusViewController {
    
    private func startTimerWithType(timerType: TimerType) {

//        let unfinisedWorkPeriod = WorkPeriod.objectsWhere("temporary = true")
//        println("\(unfinisedWorkPeriod)")
        
        focusView.setDuration(0, maxValue: 1)
        var typeName: String
        switch timerType {
        case .Work:
            typeName = "Work"
            currentType = .Work
            workPeriods.append(NSDate())
        case .Break:
            typeName = "Break"
            currentType = .Break
        default:
            typeName = "None"
            currentType = .Idle
            resetTimer()
            focusView.numberOfWorkPeriodsLabel.text = "\(workPeriods.count)/\(numberOfWorkPeriods)"
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            return
        }
        setUIModeForTimerType(currentType)

        focusView.numberOfWorkPeriodsLabel.text = "\(workPeriods.count)/\(numberOfWorkPeriods)"
        
//        let seconds = NSUserDefaults.standardUserDefaults().integerForKey(timerType.toRaw())
        let seconds = 10
        endDate = NSDate(timeIntervalSinceNow: Double(seconds))
        
//        let workPeriod = WorkPeriod()
//        workPeriod.durationInSeconds = seconds
//        workPeriod.endDate = endDate!

//        let realm = RLMRealm.defaultRealm()
//        realm.beginWriteTransaction()
//        realm.addObject(workPeriod)
//        realm.commitWriteTransaction()
        
        let sharedDefaults = NSUserDefaults(suiteName: "de.dasdom.Tomate.shared")
        sharedDefaults.setObject(endDate, forKey: "date")
        sharedDefaults.synchronize()
        
//        focusView.setDuration(CGFloat(seconds), maxValue: CGFloat(seconds))
        
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTimeLabel:", userInfo: ["timerType" : seconds], repeats: true)
        
        //        displayLink = CADisplayLink(target: self, selector: "updateTimeLabel")
        //        displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
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
        if let type = (sender.userInfo as NSDictionary!)["timerType"] as? Int {
            totalNumberOfSeconds = CGFloat(type)
        } else {
            assert(false, "This should not happen")
            totalNumberOfSeconds = -1.0
        }
        
        let timeInterval = CGFloat(endDate!.timeIntervalSinceNow)
        println("timeInterval: \(timeInterval)")
        if timeInterval < 0 {
            resetTimer()
            if timeInterval > -1 {
                AudioServicesPlaySystemSound(1007)
            }
            return
        }

        focusView.setDuration(timeInterval, maxValue: totalNumberOfSeconds)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        
        currentType = .Idle
        setUIModeForTimerType(.Idle)
    }
}

enum TimerType : String {
    case Work = "Work" //25*60
    case Break = "Break"  //only for testing
    case Idle = "Idle"
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
        default:
            break
        }
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            println("\(action)")
            })
        alertController.addAction(cancelAction)
        
        let stopAction = UIAlertAction(title: "Stop", style: .Default, handler: { action in
            println("\(action)")
            if self.currentType == .Work || self.workPeriods.count > 0 {
                self.workPeriods.removeLast()
            }
            self.startTimerWithType(.Idle)
            })
        alertController.addAction(stopAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}


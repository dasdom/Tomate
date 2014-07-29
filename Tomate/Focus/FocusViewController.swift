//
//  FocusViewController.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit

class FocusViewController: UIViewController {

    private var focusView: FocusView! { return self.view as FocusView }
    private var timer: NSTimer?
    private var endDate: NSDate?
    private var localNotification: UILocalNotification?
    private var currentType = TimerType.Idle

    //MARK: - view cycle
    override func loadView() {
        view = FocusView(frame: CGRectZero)
        
        let startValue = CGFloat(TimerType.Work.toRaw())
        focusView.setDuration(startValue, maxValue: startValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        focusView.button.addTarget(self, action: "startWork:", forControlEvents: .TouchUpInside)
        focusView.breakButton.addTarget(self, action: "startBreak:", forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !timer {
            focusView.setDuration(0, maxValue: CGFloat(currentType.toRaw()))
        }
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
    
    func setUIModeForTimerType(timerType: TimerType) {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: nil, animations: {
            switch timerType {
            case .Work:
                self.focusView.button.alpha = 1.0
                self.focusView.breakButton.alpha = 0.3
                self.focusView.breakButton.enabled = false
            case .Break:
                self.focusView.button.alpha = 0.3
                self.focusView.breakButton.alpha = 1.0
                self.focusView.button.enabled = false
            default:
                self.focusView.button.alpha = 1.0
                self.focusView.breakButton.alpha = 1.0
                self.focusView.button.enabled = true
                self.focusView.breakButton.enabled = true
            }
            
            }, completion: nil)
    }
    
}

//MARK: - timer methods
extension FocusViewController {
    
    private func startTimerWithType(timerType: TimerType) {
        var typeName: String
        switch timerType {
        case .Work:
            typeName = "Work"
            currentType = .Work
        case .Break:
            typeName = "Break"
            currentType = .Break
        default:
            typeName = "None"
            currentType = .Idle
            resetTimer()
            return
        }
        setUIModeForTimerType(currentType)

        
        let seconds = timerType.toRaw()
        endDate = NSDate(timeIntervalSinceNow: Double(seconds))
        
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateTimeLabel:", userInfo: ["timerType" : seconds], repeats: true)
        
        //        displayLink = CADisplayLink(target: self, selector: "updateTimeLabel")
        //        displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        if localNotification {
            UIApplication.sharedApplication().cancelLocalNotification(localNotification)
        }
        
        localNotification = UILocalNotification()
        localNotification!.fireDate = endDate
        localNotification!.alertBody = "Time for " + typeName + " is up!";
        localNotification!.soundName = UILocalNotificationDefaultSoundName
        localNotification!.category = "START_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
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
        if timeInterval < 0 {
            resetTimer()

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
    
    enum TimerType : Int {
        case Work = 1500 //25*60
        //    case Work = 10 //only for testing
        case Break = 300  // 5*60
        case Idle = 0
    }
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


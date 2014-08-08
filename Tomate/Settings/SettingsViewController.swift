//
//  SettingsViewController.swift
//  Tomate
//
//  Created by dasdom on 02.08.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit

let kNumberOfWorkPeriodsKey = "kNumberOfWorkPeriodsKey"

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var settingsView: SettingsView {return view as SettingsView}
    var workTimes = [1, 2, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    
    override func loadView() {
        view = SettingsView(frame: CGRectZero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView.pickerView.dataSource = self
        settingsView.pickerView.delegate = self
        
        let workGestureRecognizer = UITapGestureRecognizer(target: self, action: "moveMarker:")
        settingsView.workInputHostView.addGestureRecognizer(workGestureRecognizer)
       
        let breakGestureRecognizer = UITapGestureRecognizer(target: self, action: "moveMarker:")
        settingsView.breakInputHostView.addGestureRecognizer(breakGestureRecognizer)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let views = ["topLayoutGuide" : topLayoutGuide, "workInputHostView" : settingsView.workInputHostView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-20-[workInputHostView]", options: nil, metrics: nil, views: views))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissSettings")
        navigationItem.rightBarButtonItem = doneButton
        
        let workDuration = NSUserDefaults.standardUserDefaults().integerForKey(TimerType.Work.toRaw()) / 60
        let breakDuration = NSUserDefaults.standardUserDefaults().integerForKey(TimerType.Break.toRaw()) / 60
        
        settingsView.setWorkDurationString("\(workDuration) min")
        settingsView.setBreakDurationString("\(breakDuration) min")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        settingsView.moveMarkerToView(settingsView.workInputHostView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissSettings() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return workTimes.count
    }
    
//    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
//        return "\(workTimes[row]) min"
//    }
//    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
//        
//        let label = UILabel()
//        label.textColor = TimerStyleKit.timerColor
//        label.textAlignment = .Center
//        
//        label.text = "\(workTimes[row]) min"
//        return label
//    }
    func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString! {
        let attributedTitle = NSAttributedString(string: "\(workTimes[row]) min", attributes: [NSForegroundColorAttributeName : TimerStyleKit.timerColor])
        return attributedTitle
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        let minutes = workTimes[row]
        let timerType = settingsView.setDurationString("\(minutes) min")
        let seconds = minutes*60+1
        NSUserDefaults.standardUserDefaults().setInteger(seconds, forKey: timerType.toRaw())
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func moveMarker(sender: UITapGestureRecognizer) {
        settingsView.moveMarkerToView(sender.view)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SettingsViewController.swift
//  Tomate
//
//  Created by dasdom on 02.08.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit

//let kNumberOfWorkPeriodsKey = "kNumberOfWorkPeriodsKey"

final class SettingsViewController: UIViewController {
  
  var settingsView: SettingsView {return view as! SettingsView}
  var workTimes = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
  var breakTimes = [1, 2, 5, 10]
  
  private var currentWorkDurationInMinutes = NSUserDefaults.standardUserDefaults().integerForKey(TimerType.Work.rawValue) / 60
  private var currentBreakDurationInMinutes = NSUserDefaults.standardUserDefaults().integerForKey(TimerType.Break.rawValue) / 60
  
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
    
    title = "Settings"
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let views = ["topLayoutGuide" : topLayoutGuide, "workInputHostView" : settingsView.workInputHostView] as [String: AnyObject]
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-10-[workInputHostView]", options: [], metrics: nil, views: views))
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissSettings")
    navigationItem.rightBarButtonItem = doneButton
    
    settingsView.setWorkDurationString("\(currentWorkDurationInMinutes) min")
    settingsView.setBreakDurationString("\(currentBreakDurationInMinutes) min")
    
    var row = 0
    for (index, minutes) in workTimes.enumerate() {
      if minutes == currentWorkDurationInMinutes {
        row = index
        break
      }
    }
    settingsView.pickerView.selectRow(row, inComponent: 0, animated: false)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    settingsView.moveMarkerToView(settingsView.workInputHostView)
  }
  
  func dismissSettings() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension SettingsViewController : UIPickerViewDelegate, UIPickerViewDataSource {

  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch settingsView.selectedTimerType {
    case .Work:
      return workTimes.count
    default:
      return breakTimes.count
    }
  }
  
  func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    var minutes = 0
    switch settingsView.selectedTimerType {
    case .Work:
      minutes = workTimes[row]
    default:
      minutes = breakTimes[row]
    }
    let attributedTitle = NSAttributedString(string: "\(minutes) min", attributes: [NSForegroundColorAttributeName : UIColor.yellowColor()])
    return attributedTitle
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    var minutes = 0
    switch settingsView.selectedTimerType {
    case .Work:
      minutes = workTimes[row]
      currentWorkDurationInMinutes = minutes
    default:
      minutes = breakTimes[row]
      currentBreakDurationInMinutes = minutes
    }
    
    let timerType = settingsView.setDurationString("\(minutes) min")
    let seconds = minutes*60+1
    NSUserDefaults.standardUserDefaults().setInteger(seconds, forKey: timerType.rawValue)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  func moveMarker(sender: UITapGestureRecognizer) {
    settingsView.moveMarkerToView(sender.view!)
    settingsView.pickerView.reloadAllComponents()
    
    var times: [Int]
    var currentDuration: Int
    switch settingsView.selectedTimerType {
    case .Work:
      times = workTimes
      currentDuration = currentWorkDurationInMinutes
    default:
      times = breakTimes
      currentDuration = currentBreakDurationInMinutes
    }
    
    var row = 0
    for (index, minutes) in times.enumerate() {
      if minutes == currentDuration {
        row = index
        break
      }
    }
    settingsView.pickerView.selectRow(row, inComponent: 0, animated: false)
  }
  
}

//
//  SettingsView.swift
//  Tomate
//
//  Created by dasdom on 02.08.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import QuartzCore

final class SettingsView: UIView {
  
  private let markerView: UIView
  let workInputHostView: InputHostView
  let breakInputHostView: InputHostView
  private let workPeriodsLabel: UILabel
  private let workPeriodsStepper: UIStepper
  let pickerView: UIPickerView
  var selectedTimerType: TimerType
  
  override init(frame: CGRect) {
    
    markerView = {
      let view = UIView()
      view.layer.cornerRadius = 5
      return view
      }()
    
    let workPeriodsSettingsHostView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
      }()
    
    workPeriodsLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
      }()
    workPeriodsSettingsHostView.addSubview(workPeriodsLabel)
    
    workPeriodsStepper = {
      let stepper = UIStepper()
      stepper.translatesAutoresizingMaskIntoConstraints = false
      return stepper
      }()
    workPeriodsSettingsHostView.addSubview(workPeriodsStepper)
    
    
    workInputHostView = InputHostView(frame: CGRectZero)
    workInputHostView.nameLabel.text = NSLocalizedString("Work duration", comment: "Settings name for the work duration")
    workInputHostView.tag = 0
    
    breakInputHostView = InputHostView(frame: CGRectZero)
    breakInputHostView.nameLabel.text = NSLocalizedString("Break duration", comment: "Settings name for the break duration")
    breakInputHostView.tag = 1
    
    pickerView = {
      let pickerView = UIPickerView()
      pickerView.translatesAutoresizingMaskIntoConstraints = false
      pickerView.showsSelectionIndicator = true
      return pickerView
      }()
    
    selectedTimerType = TimerType.Work
    
    super.init(frame: frame)
    
    backgroundColor = TimerStyleKit.backgroundColor
    markerView.backgroundColor = UIColor.yellowColor()
    
    addSubview(markerView)
    addSubview(workInputHostView)
    addSubview(breakInputHostView)
    addSubview(pickerView)
    
    let metrics = ["hostHeight" : 40, "hostViewGap" : 10]
    let views = ["markerView" : markerView, "workHostView" : workInputHostView, "breakHostView" : breakInputHostView, "picker" : pickerView]
    var constraints = [NSLayoutConstraint]()
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("|-5-[workHostView]-5-|", options: [], metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[workHostView(hostHeight,breakHostView)]-hostViewGap-[breakHostView]", options: [.AlignAllLeft, .AlignAllRight], metrics: metrics, views: views)
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("|[picker]|", options: [], metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[breakHostView][picker]", options: [], metrics: nil, views: views)
    
    NSLayoutConstraint.activateConstraints(constraints)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setDurationString(string: String) -> TimerType {
    var timerType = TimerType.Idle
    if CGRectContainsPoint(workInputHostView.frame, markerView.center) {
      setWorkDurationString(string)
      timerType = TimerType.Work
    } else {
      setBreakDurationString(string)
      timerType = TimerType.Break
    }
    return timerType
  }
  
  func setWorkDurationString(string: String) {
    workInputHostView.durationLabel.text = string
  }
  
  func setBreakDurationString(string: String) {
    breakInputHostView.durationLabel.text = string
  }
  
  
  func moveMarkerToView(view: UIView) {
    if CGRectContainsPoint(workInputHostView.frame, view.center) {
      selectedTimerType = .Work
    } else {
      selectedTimerType = .Break
    }
    
    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: [], animations: {
      self.markerView.frame = CGRectInset(view.frame, -3, -3)
      }, completion: nil)
  }
  
  final class InputHostView: UIView {
    let nameLabel: UILabel
    let durationLabel: UILabel
    
    override init(frame: CGRect) {
      let makeLabel = { () -> UILabel in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = TimerStyleKit.timerColor
        label.text = "-"
        return label
      }
      
      nameLabel = makeLabel()
      durationLabel = makeLabel()
      
      super.init(frame: frame)
      
      translatesAutoresizingMaskIntoConstraints = false
      backgroundColor = TimerStyleKit.backgroundColor
      layer.cornerRadius = 5
      
      addSubview(nameLabel)
      addSubview(durationLabel)
      
      let views = ["nameLabel" : nameLabel, "durationLabel" : durationLabel]
      var constraints = [NSLayoutConstraint]()
      
      constraints += NSLayoutConstraint.constraintsWithVisualFormat("|-[nameLabel]-(>=10)-[durationLabel]-|", options: .AlignAllBaseline, metrics: nil, views: views)
      constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[nameLabel(durationLabel)]-|", options: .AlignAllBaseline, metrics: nil, views: views)
      
      NSLayoutConstraint.activateConstraints(constraints)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

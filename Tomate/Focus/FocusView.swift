//
//  TimerView.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import QuartzCore

class FocusView: UIView {
  let timerView: TimerView
  let workButton: UIButton
  let breakButton: UIButton
  let procrastinateButton: UIButton
//  let numberOfWorkPeriodsLabel: UILabel
  //    let stepper: UIStepper
  let settingsButton: UIButton
  
  override init(frame: CGRect) {
    timerView = TimerView(frame: CGRectZero)
    timerView.translatesAutoresizingMaskIntoConstraints = false
    
    let makeButton = { (title: String) -> UIButton in
      let button = UIButton(type: .System)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 40
      button.layer.borderWidth = 1.0
      button.layer.borderColor = UIColor.yellowColor().CGColor
      button.setTitle(title, forState: .Normal)
      button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 22)
      return button
    }
    
//    numberOfWorkPeriodsLabel = {
//      let label = UILabel()
//      label.translatesAutoresizingMaskIntoConstraints = false
//      label.textAlignment = .Center
//      label.textColor = TimerStyleKit.timerColor
//      label.font = UIFont.systemFontOfSize(25)
//      label.text = "0/0"
//      label.hidden = true
//      return label
//      }()
    
    settingsButton = {
      let button = UIButton(type: .System)
      button.translatesAutoresizingMaskIntoConstraints = false
      //            button.backgroundColor = UIColor.blueColor()
      let templateImage = UIImage(named: "settings")!.imageWithRenderingMode(.AlwaysTemplate)
      button.setImage(templateImage, forState: .Normal)
      return button
      }()
    
    workButton = makeButton(NSLocalizedString("Work", comment: "Start working button title"))
    breakButton = makeButton(NSLocalizedString("Break", comment: "Start break button title"))
    
    procrastinateButton = makeButton(NSLocalizedString("Procrastinate", comment: "Start procratination button title"))
    if let font = procrastinateButton.titleLabel?.font {
      procrastinateButton.titleLabel?.font = font.fontWithSize(12)
    }
    
    super.init(frame: frame)
    
    backgroundColor = TimerStyleKit.backgroundColor
    tintColor = UIColor.yellowColor()
    
    addSubview(timerView)
//    addSubview(numberOfWorkPeriodsLabel)
    //        addSubview(stepper)
    addSubview(workButton)
    addSubview(breakButton)
    //        addSubview(centerView)
    addSubview(procrastinateButton)
    addSubview(settingsButton)
    
    let views = ["settingsButton" : settingsButton, "timerView" : timerView, "workButton" : workButton, "breakButton" : breakButton, "procrastinateButton" : procrastinateButton]
    
    NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[settingsButton(44)]-13-|", options: [], metrics: nil, views: views))
    NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[settingsButton(44)]", options: [], metrics: nil, views: views))
    
    timerView.widthAnchor.constraintEqualToConstant(300).active = true
    
    NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timerView(300)]-40-[procrastinateButton(80,==breakButton,==workButton)]", options: .AlignAllCenterX, metrics: nil, views: views))
    
    timerView.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: -50).active = true
    
    NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[breakButton(workButton)]-10-[procrastinateButton(workButton)]-10-[workButton(80)]", options: [], metrics: nil, views: views))

    workButton.centerYAnchor.constraintEqualToAnchor(procrastinateButton.centerYAnchor, constant: -20).active = true
    breakButton.centerYAnchor.constraintEqualToAnchor(workButton.centerYAnchor).active = true

    procrastinateButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
    
//    addConstraint(NSLayoutConstraint(item: numberOfWorkPeriodsLabel, attribute: .CenterY, relatedBy: .Equal, toItem: timerView, attribute: .CenterY, multiplier: 1.0, constant: 70))
//    
//    addConstraint(NSLayoutConstraint(item: numberOfWorkPeriodsLabel, attribute: .CenterX, relatedBy: .Equal, toItem: timerView, attribute: .CenterX, multiplier: 1.0, constant: 0))
    
  }
  
  required convenience init(coder aDecoder: NSCoder) {
    self.init(frame: CGRectZero)
  }
  
  func setDuration(duration: CGFloat, maxValue: CGFloat) {
    timerView.durationInSeconds = duration
    timerView.maxValue = maxValue
    timerView.setNeedsDisplay()
  }
  
}

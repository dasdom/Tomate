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
    let metrics = ["timerWidth": 300, "timerHeight": 300, "workWidth": 80, "settingsWidth": 44]
    
    var constraints = [NSLayoutConstraint]()
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("[settingsButton(settingsWidth)]-13-|", options: [], metrics: metrics, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[settingsButton(settingsWidth)]", options: [], metrics: metrics, views: views)
    
    constraints.append(timerView.widthAnchor.constraintEqualToConstant(CGFloat(metrics["timerWidth"]!)))
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[timerView(timerHeight)]-40-[procrastinateButton(workWidth,breakButton,workButton)]", options: .AlignAllCenterX, metrics: metrics, views: views)
    
    constraints.append(timerView.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: -50))
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("[breakButton]-10-[procrastinateButton]-10-[workButton(workWidth,breakButton,procrastinateButton)]", options: [], metrics: metrics, views: views)

    constraints.append(workButton.centerYAnchor.constraintEqualToAnchor(procrastinateButton.centerYAnchor, constant: -20))
    constraints.append(breakButton.centerYAnchor.constraintEqualToAnchor(workButton.centerYAnchor))

    constraints.append(procrastinateButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor))
    
    NSLayoutConstraint.activateConstraints(constraints)
    
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

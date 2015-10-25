//
//  TimerView.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import QuartzCore

final class FocusView: UIView {
  let timerView: TimerView
  let workButton: UIButton
  let breakButton: UIButton
  let procrastinateButton: UIButton
//  let numberOfWorkPeriodsLabel: UILabel
  //    let stepper: UIStepper
  let settingsButton: UIButton
  let aboutButton: UIButton
  
  let sidePadding = CGFloat(10)
  
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
//                  button.backgroundColor = UIColor.blueColor()
//      if let templateImage = UIImage(named: "settings")?.imageWithRenderingMode(.AlwaysTemplate) {
//        button.setImage(templateImage, forState: .Normal)
//      }
      button.setImage(TimerStyleKit.imageOfSettings, forState: .Normal)
      button.accessibilityLabel = NSLocalizedString("Settings", comment: "")
      return button
      }()
    
    aboutButton = {
      let button = UIButton(type: .System)
      button.translatesAutoresizingMaskIntoConstraints = false
      //            button.backgroundColor = UIColor.blueColor()
//      if let templateImage = UIImage(named: "settings")?.imageWithRenderingMode(.AlwaysTemplate) {
//        button.setImage(templateImage, forState: .Normal)
//      }
      button.setImage(TimerStyleKit.imageOfInfo, forState: .Normal)
      button.accessibilityLabel = NSLocalizedString("About", comment: "")
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
    addSubview(aboutButton)
    
    let views = ["aboutButton": aboutButton, "settingsButton" : settingsButton, "timerView" : timerView, "workButton" : workButton, "breakButton" : breakButton, "procrastinateButton" : procrastinateButton]
//    let metrics = ["timerWidth": 400, "timerHeight": 400, "workWidth": 80, "settingsWidth": 44]
    let metrics = ["workWidth": 80, "settingsWidth": 44, "sidePadding": sidePadding]
    
    var constraints = [NSLayoutConstraint]()
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("|-13-[aboutButton]-(>=10)-[settingsButton(settingsWidth)]-13-|", options: .AlignAllCenterY, metrics: metrics, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[settingsButton(settingsWidth)]", options: [], metrics: metrics, views: views)
    
//    constraints.append(timerView.widthAnchor.constraintEqualToConstant(CGFloat(metrics["timerWidth"]!)))
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("|-(>=sidePadding)-[timerView]-(>=sidePadding)-|", options: [], metrics: metrics, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("|-(==sidePadding@751)-[timerView]-(==sidePadding@751)-|", options: [], metrics: metrics, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=sidePadding)-[timerView]-(>=sidePadding)-|", options: [], metrics: metrics, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==sidePadding@750)-[timerView]-(==sidePadding@750)-|", options: [], metrics: metrics, views: views)
    constraints.append(timerView.widthAnchor.constraintEqualToAnchor(timerView.heightAnchor))
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[timerView]-40-[procrastinateButton(workWidth,breakButton,workButton)]", options: .AlignAllCenterX, metrics: metrics, views: views)
    
    constraints.append(timerView.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: -50))
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("[breakButton]-10-[procrastinateButton]-10-[workButton(workWidth,breakButton,procrastinateButton)]", options: [], metrics: metrics, views: views)

    constraints.append(workButton.centerYAnchor.constraintEqualToAnchor(procrastinateButton.centerYAnchor, constant: -20))
    constraints.append(breakButton.centerYAnchor.constraintEqualToAnchor(workButton.centerYAnchor))

    constraints.append(procrastinateButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor))
    
    NSLayoutConstraint.activateConstraints(constraints)
        
//    addConstraint(NSLayoutConstraint(item: numberOfWorkPeriodsLabel, attribute: .CenterY, relatedBy: .Equal, toItem: timerView, attribute: .CenterY, multiplier: 1.0, constant: 70))
//    
//    addConstraint(NSLayoutConstraint(item: numberOfWorkPeriodsLabel, attribute: .CenterX, relatedBy: .Equal, toItem: timerView, attribute: .CenterX, multiplier: 1.0, constant: 0))

//    timerView.timeLabel.font = timerView.timeLabel.font.fontWithSize((frame.size.width-2*CGFloat(metrics["sidePadding"]!))*0.9/3.0-10.0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setDuration(duration: CGFloat, maxValue: CGFloat) {
    timerView.durationInSeconds = duration
    timerView.maxValue = maxValue
    timerView.setNeedsDisplay()
  }
  
}

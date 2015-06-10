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
    let numberOfWorkPeriodsLabel: UILabel
//    let stepper: UIStepper
    let settingsButton: UIButton
    
    override init(frame: CGRect) {
        timerView = TimerView(frame: CGRectZero)
        timerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let makeButton = { (title: String) -> UIButton in
            let button = UIButton.buttonWithType(.System) as! UIButton
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.layer.cornerRadius = 40
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.yellowColor().CGColor
            button.setTitle(title, forState: .Normal)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 22)
            return button
        }
        
        numberOfWorkPeriodsLabel = {
            let label = UILabel()
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            label.textAlignment = .Center
            label.textColor = TimerStyleKit.timerColor
            label.font = UIFont.systemFontOfSize(25)
            label.text = "0/0"
            label.hidden = true
//            label.backgroundColor = UIColor.yellowColor()
            return label
        }()
        
//        stepper = {
//            let stepper = UIStepper()
//            stepper.setTranslatesAutoresizingMaskIntoConstraints(false)
//            return stepper
//        }()
        
        settingsButton = {
            let button = UIButton.buttonWithType(.System) as! UIButton
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
//            button.backgroundColor = UIColor.blueColor()
            let templateImage = UIImage(named: "settings")!.imageWithRenderingMode(.AlwaysTemplate)
            button.setImage(templateImage, forState: .Normal)
            return button
        }()
        
        workButton = makeButton(NSLocalizedString("Work", comment: "Start working button title"))
        breakButton = makeButton(NSLocalizedString("Break", comment: "Start break button title"))
        
//        let centerView = UIView()
//        centerView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        centerView.backgroundColor = UIColor.yellowColor()
//        procrastinateButton = UIButton.buttonWithType(.System) as UIButton
//        procrastinateButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//        procrastinateButton.setTitle(".", forState: .Normal)
        
        procrastinateButton = makeButton(NSLocalizedString("Procrastinate", comment: "Start procratination button title"))
        if let font = procrastinateButton.titleLabel?.font {
            procrastinateButton.titleLabel?.font = font.fontWithSize(12)
        }
        
        super.init(frame: frame)
        
        backgroundColor = TimerStyleKit.backgroundColor
        tintColor = UIColor.yellowColor()

        addSubview(timerView)
        addSubview(numberOfWorkPeriodsLabel)
//        addSubview(stepper)
        addSubview(workButton)
        addSubview(breakButton)
//        addSubview(centerView)
        addSubview(procrastinateButton)
        addSubview(settingsButton)
        
        let viewsDictionary = ["settingsButton" : settingsButton, "timerView" : timerView, "numberOfWorkPeriodsLabel" : numberOfWorkPeriodsLabel, "workButton" : workButton, "breakButton" : breakButton, "procrastinateButton" : procrastinateButton]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[settingsButton(44)]-13-|", options: nil, metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[settingsButton(44)]", options: nil, metrics: nil, views: viewsDictionary))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[timerView(300)]", options: nil, metrics: nil, views: viewsDictionary))
        addConstraint(NSLayoutConstraint(item: timerView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timerView(300)]-40-[procrastinateButton(80,==breakButton,==workButton)]", options: nil, metrics: nil, views: viewsDictionary))
        
        addConstraint(NSLayoutConstraint(item: timerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -50))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[breakButton(==workButton)]-10-[procrastinateButton(==workButton)]-10-[workButton(80)]", options: nil, metrics: nil, views: viewsDictionary))
        addConstraint(NSLayoutConstraint(item: workButton, attribute: .CenterY, relatedBy: .Equal, toItem: procrastinateButton, attribute: .CenterY, multiplier: 1.0, constant: -20))
        addConstraint(NSLayoutConstraint(item: breakButton, attribute: .CenterY, relatedBy: .Equal, toItem: procrastinateButton, attribute: .CenterY, multiplier: 1.0, constant: -20))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button(40)]-50-|", options: .AlignAllBottom, metrics: nil, views: viewsDictionary))
//        addConstraint(NSLayoutConstraint(item: centerView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: procrastinateButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: numberOfWorkPeriodsLabel, attribute: .CenterY, relatedBy: .Equal, toItem: timerView, attribute: .CenterY, multiplier: 1.0, constant: 70))
        addConstraint(NSLayoutConstraint(item: numberOfWorkPeriodsLabel, attribute: .CenterX, relatedBy: .Equal, toItem: timerView, attribute: .CenterX, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: numberOfWorkPeriodsLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 50))
        
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[numberOfWorkPeriodsLabel]-10-[stepper]", options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))


    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    func setDuration(duration: CGFloat, maxValue: CGFloat) {
        timerView.durationInSeconds = duration
        timerView.maxValue = maxValue
//        setNeedsDisplayInRect(timerView.frame)
        timerView.setNeedsDisplay()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {

    }
    */
}

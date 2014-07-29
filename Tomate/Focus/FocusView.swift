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
    let button: UIButton
    let breakButton: UIButton
    
    init(frame: CGRect) {
        timerView = TimerView(frame: CGRectZero)
        timerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let buttonMaker = { () -> UIButton in
            let button = UIButton.buttonWithType(.System) as UIButton
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.layer.cornerRadius = 40
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.yellowColor().CGColor
            return button
        }
        
        button = buttonMaker()
        button.setTitle(NSLocalizedString("Work", comment: "Start working button title"), forState: .Normal)
        
        breakButton = buttonMaker()
        breakButton.setTitle(NSLocalizedString("Break", comment: "Start break button title"), forState: .Normal)
        
        let centerView = UIView()
        centerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: frame)
        
        backgroundColor = TimerStyleKit.backgroundColor
        tintColor = UIColor.yellowColor()

        addSubview(timerView)
        addSubview(button)
        addSubview(breakButton)
        addSubview(centerView)
        
        let viewsDictionary = ["timerView" : timerView, "button" : button, "breakButton" : breakButton, "centerView" : centerView]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[timerView]-10-|", options: nil, metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[timerView(300)]-20-[button(80,==breakButton)]", options: nil, metrics: nil, views: viewsDictionary))
        
        addConstraint(NSLayoutConstraint(item: timerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -50))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[breakButton(==button)]-30-[centerView]-30-[button(80)]", options: .AlignAllBottom, metrics: nil, views: viewsDictionary))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button(40)]-50-|", options: .AlignAllBottom, metrics: nil, views: viewsDictionary))
        addConstraint(NSLayoutConstraint(item: centerView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
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

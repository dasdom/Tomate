//
//  TimerView.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import QuartzCore

class TimerView: UIView {

    var durationInSeconds: CGFloat = 0.0
    var maxValue: CGFloat = 60.0
    var showRemaining = true
    let timerShapeLayer: CAShapeLayer
    let fullShapeLayer: CAShapeLayer
    let timeLabel: UILabel
    
    override init(frame: CGRect) {
        
        timerShapeLayer = CAShapeLayer()
        fullShapeLayer = CAShapeLayer()
        
        timeLabel = {
            let label = UILabel()
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            label.font = UIFont.systemFontOfSize(80)
            label.textColor = TimerStyleKit.timerColor
            return label
        }()
        
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        
        addSubview(timeLabel)
        
        layer.addSublayer(timerShapeLayer)
        layer.addSublayer(fullShapeLayer)
        
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
//        TimerStyleKit.drawTimer(durationInSeconds, maxValue: maxValue, showRemaining: showRemaining)
        
        var percentage: CGFloat
        var dummyInt: Int
        if !showRemaining {
            dummyInt = Int(100000.0*(1 - durationInSeconds / maxValue))
//            percentage = 1 - durationInSeconds / maxValue
        } else {
            dummyInt = Int(100000.0*durationInSeconds / maxValue)
//            percentage = durationInSeconds / maxValue
        }
        percentage = CGFloat(dummyInt)/100000.0
        
        let timerCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        let radius = rect.size.width / 2 - 10
        let startAngle = 3 * CGFloat(M_PI)/2
        
        var timerRingPath = UIBezierPath(arcCenter: timerCenter, radius: radius, startAngle: startAngle, endAngle: startAngle-0.001, clockwise: true)
//        timerRingPath.addArcWithCenter(timerCenter, radius: radius, startAngle: startAngle, endAngle: startAngle - 0.001, clockwise: true)
        
//        println("percentage: \(percentage)")
        timerShapeLayer.fillColor = UIColor.clearColor().CGColor
        timerShapeLayer.strokeColor = TimerStyleKit.timerColor.CGColor
        timerShapeLayer.lineWidth = 3
        timerShapeLayer.strokeEnd = percentage
        timerShapeLayer.path = timerRingPath.CGPath
        timerShapeLayer.shadowColor = TimerStyleKit.timerColor.CGColor
        timerShapeLayer.shadowOffset = CGSizeMake(0.1, -0.1)
        timerShapeLayer.shadowRadius = 3
        timerShapeLayer.shadowOpacity = 1.0
        
        let totalMinutes = maxValue / 60
        let dashLength = 2*radius*CGFloat(M_PI)/totalMinutes;
        timerShapeLayer.lineDashPattern = [dashLength-2.0, 2.0]
        
//        println("timerShapeLayer \(timerShapeLayer)")
        
        let fullRingPath = UIBezierPath(arcCenter: timerCenter, radius: radius+2, startAngle: startAngle, endAngle: startAngle - 0.001, clockwise: true)
        
        fullShapeLayer.fillColor = UIColor.clearColor().CGColor
        fullShapeLayer.strokeColor = TimerStyleKit.timerColor.CGColor
        fullShapeLayer.lineWidth = 1
        fullShapeLayer.strokeEnd = 1.0
        fullShapeLayer.path = fullRingPath.CGPath
        
        
        if !showRemaining {
            durationInSeconds = maxValue - durationInSeconds
        }
        let seconds = Int(durationInSeconds % 60)
        let minutes = Int(durationInSeconds / 60.0)
        let format = "02"
        let labelText = "\(minutes.format(format))" + ":" + "\(seconds.format(format))"
        
        timeLabel.text = labelText
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        showRemaining = !showRemaining
        setNeedsDisplay()
    }

}

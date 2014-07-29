//
//  TimerView.swift
//  Tomate
//
//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit

class TimerView: UIView {

    var durationInSeconds: CGFloat = 0.0
    var maxValue: CGFloat = 60.0
    var showRemaining = true
    
    init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        TimerStyleKit.drawTimer(durationInSeconds, maxValue: maxValue, showRemaining: showRemaining)
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        showRemaining = !showRemaining
        setNeedsDisplay()
    }

}

//  Created by dasdom on 29.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import QuartzCore

final class TimerView: UIView {
  
  var durationInSeconds: CGFloat = 0.0
  var maxValue: CGFloat = 60.0
  var showRemaining = true
  let timerShapeLayer: CAShapeLayer
  let secondsShapeLayer: CAShapeLayer
  let timeLabel: UILabel
  
  private var radius: CGFloat = 0.0
  private var timerCenter: CGPoint = CGPoint(x: 0.0, y: 0.0)
  private let startAngle = -CGFloat.pi / 2
  private let endAngle = 3 * CGFloat.pi / 2
  
  private var timerRingPath: UIBezierPath!
  private var secondsRingPath: UIBezierPath!
  private var fullRingPath: UIBezierPath!
  
  override init(frame: CGRect) {
    
    timerShapeLayer = CAShapeLayer()
    secondsShapeLayer = CAShapeLayer()
    
    timeLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont(name: "HelveticaNeue-Thin", size: 80)
      //      label.adjustsFontSizeToFitWidth = true
      label.textAlignment = .center
      label.textColor = TimerStyleKit.timerColor
      //      label.backgroundColor = UIColor.yellowColor()
      return label
    }()
    
    super.init(frame: frame)
    backgroundColor = UIColor.clear
    
    addSubview(timeLabel)
    
    layer.addSublayer(timerShapeLayer)
    layer.addSublayer(secondsShapeLayer)
    
    var constraints = [NSLayoutConstraint]()
    constraints.append(timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
    constraints.append(timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor))
    NSLayoutConstraint.activate(constraints)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    
    timerCenter = CGPoint(x: rect.midX, y: rect.midY)
    radius = rect.size.width / 2 - 10
    
    initTimerState()
    settingTimerRingStyle()
    settingSecondsRingStyle()
    settingFullRingStyle()
    print("Draw Rect")
  }
  
  func updateTimer() {
    
    var percentage: CGFloat
    var dummyInt: Int
    if !showRemaining {
      dummyInt = Int(100000.0*(1 - (durationInSeconds-1) / maxValue))
      //            percentage = 1 - durationInSeconds / maxValue
    } else {
      dummyInt = Int(100000.0*(durationInSeconds-1) / maxValue)
      //            percentage = durationInSeconds / maxValue
    }
    percentage = CGFloat(dummyInt)/100000.0
    
    var secondsPercentage: CGFloat
    if showRemaining {
      secondsPercentage = (durationInSeconds-1).truncatingRemainder(dividingBy: 60.0)
    } else {
      secondsPercentage = 60.0 - (durationInSeconds-1).truncatingRemainder(dividingBy: 60.0)
      
    }
    
    if durationInSeconds > 0 && !showRemaining {
      durationInSeconds = maxValue - durationInSeconds
    }
    let seconds = Int(durationInSeconds.truncatingRemainder(dividingBy: 60))
    let minutes = Int(durationInSeconds / 60.0)
    let format = "02"
    let labelText = "\(minutes.format(f: format))" + ":" + "\(seconds.format(f: format))"
    
    timeLabel.text = labelText
    
    let totalMinutes = (maxValue-1) / 60
    let dashLength = 2*radius*CGFloat.pi/totalMinutes
    let lineDashPatternFirstLength = (dashLength-CGFloat(2)) as NSNumber  //TODO: Maybe not too beautiful
    timerShapeLayer.lineDashPattern = [lineDashPatternFirstLength, 2]
    
    timerShapeLayer.strokeEnd = percentage
    secondsShapeLayer.strokeEnd = CGFloat(secondsPercentage) / 60.0
  }
  
  private func initTimerState() {
    timerShapeLayer.strokeEnd = 0.0
    secondsShapeLayer.strokeEnd = 0.0
  }
  
  private func settingTimerRingStyle() {
    timerRingPath = UIBezierPath(arcCenter: timerCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    timerShapeLayer.path = timerRingPath.cgPath
    
    timerShapeLayer.fillColor = UIColor.clear.cgColor
    timerShapeLayer.strokeColor = TimerStyleKit.timerColor.cgColor
    timerShapeLayer.lineWidth = 3
  }
  
  private func settingSecondsRingStyle() {
    secondsRingPath = UIBezierPath(arcCenter: timerCenter, radius: radius-4, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    secondsShapeLayer.path = secondsRingPath.cgPath
    
    secondsShapeLayer.fillColor = UIColor.clear.cgColor
    secondsShapeLayer.strokeColor = TimerStyleKit.timerColor.cgColor
    secondsShapeLayer.lineWidth = 1.0
    //secondsShapeLayer.strokeEnd = CGFloat(secondsPercentage)/60.0
  }
  
  private func settingFullRingStyle() {
    TimerStyleKit.timerColor.set()
    
    fullRingPath = UIBezierPath(arcCenter: timerCenter, radius: radius+4, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    
    fullRingPath.lineWidth = 1.0
    fullRingPath.stroke()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    showRemaining = !showRemaining
    //    setNeedsDisplay()
    updateTimer()
  }
  
}

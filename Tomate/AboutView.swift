//
//  AboutView.swift
//  Tomate
//
//  Created by dasdom on 15.07.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import UIKit

class AboutView: UIView {
  
  let twitterButton: UIButton
  
  override init(frame: CGRect) {
    
    let avatarWidth = CGFloat(120)
    
    let avatarImageView = UIImageView(image: UIImage(named: "avatar"))
    avatarImageView.layer.cornerRadius = avatarWidth/2.0
    avatarImageView.clipsToBounds = true
    
    let handleLabel = UILabel(frame: CGRect.zeroRect)
    handleLabel.text = "@dasdom"
    handleLabel.textColor = UIColor.yellowColor()
    
    twitterButton = UIButton(type: .System)
    twitterButton.setTitle("Twitter", forState: .Normal)
    twitterButton.layer.borderWidth = 1
    twitterButton.layer.borderColor = UIColor.yellowColor().CGColor
    twitterButton.layer.cornerRadius = 5
    
    let stackView = UIStackView(arrangedSubviews: [avatarImageView, handleLabel, twitterButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
//    stackView.distribution = UIStackViewDistribution.EqualSpacing
    stackView.axis = .Vertical
    stackView.alignment = .Center
    stackView.spacing = 10
    
    super.init(frame: frame)
    
    tintColor = UIColor.yellowColor()
    backgroundColor = TimerStyleKit.backgroundColor
    
    addSubview(stackView)
    
    var layoutConstraints = [NSLayoutConstraint]()
    layoutConstraints.append(stackView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 80))
    layoutConstraints.append(stackView.centerXAnchor.constraintEqualToAnchor(centerXAnchor))
    layoutConstraints.append(avatarImageView.widthAnchor.constraintEqualToConstant(avatarWidth))
    layoutConstraints.append(avatarImageView.heightAnchor.constraintEqualToConstant(avatarWidth))
    layoutConstraints.append(twitterButton.widthAnchor.constraintEqualToConstant(120))
    NSLayoutConstraint.activateConstraints(layoutConstraints)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
}

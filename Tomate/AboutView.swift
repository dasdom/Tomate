//
//  AboutView.swift
//  Tomate
//
//  Created by dasdom on 15.07.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import UIKit

final class AboutView: UIView {
  
  let twitterButton: UIButton
  let githubButton: UIButton
  let rateButton: UIButton
  let stackView: UIStackView
  
  override init(frame: CGRect) {
    
    let avatarWidth = CGFloat(120)
    
    let avatarImageView = UIImageView(image: UIImage(named: "avatar"))
    avatarImageView.layer.cornerRadius = avatarWidth/2.0
    avatarImageView.clipsToBounds = true
    
    let handleLabel = UILabel(frame: .zero)
    handleLabel.text = "@fojusiapp"
    handleLabel.textColor = TimerStyleKit.timerColor
    
    let buttonWithTitle = { (title: String) -> UIButton in
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.yellow.cgColor
      button.layer.cornerRadius = 5
      button.widthAnchor.constraint(equalToConstant: 120).isActive = true
      return button
    }
    
    twitterButton = buttonWithTitle("Twitter")
    githubButton = buttonWithTitle("Github")
    rateButton = buttonWithTitle("Rate me")
    
    stackView = UIStackView(arrangedSubviews: [avatarImageView, handleLabel, twitterButton, githubButton, rateButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 10
    
    super.init(frame: frame)
    
    tintColor = .yellow
    backgroundColor = TimerStyleKit.backgroundColor
    
    addSubview(stackView)
    
    var layoutConstraints = [NSLayoutConstraint]()
    layoutConstraints.append(stackView.centerXAnchor.constraint(equalTo: centerXAnchor))
    layoutConstraints.append(avatarImageView.widthAnchor.constraint(equalToConstant: avatarWidth))
    layoutConstraints.append(avatarImageView.heightAnchor.constraint(equalToConstant: avatarWidth))
    NSLayoutConstraint.activate(layoutConstraints)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
}

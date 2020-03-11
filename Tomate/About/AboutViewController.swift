//
//  AboutViewController.swift
//  Tomate
//
//  Created by dasdom on 15.07.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import UIKit
import SafariServices

final class AboutViewController: UIViewController {

  private var aboutView: AboutView {
    return view as! AboutView
  }
  
  override func loadView() {
    let contentView = AboutView(frame: .zero)
    
    title = NSLocalizedString("About", comment: "About")
//    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: TimerStyleKit.timerColor]
    
    contentView.twitterButton.addTarget(self, action: #selector(openTwitter), for: .touchUpInside)
    contentView.githubButton.addTarget(self, action: #selector(openGithub), for: .touchUpInside)
    contentView.rateButton.addTarget(self, action: #selector(openRating), for: .touchUpInside)

    view = contentView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    aboutView.stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissAbout))
    navigationItem.rightBarButtonItem = doneButton
  }
  
  @objc func dismissAbout() {
    dismiss(animated: true, completion: nil)
  }
}

//MARK: - Button actions
extension AboutViewController {
  @objc func openTwitter() {
    let safariViewController = SFSafariViewController(url: URL(string: "https://twitter.com/fojusiapp")!)
    present(safariViewController, animated: true, completion: nil)
  }
  
  @objc func openGithub() {
    let safariViewController = SFSafariViewController(url: URL(string: "https://github.com/dasdom/Tomate")!)
    present(safariViewController, animated: true, completion: nil)
  }
  
  @objc func openRating() {
    UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=923044693")!)
  }
}

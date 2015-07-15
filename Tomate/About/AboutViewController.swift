//
//  AboutViewController.swift
//  Tomate
//
//  Created by dasdom on 15.07.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

//  var aboutView: AboutView {
//    return view as! AboutView
//  }
  
  override func loadView() {
    let contentView = AboutView(frame: CGRect.zeroRect)
    
    title = NSLocalizedString("About", comment: "About")
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    
    view = contentView
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissAbout")
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func dismissAbout() {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

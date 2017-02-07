//
//  TimerType.swift
//  Tomate
//
//  Created by dasdom on 11.06.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import Foundation

//TODO: Enum cases should be lower case in Swift 3, but "break" is a keyword.

enum TimerType : String {
  case Work = "Work"
  case Break = "Break"
  case Procrastination = "Procrastination"
  case Idle = "Idle"
}

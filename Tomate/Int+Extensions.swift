//
//  Int+Extensions.swift
//  Tomate
//
//  Created by dasdom on 30.06.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import Foundation

extension Int {
    func format(f: String) -> String {
//        return NSString(format: "%\(f)d", self) as String
        return String(format: "%\(f)d", self)
    }
}
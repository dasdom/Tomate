//
//  Fojusi_UI_Tests.swift
//  Fojusi UI Tests
//
//  Created by dasdom on 13.06.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import Foundation
import XCTest

class Fojusi_UI_Tests: XCTestCase {
  
  let app = XCUIApplication()

  var breakButton: XCUIElement!
  var procrastinateButton: XCUIElement!
  var workButton: XCUIElement!
  
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    breakButton = app.buttons["Break"]
    procrastinateButton = app.buttons["Procrastinate"]
    workButton = app.buttons["Work"]
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testSelectingBreakDisablesOtherButtons() {
    XCTAssertTrue(procrastinateButton.enabled)
    XCTAssertTrue(workButton.enabled)
    XCTAssertTrue(breakButton.enabled)
    
    breakButton.tap()
    
    XCTAssertFalse(procrastinateButton.enabled)
    XCTAssertFalse(workButton.enabled)
    
    XCTAssertTrue(breakButton.enabled)
    breakButton.tap()
    app.alerts["Stop?"].collectionViews.buttons["Stop"].tap()
  }
  
  func testSelectingWorkDisablesOtherButtons() {
    XCTAssertTrue(procrastinateButton.enabled)
    XCTAssertTrue(workButton.enabled)
    XCTAssertTrue(breakButton.enabled)
    
    workButton.tap()
    
    XCTAssertFalse(procrastinateButton.enabled)
    XCTAssertFalse(breakButton.enabled)
    
    XCTAssertTrue(workButton.enabled)
    workButton.tap()
    app.alerts["Stop?"].collectionViews.buttons["Stop"].tap()
  }
  
  func testSelectingProcrastinateDisablesOtherButtons() {
    XCTAssertTrue(procrastinateButton.enabled)
    XCTAssertTrue(workButton.enabled)
    XCTAssertTrue(breakButton.enabled)
    
    procrastinateButton.tap()
    
    XCTAssertFalse(workButton.enabled)
    XCTAssertFalse(breakButton.enabled)
    
    XCTAssertTrue(procrastinateButton.enabled)
    procrastinateButton.tap()
    app.alerts["Stop?"].collectionViews.buttons["Stop"].tap()
  }
  
}

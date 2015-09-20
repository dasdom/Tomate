//
//  ComplicationController.swift
//  Fojusi Watch Extension
//
//  Created by dasdom on 04.07.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
  
//  var nextDate = NSDate(timeIntervalSinceNow: 10)
  
  // MARK: - Timeline Configuration
  
  func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
    handler([.None])
  }
  
  func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
    handler(nil)
  }
  
  func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
    handler(nil)
  }
  
  func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
    handler(.ShowOnLockScreen)
  }
  
  // MARK: - Timeline Population
  
  func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
    // Call the handler with the current timeline entry
    
    let timestamp = NSUserDefaults.standardUserDefaults().doubleForKey("timeStamp")
    let date = NSDate(timeIntervalSince1970: timestamp)
    
    var entry: CLKComplicationTimelineEntry?
    switch complication.family {
    case .ModularSmall:
      print("ModularSmall")
      let template = CLKComplicationTemplateModularSmallRingText()
      template.textProvider = CLKRelativeDateTextProvider(date: date, style: .Timer, units: [.Minute])
      template.fillFraction = 0.85
      template.ringStyle = CLKComplicationRingStyle.Closed
      
      entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
    case .ModularLarge:
      print("ModularLarge")
      let template = CLKComplicationTemplateModularLargeTallBody()
      template.headerTextProvider = CLKSimpleTextProvider(text: "Remaining")
      template.bodyTextProvider = CLKRelativeDateTextProvider(date: date, style: .Timer, units: [.Minute, .Second])
      
      entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
    case .CircularSmall:
      print("CircularSmall")
      let template = CLKComplicationTemplateCircularSmallRingText()
      template.textProvider = CLKRelativeDateTextProvider(date: date, style: .Timer, units: [.Minute])
      template.fillFraction = 0.85
      template.ringStyle = CLKComplicationRingStyle.Closed
      
      entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
    case .UtilitarianLarge:
      print("UtilitarianLarge")
      let template = CLKComplicationTemplateUtilitarianLargeFlat()
      template.textProvider = CLKRelativeDateTextProvider(date: date, style: .Timer, units: [.Minute, .Second])
      entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
    case .UtilitarianSmall:
      print("UtilitarianSmall")
      let template = CLKComplicationTemplateUtilitarianSmallRingText()
      template.textProvider = CLKRelativeDateTextProvider(date: date, style: .Timer, units: [.Minute])
      template.fillFraction = 0.85
      template.ringStyle = CLKComplicationRingStyle.Closed
      
      entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
    }
    handler(entry)
  }
  
  func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries prior to the given date
    handler(nil)
  }
  
  func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries after to the given date
    print(complication.family)
    handler(nil)
  }
  
  // MARK: - Update Scheduling
  
  func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    handler(nil);
  }
  
  // MARK: - Placeholder Templates
  
  func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    var template: CLKComplicationTemplate?
    switch complication.family {
    case .ModularSmall:
      print("ModularSmall")
      let modularSmallTemplate = CLKComplicationTemplateModularSmallRingText()
      modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: "25")
      modularSmallTemplate.fillFraction = 1.00
      modularSmallTemplate.ringStyle = CLKComplicationRingStyle.Closed

      template = modularSmallTemplate
    case .ModularLarge:
      print("ModularLarge")
      let modularLargeTemplate = CLKComplicationTemplateModularLargeTallBody()
      modularLargeTemplate.headerTextProvider = CLKSimpleTextProvider(text: "Remaining")
      modularLargeTemplate.bodyTextProvider = CLKSimpleTextProvider(text: "25.00")
      
      template = modularLargeTemplate
    case .CircularSmall:
      print("CircularSmall")
      let circularSmallTemplate = CLKComplicationTemplateCircularSmallRingText()
      circularSmallTemplate.textProvider = CLKSimpleTextProvider(text: "25")
      circularSmallTemplate.fillFraction = 1.00
      circularSmallTemplate.ringStyle = CLKComplicationRingStyle.Closed
      
      template = circularSmallTemplate
    case .UtilitarianLarge:
      print("UtilitarianLarge")
      let unitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
      unitarianLargeTemplate.textProvider = CLKSimpleTextProvider(text: "25:00")
      template = unitarianLargeTemplate
    case .UtilitarianSmall:
      print("UtilitarianSmall")
      let unitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingText()
      unitarianSmallTemplate.textProvider = CLKSimpleTextProvider(text: "25")
      unitarianSmallTemplate.fillFraction = 1.00
      unitarianSmallTemplate.ringStyle = CLKComplicationRingStyle.Closed
      template = unitarianSmallTemplate
    }
    handler(template)
  }
  
}

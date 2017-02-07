//
//  ComplicationController.swift
//  Fojusi Watch Extension
//
//  Created by dasdom on 04.07.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import ClockKit

final class ComplicationController: NSObject, CLKComplicationDataSource {
  
    var nextDate: Date?
  
  // MARK: - Timeline Configuration
  public func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
    handler([])
  }
  
  func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    handler(nil)
  }
  
  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    handler(nil)
  }
  
  func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    handler(.showOnLockScreen)
  }
  
  // MARK: - Timeline Population
  public func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    // Call the handler with the current timeline entry
    
    let timestamp = UserDefaults.standard.double(forKey: "timeStamp")
    let date = Date(timeIntervalSince1970: timestamp)
    nextDate = date
    
    var entry: CLKComplicationTimelineEntry?
    switch complication.family {
    case .modularSmall:
      print("modularSmall")
      let template = CLKComplicationTemplateModularSmallSimpleText()
      if timestamp < 1 {
        template.textProvider = CLKSimpleTextProvider(text: "-:--")
      } else {
        template.textProvider = CLKRelativeDateTextProvider(date: date, style: .timer, units: [.minute])
      }
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
    case .modularLarge:
      print("modularLarge")
      let template = CLKComplicationTemplateModularLargeTallBody()
      template.headerTextProvider = CLKSimpleTextProvider(text: "Remaining")
      if timestamp < 1 {
        template.bodyTextProvider = CLKSimpleTextProvider(text: "-:--")
      } else {
        template.bodyTextProvider = CLKRelativeDateTextProvider(date: date, style: .timer, units: [.minute, .second])
      }
      
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
    case .circularSmall:
      print("circularSmall")
      let template = CLKComplicationTemplateCircularSmallSimpleText()
      if timestamp < 1 {
        template.textProvider = CLKSimpleTextProvider(text: "-:--")
      } else {
        template.textProvider = CLKRelativeDateTextProvider(date: date, style: .timer, units: [.minute])
      }
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
    case .utilitarianLarge:
      print("utilitarianLarge")
      let template = CLKComplicationTemplateUtilitarianLargeFlat()
      if timestamp < 1 {
        template.textProvider = CLKSimpleTextProvider(text: "-:--")
      } else {
        template.textProvider = CLKRelativeDateTextProvider(date: date, style: .timer, units: [.minute, .second])
      }
      
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
    case .utilitarianSmall:
      print("utilitarianSmall")
      let template = CLKComplicationTemplateUtilitarianSmallFlat()
      if timestamp < 1 {
        template.textProvider = CLKSimpleTextProvider(text: "-:--")
      } else {
        template.textProvider = CLKRelativeDateTextProvider(date: date, style: .timer, units: [.minute])
      }
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
    case .utilitarianSmallFlat:
      //TODO
      break
    case .extraLarge:
      //TODO
      break
    }
    handler(entry)
  }
  
  func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries prior to the given date
    handler(nil)
  }
  
  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries after to the given date
    print(complication.family)
    handler(nil)
  }
  
  // MARK: - Update Scheduling
  func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    handler(nextDate);
  }
  
  // MARK: - Placeholder Templates
  func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    var template: CLKComplicationTemplate?
    switch complication.family {
    case .modularSmall:
      print("modularSmall")
      let modularSmallTemplate = CLKComplicationTemplateModularSmallRingText()
      modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: "25")
      modularSmallTemplate.fillFraction = 1.00
      modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed

      template = modularSmallTemplate
    case .modularLarge:
      print("modularLarge")
      let modularLargeTemplate = CLKComplicationTemplateModularLargeTallBody()
      modularLargeTemplate.headerTextProvider = CLKSimpleTextProvider(text: "Remaining")
      modularLargeTemplate.bodyTextProvider = CLKSimpleTextProvider(text: "25.00")
      
      template = modularLargeTemplate
    case .circularSmall:
      print("mircularSmall")
      let circularSmallTemplate = CLKComplicationTemplateCircularSmallRingText()
      circularSmallTemplate.textProvider = CLKSimpleTextProvider(text: "25")
      circularSmallTemplate.fillFraction = 1.00
      circularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
      
      template = circularSmallTemplate
    case .utilitarianLarge:
      print("utilitarianLarge")
      let unitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
      unitarianLargeTemplate.textProvider = CLKSimpleTextProvider(text: "25:00")
      template = unitarianLargeTemplate
    case .utilitarianSmall:
      print("utilitarianSmall")
      let unitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingText()
      unitarianSmallTemplate.textProvider = CLKSimpleTextProvider(text: "25")
      unitarianSmallTemplate.fillFraction = 1.00
      unitarianSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
      template = unitarianSmallTemplate
    case .utilitarianSmallFlat:
      //TODO
      break
    case .extraLarge:
      //TODO
      break
    }
    handler(template)
  }
  
}

//
//  DataManager.swift
//  Tomate
//
//  Created by dasdom on 02.07.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    func saveContext () {
        var error: NSError? = nil
        if managedObjectContext == nil {
            return
        }
        if !managedObjectContext.hasChanges {
            return
        }
        if managedObjectContext.save(&error) {
            return
        }
        
        println("Error saving context: \(error?.localizedDescription)\n\(error?.userInfo)")
        abort()
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let modelURL = NSBundle.mainBundle().URLForResource("Tomate", withExtension: "momd")
        let mom = NSManagedObjectModel(contentsOfURL: modelURL)
        ZAssert(mom != nil, "Error initializing mom from: \(modelURL)")
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let storeURL = (urls[urls.endIndex-1]).URLByAppendingPathComponent("Tomate.sqlite")
        
        var error: NSError? = nil
        
        var store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
        if (store == nil) {
            println("Failed to load store")
        }
        ZAssert(store != nil, "Unresolved error \(error?.localizedDescription), \(error?.userInfo)\nAttempted to create store at \(storeURL)")
        
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = psc
        
        return managedObjectContext
        }()
}

let DEBUG = true

func ZAssert(test: Bool, message: String) {
    if (test) {
        return
    }
    
    println(message)
    
    if (!DEBUG) {
        return
    }
    
    var exception = NSException()
    exception.raise()
}

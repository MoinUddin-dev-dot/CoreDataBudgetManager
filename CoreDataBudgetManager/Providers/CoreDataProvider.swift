//
//  CoreDataProvider.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(inMemory: Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "BudgetModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        
        persistentContainer.loadPersistentStores { _, error in
            if let error{
               fatalError("core data failed to initialize: \(error)")
            }
        }
        
    }
}

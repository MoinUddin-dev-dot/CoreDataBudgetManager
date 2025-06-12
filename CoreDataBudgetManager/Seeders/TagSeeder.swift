//
//  TagSeeder.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/31/25.
//

import Foundation
import CoreData

class TagSeeder{
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seed(_ commonTags: [String]) throws {
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
            
            try context.save()
        }
    }
}

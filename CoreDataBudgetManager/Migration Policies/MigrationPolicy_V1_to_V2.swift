//
//  MigrationPolicy_V1_to_V2.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 6/12/25.
//

import Foundation
import CoreData

class MigrationPolicy_V1_to_V2: NSEntityMigrationPolicy {
    
    override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
        var titles : [String] = []
        var index: Int = 1
        
        let context = manager.sourceContext
        
        let expenseRequest = Expense.fetchRequest()
        let results: [NSManagedObject] = try context.fetch(expenseRequest)
        
        for result in results {
            guard let title = result.value(forKey: "title") as? String else { continue }
            if !titles.contains(title){
                titles.append(title)
            }else {
                //delelte
//                context.delete(result)
                
                // duplicate entry
                let uniqueString = title + "\(index)"
                index += 1
                result.setValue(uniqueString, forKey: "title")
            }
        }
        
    }
}

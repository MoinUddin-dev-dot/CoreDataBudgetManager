//
//  Expense+Extension.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 6/12/25.
//

import Foundation
import CoreData

extension Expense {
    
    var total: Double {
        amount * Double(quantity)
    }
    
    static func exist(context: NSManagedObjectContext , title: String) -> Bool {
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}

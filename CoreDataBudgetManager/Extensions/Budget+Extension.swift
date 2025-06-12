//
//  Budget+Extension.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import Foundation
import CoreData

extension Budget {
    
    static func exist(context: NSManagedObjectContext , title: String) -> Bool {
        
        let request = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
     var spent : Double {
        guard let expenses = expense as? Set<Expense> else { return 0}
        return expenses.reduce(0) { partialResult, expense in
            return expense.amount + partialResult
        }
    }
    
     var remaining: Double {
        return limit - spent
    }
}

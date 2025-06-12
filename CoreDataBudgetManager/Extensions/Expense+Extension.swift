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
}

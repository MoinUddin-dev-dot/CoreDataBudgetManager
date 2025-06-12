//
//  Locale+Extensions.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/30/25.
//

import Foundation

extension Locale{
    
    static var currencyCode : String {
        return Locale.current.currency?.identifier ?? "USD"
    }
}

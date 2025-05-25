//
//  String+Extension.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import Foundation

extension String {
    
    var isEmptyOrWhiteSpace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

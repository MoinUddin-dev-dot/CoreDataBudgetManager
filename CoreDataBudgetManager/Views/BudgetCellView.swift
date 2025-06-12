//
//  BudgetCellView.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import Foundation
import SwiftUI

struct BudgetCellView: View {
    
    let budget : Budget
    
    var body: some View {
        HStack {
            Text(budget.title ?? "")
            Spacer()
            Text(budget.limit , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}

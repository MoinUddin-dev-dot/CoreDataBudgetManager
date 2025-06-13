//
//  ExpenseEdit.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 6/13/25.
//

import SwiftUI

struct ExpenseEdit: View {
    
    @ObservedObject var expense: Expense
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let onUpdate: () -> Void
    
//    @State private var expenseTitle: String = ""
//    @State private var expenseAmount: Double?
//    @State private var expenseQuantity: Int = 1
//    @State private var expenseSelectedTags: Set<Tag> = []
    
    private func updateExpense() {
        
//        expense.title = expenseTitle
//        expense.amount = expenseAmount ?? 0
//        expense.quantity = Int16(expenseQuantity)
//        expense.tags = NSSet(array: Array(expenseSelectedTags))
        
        do{
            try context.save()
            onUpdate()
            
        } catch {
            print(error)
        }
        
    }
    
    var body: some View {
        Form{
//            TextField("Title", text: $expenseTitle)
//            TextField("Amount", value: $expenseAmount, format: .number)
//            TextField("Quantity", value: $expenseQuantity , format: .number)
//            TagsView(selectedTags: $expenseSelectedTags)
            TextField("Title", text: Binding(get: {
                expense.title ?? ""
                
            }, set: { newTitle in
                expense.title = newTitle
            }))
            TextField("Amount", value: $expense.amount, format: .number)
            TextField("Quantity", value: $expense.quantity , format: .number)
            TagsView(selectedTags: Binding(get: {
                Set(expense.tags?.compactMap{ $0 as? Tag} ?? [])
            }, set: { newValue in
                expense.tags = NSSet(array: Array(newValue))
            }))
        }
        .onAppear {
//            expenseTitle = expense.title ?? ""
//            expenseAmount = expense.amount
//            expenseQuantity = Int(expense.quantity)
//            
//            if let tags  = expense.tags {
//                expenseSelectedTags = Set(tags.compactMap{ $0 as? Tag})
//            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Update", action: updateExpense)
                
            }
        }
        .navigationTitle(expense.title ?? "")
        
    }
}

struct ExpenseEditContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View{
        NavigationStack{
            ExpenseEdit(expense: expenses[0], onUpdate: { })
        }
    }
}

#Preview {
    ExpenseEditContainer()
        .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
}

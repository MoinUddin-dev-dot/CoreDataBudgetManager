//
//  AddBudgetScreen.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import SwiftUI

struct AddBudgetScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var title: String = ""
    @State private var limit: Double?
    @State private var errorMessage: String = ""
    
    var isFormValid: Bool {
        !title.isEmptyOrWhiteSpace && limit != nil && Double(limit!) > 0
    }
    
    private func updateBudget(){
        do{
            let budget = Budget(context: context)
            budget.title = title
            budget.limit = limit ?? 0.0
            budget.dateCreated = Date()
            try context.save()
            errorMessage = ""
        } catch {
            errorMessage = "Duplicate entry not allowed , already exist"
        }
    }
    var body: some View {
        Form {
            Text("New Budget")
                .font(.headline)
            TextField("Title", text: $title)
                
            TextField("Limit" , value: $limit, format: .number)
                .keyboardType(.numberPad)
            Button {
                if !Budget.exist(context: context, title: title) {
                    updateBudget()
                } else {
                    errorMessage = "DUplicate entry not allowed , already exist"
                }
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
           
            if !errorMessage.isEmpty{
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    AddBudgetScreen()
        .environment(\.managedObjectContext, CoreDataProvider(inMemory: true).viewContext)
}

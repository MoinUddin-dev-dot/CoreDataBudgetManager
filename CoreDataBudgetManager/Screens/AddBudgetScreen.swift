//
//  AddBudgetScreen.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import SwiftUI

struct AddBudgetScreen: View {
    
    @State private var title: String = ""
    @State private var limit: Double?
    
    var isFormValid: Bool {
        
        !title.isEmptyOrWhiteSpace && limit != nil && Double(limit!) > 0
    }
    var body: some View {
        Form {
            Text("New Budget")
                .font(.headline)
            TextField("Title", text: $title)
                
            TextField("Limit" , value: $limit, format: .number)
                .keyboardType(.numberPad)
            Button {
                //
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
           

        }
    }
}

#Preview {
    AddBudgetScreen()
}

//
//  BudgetListScreen.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import SwiftUI

struct BudgetListScreen: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack{
            Text("Budget will be shown here...")
        }.navigationTitle("TodoItem")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Budget") {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                AddBudgetScreen()
                    .presentationDetents([.medium])
            }
    }
}

#Preview {
    NavigationStack{
        BudgetListScreen()
    }
}

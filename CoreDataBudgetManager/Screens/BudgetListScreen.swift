//
//  BudgetListScreen.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import SwiftUI

struct BudgetListScreen: View {
    
    
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State private var isPresented: Bool = false
    @State private var presentFilter = false
    
    var total: Double {
      budgets.reduce(0) { limit, budget in
          budget.limit + limit
        }
    }
    
    
    var body: some View {
        VStack{
            
            if budgets.isEmpty{
                ContentUnavailableView("No budgets available", systemImage: "list.clipboard")
            } else {
                List{
                    HStack{
                        Spacer()
                        Text("Total Budget:")
                        Text(total, format: .currency(code: Locale.currencyCode))
                        Spacer()
                        
                    }
                    .font(.headline)
                    ForEach(budgets) { budget in
                        NavigationLink {
                            BudgetDetailScreen(budget: budget)
                                

                        } label: {
                            BudgetCellView(budget: budget)
                        }
                        
                    }
                }
            }
        }
        .overlay(alignment: .bottom, content: {
            Button("Filter") {
                presentFilter = true
            }.buttonStyle(.borderedProminent)
                .tint(.gray)
        })
        .navigationTitle("TodoItem")
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
            .sheet(isPresented: $presentFilter) {
                NavigationStack{
                    FilterScreen()
                }
            }
    }
}

#Preview {
    NavigationStack{
        BudgetListScreen()
    }.environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
}



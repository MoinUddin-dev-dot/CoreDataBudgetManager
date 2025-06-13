//
//  ExpenseCellView.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/30/25.
//

import SwiftUI

struct ExpenseCellView: View {
    @ObservedObject var expense: Expense
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                
                Text("\(expense.title ?? "") - (\(expense.quantity))")
               
                Spacer()     
                Text(expense.total , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }.contentShape(Rectangle())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(Array(expense.tags as? Set<Tag> ?? [])){ tag in
                        Text(tag.name ?? "")
                            .font(.caption)
                            .padding(6)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    }
                }
            }
        }
    }
}

struct ExpenseCellViewContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View{
        ExpenseCellView(expense: expenses[0])
    }
}

#Preview {
    
    ExpenseCellViewContainer() .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
}

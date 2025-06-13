//
//  BudgetDetailScreen.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/27/25.
//

import SwiftUI
import CoreData

struct ExpenseEditConfig: Identifiable {
    var id = UUID()
    let expense: Expense
    let childContext: NSManagedObjectContext
    
    
    init?(expenseObjectID: NSManagedObjectID ,context: NSManagedObjectContext){
        self.childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.childContext.parent = context
        guard let existingExpense = self.childContext.object(with: expenseObjectID) as? Expense else { return nil }
        self.expense = existingExpense
    }
}

struct BudgetDetailScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTags: Set<Tag> = []
    @State private var errorMessage: String = ""
    
    let budget: Budget
    @State private var title: String = ""
    @State private var amount: Double?
    @State private var quantity: Int?
//    @State private var expenseEdit: Expense?
    @State private var expenseEditConfig : ExpenseEditConfig?
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    init(budget: Budget){
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
    }
    
    private func isFormValid() -> Bool {
        !title.isEmptyOrWhiteSpace && amount != nil && Double(amount!) > 0 && !selectedTags.isEmpty && quantity != nil && Int(quantity!) > 0
    }
       
    private func addExpense(){
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0.0
        expense.quantity = Int16(quantity ?? 0)
        expense.dateCreated = Date()
        expense.tags = NSSet(array: Array(selectedTags))
        
        budget.addToExpense(expense)
        
        do{
            try context.save()
            title = ""
            amount = nil
            quantity = nil
            selectedTags = []
            errorMessage = ""
        } catch {
            context.rollback()
            print(error)
        }
    }
    

    
    private func deleteExpense(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let expense = expenses[index]
            context.delete(expense)
        }
        
            do{
                try context.save()
            } catch {
                print(error)
            }
        
    }
    
    var body: some View {
        
        VStack{
            Text(budget.limit, format: .currency(code: Locale.currencyCode))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
        }
        Form{
            Section("New Expense"){
                TextField("Title", text: $title  )
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.numberPad)
                TextField("Quantity", value: $quantity, format: .number)
                    .keyboardType(.numberPad)
                
                TagsView(selectedTags: $selectedTags)

                Button {
                    if !Expense.exist(context: context, title: title){
                        addExpense()
                    } else{
                        errorMessage = "Expense item must be unique"
                    }
                    
                    
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid())
                
                Text(errorMessage)

            }
            Section("Expenses"){
                List{
                    VStack(spacing: 10){
                        HStack(alignment: .center){
                            Spacer()
                            Text("Total")
                           
                            Text(budget.spent, format: .currency(code: Locale.currencyCode ))
                            Spacer()
                            
                        }
                        HStack(alignment: .center){
                            Spacer()
                            Text("Remaining Amount")
                           
                            Text(budget.remaining, format: .currency(code: Locale.currencyCode))
                                .foregroundStyle(budget.remaining < 0 ? .red : .green)
                            Spacer()
                        }
                        
                    }
                    ForEach(expenses){ expense in
                        ExpenseCellView(expense: expense )
                            .onLongPressGesture {
//                                expenseEdit = expense
                                expenseEditConfig = ExpenseEditConfig(expenseObjectID: expense.objectID, context: context)
                            }
                    }
                    .onDelete(perform: deleteExpense)
                }
            }
        }
        .navigationTitle(budget.title ?? "")
        .sheet(item: $expenseEditConfig) { expenseConfig in
            NavigationStack{
                ExpenseEdit(expense: expenseConfig.expense){
                    do {
                        try context.save()
                        expenseEditConfig = nil
                    } catch {
                        print(error)
                    }
                }
                    .environment(\.managedObjectContext, expenseConfig.childContext)
            }
        }
    }
}

struct BudgetDetailScreenContainer : View {
    
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    
    var body: some View{
        BudgetDetailScreen(budget: budgets.first(where: {$0.title == "Groceries"})!)
    }
}

#Preview {
    NavigationStack{
        BudgetDetailScreenContainer()
            .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    }
   
}



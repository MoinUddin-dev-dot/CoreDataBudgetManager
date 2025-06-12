//
//  CoreDataProvider.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static var preview : CoreDataProvider = {
        let provider = CoreDataProvider(inMemory: true)
        let context = provider.viewContext
        
        let entertainment = Budget(context: context)
        entertainment.title = "Entertainment"
        entertainment.limit = 500
        entertainment.dateCreated = Date()
        
        let groceries = Budget(context: context)
        groceries.title = "Groceries"
        groceries.limit = 300
        groceries.dateCreated = Date()
        
        let milk = Expense(context: context)
        milk.title = "MILK"
        milk.amount = 5.4
        milk.dateCreated = Date()
        groceries.addToExpense(milk)
        
        let coookies = Expense(context: context)
        coookies.title = "Cookies"
        coookies.amount = 5.4
        coookies.dateCreated = Date()
        groceries.addToExpense(coookies)
        
        let foodItems = ["Burger", "Fries", "Cookies", "Noodles", "Popcorn", "Tacos", "Sushi" , "Pizza" , "Frozen Yogurt"]
        for foodItem in foodItems {
            let expense = Expense(context: context)
            expense.title = foodItem
            expense.amount = Double.random(in: 1...100)
            expense.dateCreated = Date()
            expense.budget = groceries
        }
        
        let commonTags = ["Food",
        "Dining", "Travel",
        "Utilities",
        "Entertainment",
        "Groceries", "Health", "Education",
        "Shopping", "Transportation"]
        for tagName in commonTags {
            let tag = Tag(context: context)
            tag.name = tagName
            if let tagName = tag.name, ["Food", "Groceries"].contains(tagName) {
                coookies.addToTags(tag)
            }
            
            if let tagName = tag.name , ["Health"].contains(tagName) {
                milk.addToTags(tag)
            }
        }
        
        do{
            try context.save()
        } catch{
            print(error)
        }
        
        return provider
    }()
    
    init(inMemory: Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "BudgetModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        
        persistentContainer.loadPersistentStores { _, error in
            if let error{
               fatalError("core data failed to initialize: \(error)")
            }
        }
        
    }
}





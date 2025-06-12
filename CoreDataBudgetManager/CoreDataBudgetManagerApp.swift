//
//  CoreDataBudgetManagerApp.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 5/26/25.
//

import SwiftUI

@main
struct CoreDataBudgetManagerApp: App {
    
    let provider: CoreDataProvider
    let tag: TagSeeder
    
    init() {
        provider = CoreDataProvider()
        tag  = TagSeeder(context: provider.viewContext)
    }
    
    var body: some Scene {
        
        WindowGroup {
            NavigationStack{
                BudgetListScreen()
                    
                    .onAppear {
                        
                        
                        let hasSeed = UserDefaults.standard.bool(forKey: "hasSeedData")
                        if !hasSeed {
                            let commonTags = ["Food",
                            "Dining", "Travel",
                            "Utilities",
                            "Entertainment",
                            "Groceries", "Health", "Education",
                            "Shopping", "Transportation"]
                            do {
                                
                                try tag.seed(commonTags)
                            } catch {
                                print(error)
                            }
                            UserDefaults.standard.set(true, forKey: "hasSeedData")
                            
                        }
                    }
            }
            .environment(\.managedObjectContext, provider.viewContext)
        }
    }
}

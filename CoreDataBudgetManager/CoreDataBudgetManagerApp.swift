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
    
    init() {
        provider = CoreDataProvider()
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, provider.viewContext)
        }
    }
}

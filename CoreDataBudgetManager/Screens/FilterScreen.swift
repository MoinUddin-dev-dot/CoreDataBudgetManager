//
//  FilterScreen.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 6/9/25.
//

import SwiftUI

struct FilterScreen: View {
    @FetchRequest( sortDescriptors: []) private var expenses: FetchedResults<Expense>
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTags: Set<Tag> = []
    @State private var filteredExpense: [Expense] = []
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    @State private var title: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedSortOption: SortOption? = nil
    @State private var selectedSortDirection: SortDirection  = .asc
    @State private var selectedFilterOption: filteroptions? = nil
    
    private enum SortDirection: CaseIterable, Identifiable {
        
        case asc
        case desc
        
        var id : SortDirection {
            return self
        }
        
        var title: String {
            switch self {
            case .asc:
                return "Ascending"
            case .desc:
                return "Descending"
            
            }
        }
    }
    
    
    
    private enum SortOption: String, CaseIterable, Identifiable {
        case title = "title"
        case date = "dateCreated"
        
        var id: SortOption {
            return self
        }
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .date:
                return "Date"
            }
        }
        
        var key : String {
            rawValue
        }
    }
    
    private enum filteroptions: Identifiable, Equatable {
        
        case none
        case dateCreated(startDate: Date, endDate: Date)
        case title(String)
        case byTag(Set<Tag>)
        case byPriceRange(startPrice: Double, endPrice: Double)
        
        var id : String {
            switch self {
            case .none :
                return "none"
            case .dateCreated:
                return "Date"
            case .byPriceRange:
                return "priceRange"
            case .byTag:
                return "byTag"
            case .title:
                return "title"
            }
        }
    }
    
    private func performFilter() {
        
        guard let selectedFilterOption = selectedFilterOption else { return }
        
        let request = Expense.fetchRequest()
        
        switch selectedFilterOption {
        case .none:
            request.predicate = NSPredicate(value: true)
        case .byTag(let tags):
            
            let selectedTagNames = tags.map {$0.name}
            request.predicate  = NSPredicate(format: "ANY tags.name IN %@", selectedTagNames)

        case .byPriceRange(let minPrice, let maxPrice):
            request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: minPrice), NSNumber(value: maxPrice))
        case .dateCreated(let startDate, let endDate):
            request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
            
        case .title(let title):
            request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
        
        
            
        }
        
        do {
            filteredExpense = try context.fetch(request)
        } catch{
            print(error)
        }
        
    }
    
    private func performSort() {
        
        guard let sortOption = selectedSortOption else { return }
        
        let request = Expense.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: sortOption.key, ascending: selectedSortDirection == .asc ? true : false )]
        
        do {
            filteredExpense = try context.fetch(request)
        } catch{
            print(error)
        }
        
    }
    
//    private func filterTags() {
//        if selectedTags.isEmpty {
//            return
//        }
//        let selectedTagNames = selectedTags.map {$0.name}
//        let request = Expense.fetchRequest()
//            request.predicate  = NSPredicate(format: "ANY tags.name IN %@", selectedTagNames)
//        
//        do {
//            filteredExpense =  try context.fetch(request)
//        } catch{
//            print(error)
//        }
//    }
//    
//    private func filterByPrice() {
//        let request = Expense.fetchRequest()
//        guard let startPrice = startPrice, let endPrice = endPrice else {
//            return
//        }
//        request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: startPrice), NSNumber(value: endPrice))
//        
//        do {
//            filteredExpense = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//    }
//    
//    private func filterByTitle() {
//        let request = Expense.fetchRequest()
//        request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
//        
//        do {
//            filteredExpense = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//    }
//    
//    private func filterByDate() {
//        let request = Expense.fetchRequest()
//        request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
//        
//        do {
//            filteredExpense = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//    }
    
    var body: some View {
        List{
            Section("Sort By"){
                Picker("Sort By Name", selection: $selectedSortOption) {
                    Text("Select").tag(Optional<SortOption>(nil))
                    ForEach(SortOption.allCases){ option in
                        Text(option.title)
                            .tag(Optional(option))
                    }
                }
                
                Picker("Sort By Direction", selection: $selectedSortDirection) {
                
                    ForEach(SortDirection.allCases){ option in
                        Text(option.title)
                            .tag(option)
                    }
                }
                
                Button("Sort"){
                    performSort()
                }.buttonStyle(.borderless)
            }
            
            Section("Filter by tags"){
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags){
                        if !selectedTags.isEmpty{
                            selectedFilterOption = .byTag(selectedTags)
                        }
                        
                    }
            }
            
            Section("Filter by Prices"){
                TextField("Start Price", value: $startPrice, format: .number)
                TextField("End Price", value: $endPrice, format: .number)
                Button("Search"){
                    guard let startPrice = startPrice, let endPrice = endPrice else { return }
                    selectedFilterOption = .byPriceRange(startPrice: startPrice, endPrice: endPrice)
                }
            }
            
            Section("Filter by title"){
                TextField("Title", text: $title)
                Button("Search"){
                    selectedFilterOption = .title(title)
                }
            }
            
            Section("Filter By Date"){
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                Button("Search"){
                    selectedFilterOption = .dateCreated(startDate: startDate, endDate: endDate)
                }
            }
            Section("Expenses"){
                ForEach(filteredExpense) { expense in
                    ExpenseCellView(expense: expense)
                }
            }
            
            HStack{
                Spacer()
                Button("Show All") {
                   selectedTags = []
                    selectedFilterOption = filteroptions.none
                }
                Spacer()
            }
        }
        .onChange(of: selectedFilterOption, {
            performFilter()
        })
        .padding()
            .navigationTitle("Filter")
    }
}

#Preview {
    NavigationStack{
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    }
}

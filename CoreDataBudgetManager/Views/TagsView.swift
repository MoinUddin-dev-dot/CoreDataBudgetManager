//
//  TagsView.swift
//  CoreDataBudgetManager
//
//  Created by Moin on 6/2/25.
//

import SwiftUI

struct TagsView: View {
    
    @FetchRequest(sortDescriptors: []) var tags: FetchedResults<Tag>

    @Binding var selectedTags: Set<Tag>
    
    var body: some View {
        ScrollView(.horizontal , showsIndicators: false) {
            HStack{
                ForEach(tags) { tag in
                    Text(tag.name ?? "")
                        .padding(10)
                        .background(selectedTags.contains(tag) ? .blue: .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .onTapGesture {
                            if selectedTags.contains(tag){
                                selectedTags.remove(tag)
                            }else {
                                selectedTags.insert(tag)
                            }
                        }
                }
            }
            .foregroundStyle(.white)
        }
    }
}

struct TagContainerView: View {
    @State private var selectedTags: Set<Tag> = []
    var body: some View {
        TagsView(selectedTags: $selectedTags)
            .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    }
}

#Preview {
    TagContainerView()
}

//
//  SearchFoodsView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 23. 6. 24.
//

import SwiftUI
import SwiftData

struct SearchFoodsView: View {
    @State private var searchText: String = ""
    @State var showCreateFoodView = false

    var body: some View {
        VStack(spacing: .zero) {
            // Search Bar with Barcode Button
            HStack {
                TextField("Search foods...", text: $searchText)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Button(action: {
                    // Action to scan barcode
                }) {
                    Image(systemName: "barcode.viewfinder")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)

            SearchFoodsResultsView()
        }
        .navigationBarTitle("Search Foods", displayMode: .inline)
        .sheet(isPresented: $showCreateFoodView) {
            CreateFoodView {
                showCreateFoodView = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showCreateFoodView = true
                } label: {
                    Text("Create food")
                }
            }
        }
    }
}

private struct SearchFoodsResultsView: View {
    var searchTerm: String
    
    @Query(sort: \Food.title, order: .forward) private var foods: [Food]
        
    init(searchTerm: String = "") {
        self.searchTerm = searchTerm
//        _foods = Query(filter: #Predicate<Food> { food in
//            food.title.contains(searchTerm)
//        }, sort: \Food.title, order: .forward)
    }
    
    var body: some View {
        // Food List or Empty State
        if foods.isEmpty {
            VStack {
                Spacer()
                Text("No foods found")
                    .foregroundColor(.gray)
                Spacer()
            }
        } else {
            List(foods) { food in
                Text(food.title)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    SearchFoodsView()
}

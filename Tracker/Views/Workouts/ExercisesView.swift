//
//  ManageWorkoutsView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 30. 6. 24.
//

import SwiftUI
import SwiftData

struct ManageWorkoutsView: View {
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            TextField("Search exercises...", text: $searchText)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom)
            
//            ExercisesSearchResultsView()
        }
//        .sheet(isPresented: $showSheet) {
//            AddFoodEntryView()
//        }
//        .navigationTitle("Exercises")
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                NavigationLink(destination: SearchFoodsView()) {
//                    Text("All Foods")
//                }
//            }
//            if !entries.isEmpty {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        showSheet = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//        }
    }
}

//struct ExercisesSearchResultsView: View {
//    
//    @Query var exercises: [Exercise]
//    
//    init(exercises: [Exercise]) {
//        self.exercises = exercises
//    }
//    
//    var body: some View {
//        if exercises.isEmpty {
//            Button {
//                showSheet = true
//            } label: {
//                VStack(spacing: Theme.spacing.s4) {
//                    Image(systemName: "plus.circle")
//                        .font(.largeTitle)
//                    Text("Tap to create your first food entry 🍜")
//                        .font(.title3)
//                        .fontWeight(.medium)
//                        .fontDesign(.rounded)
//                }
//                .padding()
//            }
//        } else {
//            List {
//                ForEach(entries) { item in
//                    Text(item.title)
//                }
//            }
//        }
//    }
//}

#Preview {
    ManageWorkoutsView()
}

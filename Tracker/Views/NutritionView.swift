//
//  NutritionView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 27. 6. 24.
//

import SwiftUI
import SwiftData

struct NutritionView: View {
    @Query private var entries: [FoodEntry]
    
    @State var showSheet = false
    
    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    Button {
                        showSheet = true
                    } label: {
                        VStack(spacing: Theme.spacing.s4) {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                            Text("Tap to log your first food entry 🍜")
                                .font(.title3)
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                        }
                        .padding()
                    }
                } else {
                    List {
                        ForEach(entries) { item in
                            Text(item.title)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                AddFoodEntryView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SearchFoodsView()) {
                        Text("All Foods")
                    }
                }
                if !entries.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NutritionView()
}

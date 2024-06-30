//
//  AddFoodEntryView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 27. 6. 24.
//

import SwiftUI

struct AddFoodEntryView: View {
    @State var foods: [FoodMeasurement] = []
    @State var showFoodPicker = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello world")
            }
            .onAppear {
                showFoodPicker = true
            }
            .navigationDestination(isPresented: $showFoodPicker) {
                SearchFoodsView()
            }
        }
        
    }
}

#Preview {
    AddFoodEntryView()
}

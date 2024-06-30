//
//  ContentView.swift
//  Budget
//
//  Created by Elisey Ozerov on 12. 6. 24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            MeasurementsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Measurements")
                }
            NutritionView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Nutrition")
                }

            WorkoutsView()
                .tabItem {
                    Image(systemName: "figure.highintensity.intervaltraining")
                    Text("Workouts")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            FoodEntry.self,
            FoodMeasurement.self,
            Food.self,
            FoodMetadata.self,
            NutrientMeasurement.self,
            Nutrition.self,
            BodyMeasurement.self
        ], inMemory: true)
}

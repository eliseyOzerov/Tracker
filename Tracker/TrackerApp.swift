//
//  BudgetApp.swift
//  Budget
//
//  Created by Elisey Ozerov on 12. 6. 24.
//

import SwiftUI
import SwiftData

let schema: [any PersistentModel.Type] = [
    FoodEntry.self,
    FoodMeasurement.self,
    Food.self,
    FoodMetadata.self,
    NutrientMeasurement.self,
    Nutrition.self,
]

@main
struct TrackerApp: App {
    
    init() {
        MeasurementValueTransformer.register()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: schema)
        }
    }
}

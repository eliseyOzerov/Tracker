//
//  NutritionFormView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 27. 6. 24.
//

import SwiftUI

struct NutritionFormView: View {
    @State var measurement: Measurement<UnitMass>
    
    // Protein
    @State var protein: Measurement<UnitMass>
    
    // Carbs
    @State var carbs: Measurement<UnitMass>
    @State var sugars: Measurement<UnitMass>
    @State var fiber: Measurement<UnitMass>
    
    // Fats
    @State var fats: Measurement<UnitMass>
    @State var cholesterol: Measurement<UnitMass>
    @State var saturatedFat: Measurement<UnitMass>
    @State var transFat: Measurement<UnitMass>
    @State var omega3: Measurement<UnitMass>
    @State var omega6: Measurement<UnitMass>
    
    // Vitamins
    @State var vitaminA: Measurement<UnitMass>
    @State var vitaminC: Measurement<UnitMass>
    @State var vitaminD: Measurement<UnitMass>
    @State var vitaminE: Measurement<UnitMass>
    @State var vitaminK: Measurement<UnitMass>
    @State var vitaminB1: Measurement<UnitMass>
    @State var vitaminB2: Measurement<UnitMass>
    @State var vitaminB3: Measurement<UnitMass>
    @State var vitaminB5: Measurement<UnitMass>
    @State var vitaminB6: Measurement<UnitMass>
    @State var vitaminB7: Measurement<UnitMass>
    @State var vitaminB9: Measurement<UnitMass>
    @State var vitaminB12: Measurement<UnitMass>
    
    // Minerals
    @State var calcium: Measurement<UnitMass>
    @State var iron: Measurement<UnitMass>
    @State var magnesium: Measurement<UnitMass>
    @State var phosphorus: Measurement<UnitMass>
    @State var potassium: Measurement<UnitMass>
    @State var sodium: Measurement<UnitMass>
    @State var salt: Measurement<UnitMass>
    @State var zinc: Measurement<UnitMass>
    @State var copper: Measurement<UnitMass>
    @State var manganese: Measurement<UnitMass>
    @State var selenium: Measurement<UnitMass>
    
    init(nutrition: Nutrition? = nil, onConfirm: @escaping (Nutrition) -> Void) {
        measurement = nutrition?.measurement ?? Measurement(value: 100, unit: UnitMass.grams)
        protein = nutrition?.get(.protein) ?? Measurement(value: -10, unit: UnitMass.grams)
        carbs = nutrition?.get(.carbs) ?? Measurement(value: -30, unit: UnitMass.grams)
        sugars = nutrition?.get(.sugars) ?? Measurement(value: -12, unit: UnitMass.grams)
        fiber = nutrition?.get(.fiber) ?? Measurement(value: -4, unit: UnitMass.grams)
        fats = nutrition?.get(.fats) ?? Measurement(value: -9, unit: UnitMass.grams)
        cholesterol = nutrition?.get(.cholesterol) ?? Measurement(value: -30, unit: UnitMass.milligrams)
        saturatedFat = nutrition?.get(.saturatedFat) ?? Measurement(value: -4, unit: UnitMass.grams)
        transFat = nutrition?.get(.transFat) ?? Measurement(value: -0.5, unit: UnitMass.grams)
        omega3 = nutrition?.get(.omega3) ?? Measurement(value: -0.25, unit: UnitMass.grams)
        omega6 = nutrition?.get(.omega6) ?? Measurement(value: -1, unit: UnitMass.grams)
        vitaminA = nutrition?.get(.vitaminA) ?? Measurement(value: -900, unit: UnitMass.micrograms)
        vitaminC = nutrition?.get(.vitaminC) ?? Measurement(value: -90, unit: UnitMass.milligrams)
        vitaminD = nutrition?.get(.vitaminD) ?? Measurement(value: -20, unit: UnitMass.micrograms)
        vitaminE = nutrition?.get(.vitaminE) ?? Measurement(value: -15, unit: UnitMass.milligrams)
        vitaminK = nutrition?.get(.vitaminK) ?? Measurement(value: -120, unit: UnitMass.micrograms)
        vitaminB1 = nutrition?.get(.vitaminB1) ?? Measurement(value: -1.2, unit: UnitMass.milligrams)
        vitaminB2 = nutrition?.get(.vitaminB2) ?? Measurement(value: -1.3, unit: UnitMass.milligrams)
        vitaminB3 = nutrition?.get(.vitaminB3) ?? Measurement(value: -16, unit: UnitMass.milligrams)
        vitaminB5 = nutrition?.get(.vitaminB5) ?? Measurement(value: -5, unit: UnitMass.milligrams)
        vitaminB6 = nutrition?.get(.vitaminB6) ?? Measurement(value: -1.7, unit: UnitMass.milligrams)
        vitaminB7 = nutrition?.get(.vitaminB7) ?? Measurement(value: -30, unit: UnitMass.micrograms)
        vitaminB9 = nutrition?.get(.vitaminB9) ?? Measurement(value: -400, unit: UnitMass.micrograms)
        vitaminB12 = nutrition?.get(.vitaminB12) ?? Measurement(value: -2.4, unit: UnitMass.micrograms)
        calcium = nutrition?.get(.calcium) ?? Measurement(value: -130, unit: UnitMass.milligrams)
        iron = nutrition?.get(.iron) ?? Measurement(value: -1.8, unit: UnitMass.milligrams)
        magnesium = nutrition?.get(.magnesium) ?? Measurement(value: -40, unit: UnitMass.milligrams)
        phosphorus = nutrition?.get(.phosphorus) ?? Measurement(value: -140, unit: UnitMass.milligrams)
        potassium = nutrition?.get(.potassium) ?? Measurement(value: -330, unit: UnitMass.milligrams)
        sodium = nutrition?.get(.sodium) ?? Measurement(value: -200, unit: UnitMass.milligrams)
        salt = nutrition?.get(.salt) ?? Measurement(value: -0.5, unit: UnitMass.grams)
        zinc = nutrition?.get(.zinc) ?? Measurement(value: -1.1, unit: UnitMass.milligrams)
        copper = nutrition?.get(.copper) ?? Measurement(value: -90, unit: UnitMass.micrograms)
        manganese = nutrition?.get(.manganese) ?? Measurement(value: -0.3, unit: UnitMass.milligrams)
        selenium = nutrition?.get(.selenium) ?? Measurement(value: -5, unit: UnitMass.micrograms)
        self.onConfirm = onConfirm
    }
    
    var nutrition: Nutrition {
        Nutrition(
            measurement: measurement,
            nutrients: [
                NutrientMeasurement(.protein, protein),
                NutrientMeasurement(.carbs, carbs),
                NutrientMeasurement(.sugars, sugars),
                NutrientMeasurement(.fiber, fiber),
                NutrientMeasurement(.fats, fats),
                NutrientMeasurement(.cholesterol, cholesterol),
                NutrientMeasurement(.saturatedFat, saturatedFat),
                NutrientMeasurement(.transFat, transFat),
                NutrientMeasurement(.omega3, omega3),
                NutrientMeasurement(.omega6, omega6),
                NutrientMeasurement(.vitaminA, vitaminA),
                NutrientMeasurement(.vitaminC, vitaminC),
                NutrientMeasurement(.vitaminD, vitaminD),
                NutrientMeasurement(.vitaminE, vitaminE),
                NutrientMeasurement(.vitaminK, vitaminK),
                NutrientMeasurement(.vitaminB1, vitaminB1),
                NutrientMeasurement(.vitaminB2, vitaminB2),
                NutrientMeasurement(.vitaminB3, vitaminB3),
                NutrientMeasurement(.vitaminB5, vitaminB5),
                NutrientMeasurement(.vitaminB6, vitaminB6),
                NutrientMeasurement(.vitaminB7, vitaminB7),
                NutrientMeasurement(.vitaminB9, vitaminB9),
                NutrientMeasurement(.vitaminB12, vitaminB12),
                NutrientMeasurement(.calcium, calcium),
                NutrientMeasurement(.iron, iron),
                NutrientMeasurement(.magnesium, magnesium),
                NutrientMeasurement(.phosphorus, phosphorus),
                NutrientMeasurement(.potassium, potassium),
                NutrientMeasurement(.sodium, sodium),
                NutrientMeasurement(.salt, salt),
                NutrientMeasurement(.zinc, zinc),
                NutrientMeasurement(.copper, copper),
                NutrientMeasurement(.manganese, manganese),
                NutrientMeasurement(.selenium, selenium),
            ].filter { $0.measurement.value >= 0 }
        )
    }
    
    var onConfirm: (Nutrition) -> Void
    
    var body: some View {
        Form {
            Section("Measure") {
                MeasurementInputRow(label: "Portion", measurement: $measurement)
            }
            
            Section("Protein") {
                MeasurementInputRow(label: "Protein", measurement: $protein)
            }
            
            Section("Carbs") {
                MeasurementInputRow(label: "Carbs", measurement: $carbs)
                MeasurementInputRow(label: "Sugars", measurement: $sugars)
                MeasurementInputRow(label: "Fiber", measurement: $fiber)
            }
            
            Section("Fats") {
                MeasurementInputRow(label: "Fats", measurement: $fats)
                MeasurementInputRow(label: "Cholesterol", measurement: $cholesterol)
                MeasurementInputRow(label: "Saturated Fat", measurement: $saturatedFat)
                MeasurementInputRow(label: "Trans Fat", measurement: $transFat)
                MeasurementInputRow(label: "Omega 3", measurement: $omega3)
                MeasurementInputRow(label: "Omega 6", measurement: $omega6)
            }
            
            Section("Vitamins") {
                MeasurementInputRow(label: "Vitamin A", measurement: $vitaminA)
                MeasurementInputRow(label: "Vitamin C", measurement: $vitaminC)
                MeasurementInputRow(label: "Vitamin D", measurement: $vitaminD)
                MeasurementInputRow(label: "Vitamin E", measurement: $vitaminE)
                MeasurementInputRow(label: "Vitamin K", measurement: $vitaminK)
                MeasurementInputRow(label: "Thiamine (B1)", measurement: $vitaminB1)
                MeasurementInputRow(label: "Riboflavin (B2)", measurement: $vitaminB2)
                MeasurementInputRow(label: "Niacin (B3)", measurement: $vitaminB3)
                MeasurementInputRow(label: "Pantothenic Acid (B5)", measurement: $vitaminB5)
                MeasurementInputRow(label: "Pyridoxine (B6)", measurement: $vitaminB6)
                MeasurementInputRow(label: "Biotin (B7)", measurement: $vitaminB7)
                MeasurementInputRow(label: "Folate (B9)", measurement: $vitaminB9)
                MeasurementInputRow(label: "Cobalamin (B12)", measurement: $vitaminB12)
            }
            
            Section("Minerals") {
                MeasurementInputRow(label: "Calcium", measurement: $calcium)
                MeasurementInputRow(label: "Iron", measurement: $iron)
                MeasurementInputRow(label: "Magnesium", measurement: $magnesium)
                MeasurementInputRow(label: "Phosphorus", measurement: $phosphorus)
                MeasurementInputRow(label: "Potassium", measurement: $potassium)
                MeasurementInputRow(label: "Sodium", measurement: $sodium)
                MeasurementInputRow(label: "Zinc", measurement: $zinc)
                MeasurementInputRow(label: "Copper", measurement: $copper)
                MeasurementInputRow(label: "Manganese", measurement: $manganese)
                MeasurementInputRow(label: "Selenium", measurement: $selenium)
            }
        }
        .navigationTitle("Nutrition")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onConfirm(nutrition)
                } label: {
                    Text("Confirm")
                }
            }
        }
    }
}

struct MeasurementInputRow<T>: View where T: Dimension {
    @State var label: String
    @Binding var measurement: Measurement<T>
    var unit: Binding<Unit>? = nil
    
    @State var size: CGSize = .zero
    @State private var textValue: String = ""
    
    var body: some View {
        LabeledContent(label) {
            HStack {
                TextField(abs(measurement.value).formatted(.number), text: $textValue)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: size.width * 0.25)
                    .keyboardType(.decimalPad)
                    .onAppear {
                        textValue = measurement.value > 0 ? measurement.value.formatted(.number) : ""
                    }
                    .onChange(of: textValue) { old, new in
                        if let value = Double(new) {
                            measurement.value = value
                        }
                    }
                if let unit = unit {
                    UnitPicker(unit: unit)
                } else {
                    Text(measurement.unit.symbol)
                }
            }
        }
        .background {
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        size = geometry.size
                    }
            }
        }
    }
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

#Preview {
    NutritionFormView { _ in }
}

//
//  Food.swift
//  Tracker
//
//  Created by Elisey Ozerov on 23. 6. 24.
//

import Foundation
import SwiftData

@Model
class FoodEntry: Identifiable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let title: String
    let foods: [FoodMeasurement]
    
    init(id: UUID = UUID(), createdAt: Date = Date(), updatedAt: Date = Date(), title: String, foods: [FoodMeasurement]) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.title = title
        self.foods = foods
    }
}

@Model
class FoodMeasurement: Identifiable {
    let id: UUID
    let food: Food
    
    @Attribute(.transformable(by: MeasurementValueTransformer.self))
    let measurement: Measurement<Dimension>
    
    init(id: UUID = UUID(), food: Food, measurement: Measurement<Dimension>) {
        self.id = id
        self.food = food
        self.measurement = measurement
    }
}

@Model
class Food: Identifiable {
    let id: UUID
    let title: String
    let recipe: String?
    let ingredients: [FoodMeasurement]
    let metadata: FoodMetadata?
    let nutritionData: Nutrition?
    var images: [String]
    let createdAt: Date
    let updatedAt: Date
    
    var nutrition: Nutrition {
        nutritionData ?? ingredients.reduce(into: Nutrition()) { res, el in
            res = res + el.food.nutrition
        }
    }
    
    init(id: UUID = UUID(), title: String, recipe: String? = nil, ingredients: [FoodMeasurement] = [], metadata: FoodMetadata? = nil, nutrition: Nutrition? = nil, images: [String] = [], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.recipe = recipe
        self.ingredients = ingredients
        self.metadata = metadata
        self.nutritionData = nutrition
        self.images = images
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
class FoodMetadata: Identifiable {
    let id: UUID
    
    let brand: String?
    let brandedName: String?
    let barcode: String?
    
    init(id: UUID = UUID(), brand: String? = nil, brandedName: String? = nil, barcode: String? = nil) {
        self.id = id
        self.brand = brand
        self.brandedName = brandedName
        self.barcode = barcode
    }
}

enum Nutrient: String, Codable {
    case protein
    case carbs
    case fats
    case fiber
    case salt
    case sugars
    case cholesterol
    case saturatedFat
    case transFat
    case omega3
    case omega6
    case vitaminA
    case vitaminC
    case vitaminD
    case vitaminE
    case vitaminK
    case vitaminB1
    case vitaminB2
    case vitaminB3
    case vitaminB5
    case vitaminB6
    case vitaminB7
    case vitaminB9
    case vitaminB12
    case calcium
    case iron
    case magnesium
    case phosphorus
    case potassium
    case sodium
    case zinc
    case copper
    case manganese
    case selenium
}

@Model
class NutrientMeasurement: Identifiable {
    let id: UUID
    let nutrient: Nutrient
    
    @Attribute(.transformable(by: MeasurementValueTransformer.self))
    let measurement: Measurement<UnitMass>
    
    init(id: UUID = UUID(), _ nutrient: Nutrient, _ measurement: Measurement<UnitMass>) {
        self.id = id
        self.nutrient = nutrient
        self.measurement = measurement
    }
}

@Model
class Nutrition: Identifiable {
    let id: UUID
    
    @Attribute(.transformable(by: MeasurementValueTransformer.self))
    var measurement: Measurement<UnitMass>
    
    var nutrients: [NutrientMeasurement]
    
    init(id: UUID = UUID(), measurement: Measurement<UnitMass> = Measurement(value: 100, unit: .grams), nutrients: [NutrientMeasurement] = []) {
        self.id = id
        self.measurement = measurement
        self.nutrients = nutrients
    }
    
    func get(_ nutrient: Nutrient) -> Measurement<UnitMass>? {
        return nutrients.first { $0.nutrient == nutrient }?.measurement
    }
    
    func set(_ nutrient: Nutrient, _ measurement: Measurement<UnitMass>?) {
        guard let measurement = measurement else { return }
        if let index = nutrients.firstIndex(where: { $0.nutrient == nutrient }) {
            nutrients.remove(at: index)
        }
        nutrients.append(NutrientMeasurement(nutrient, measurement))
    }
}

extension Nutrition {
    static func * (_ left: Nutrition, _ right: Double) -> Nutrition {
        return Nutrition(
            measurement: left.measurement * right,
            nutrients: left.nutrients.map { NutrientMeasurement(id: $0.id, $0.nutrient, $0.measurement * right) }
        )
    }
    
    static func * (_ left: Double, _ right: Nutrition) -> Nutrition {
        return right * left
    }
    
    static func / (_ left: Nutrition, _ right: Double) -> Nutrition {
        return Nutrition(
            measurement: left.measurement / right,
            nutrients: left.nutrients.map { NutrientMeasurement(id: $0.id, $0.nutrient, $0.measurement / right) }
        )
    }
    
    static func / (_ left: Double, _ right: Nutrition) -> Nutrition {
        return right / left
    }
    
    static func + (_ left: Nutrition, _ right: Nutrition) -> Nutrition {
        var res: [NutrientMeasurement] = []
        
        for item in left.nutrients + right.nutrients {
            if let index = res.firstIndex(where:{ $0.nutrient == item.nutrient }) {
                res[index] = NutrientMeasurement(res[index].nutrient, res[index].measurement + item.measurement)
            } else {
                res.append(item)
            }
        }
        return Nutrition(measurement: left.measurement + right.measurement, nutrients: res)
    }
    
    static func - (_ left: Nutrition, _ right: Nutrition) -> Nutrition {
        var res: [NutrientMeasurement] = left.nutrients
        
        for item in right.nutrients {
            if let index = res.firstIndex(where:{ $0.nutrient == item.nutrient }) {
                res[index] = NutrientMeasurement(res[index].nutrient, res[index].measurement - item.measurement)
            }
        }
        return Nutrition(measurement: left.measurement - right.measurement, nutrients: res)
    }
}

func op<T: Dimension>(_ left: Measurement<T>?, _ right: Measurement<T>?, with operator: (Measurement<T>, Measurement<T>) -> Measurement<T>) -> Measurement<T>? {
    return switch (left, right) {
        case let (l?, r?): `operator`(l, r)
        case let (l?, nil): l
        case let (nil, r?): r
        default: nil
    }
}



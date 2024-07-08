//
//  Workout.swift
//  Tracker
//
//  Created by Elisey Ozerov on 30. 6. 24.
//

import Foundation
import SwiftData

@Model
class Workout: Identifiable {
    let id: UUID
    let title: String
    let start: Date?
    let end: Date?
    let exercises: [WorkoutExercise]
    
    init(id: UUID = UUID(), title: String? = nil, start: Date? = nil, end: Date? = nil, exercises: [WorkoutExercise] = []) {
        self.id = id
        self.title = title ?? "\(Date().partOfDay.rawValue.capitalized) workout"
        self.start = start
        self.end = end
        self.exercises = exercises
    }
}

@Model
class WorkoutExercise: Identifiable {
    let id: UUID
    let start: Date?
    var end: Date?
    let exercise: Exercise
    
    init(id: UUID = UUID(), start: Date? = nil, end: Date? = nil, exercise: Exercise) {
        self.id = id
        self.start = start
        self.end = end
        self.exercise = exercise
    }
}

@Model
class Tempo: Identifiable {
    let id: UUID
    
    var eccentric: Int // Time in seconds for the lowering phase
    var pauseEccentric: Int // Time in seconds for the pause at the bottom
    var concentric: Int // Time in seconds for the lifting phase
    var pauseConcentric: Int // Time in seconds for the pause at the top

    init(_ id: UUID = UUID(), eccentric: Int, pauseEccentric: Int, concentric: Int, pauseConcentric: Int) {
        self.eccentric = eccentric
        self.pauseEccentric = pauseEccentric
        self.concentric = concentric
        self.pauseConcentric = pauseConcentric
    }

    // Function to represent the tempo as a string
    func tempoString() -> String {
        return "\(eccentric)-\(pauseEccentric)-\(concentric)-\(pauseConcentric)"
    }
}

/// Weight exercises
/// Cardio exercises
/// Bodyweight exercises
/// HIIT exercises
/// Flexibility exercises
/// Plyometric exercises
/// Stability exercises
/// Circuit training
/// Functional training

@Model
class Exercise: Identifiable {
    let id: UUID
    let title: String
    let muscles: [Muscle]
    /// If this is true, inputs will appear for both sides of the body, left and right
    let unilateral: Bool
    let specs: [EquipmentUsage]
    let instructions: String
    
    // Muscles field can be inferred them from equipmentusage
    // by taking different start and end body positions.
    // E.g. with bicep curls, we have the elbows extended at the start of the move, then we apply flexion to the elbow joint
    // The articulation type together with a joint value                          are linked to a muscle, since muscles produce the articulations
    // each muscle can have its its articulations for different joints
    
    // ADDED Articulations param for Muscle, fill that out
    // to get exercises for a muscle, take the muscle's articulations, then find all the exercises which have equipmentUsage where the start and end positions for the joints are different
    // to get the muscles used on in a joint articulation, search all muscles which have an articulation for this joint and the given articulation
    
    init(
        id: UUID = UUID(),
        title: String,
        muscles: [Muscle] = [],
        unilateral: Bool = false,
        equipment: [Equipment] = [],
        instructions: String = ""
    ) {
        self.id = id
        self.title = title
        self.muscles = muscles
        self.unilateral = unilateral
        self.specs = specs
        self.instructions = instructions
    }
}

class UnitCount: Dimension {
    static let count = UnitCount(symbol: "count")
}
class UnitValue: Dimension {
    static let incline = UnitValue(symbol: "incline")
    static let setting = UnitValue(symbol: "setting")
    static let stairs = UnitValue(symbol: "stairs")
    static let resistance = UnitValue(symbol: "resistance")
}

//@Model
//class Equipment: Identifiable {
//    @Attribute(.unique) let id: String
////    let label: String
////    let category: EquipmentCategory
////    
////    @Attribute(.transformable(by: MeasurementValueTransformer.self))
////    let weight: Measurement<UnitMass>?
////    
////    @Attribute(.transformable(by: MeasurementValueTransformer.self))
////    let speed: Measurement<UnitSpeed>?
////    
////    @Attribute(.transformable(by: MeasurementValueTransformer.self))
////    let distance: Measurement<UnitLength>?
////    
////    @Attribute(.transformable(by: MeasurementValueTransformer.self))
////    let setting: Measurement<UnitValue>?
////    
////    let reps: Int?
//    
//    init(
//        id: UUID = UUID(),
////        _ label: String,
////        category: EquipmentCategory = .weight,
////        weight: Measurement<UnitMass>? = nil,
////        speed: Measurement<UnitSpeed>? = nil,
////        distance: Measurement<UnitLength>? = nil,
////        setting: Measurement<UnitValue>? = nil,
////        reps: Int? = nil
//    ) {
//        self.id = id
////        self.label = label
////        self.category = category
////        self.distance = distance
////        self.weight = weight
////        self.speed = speed
////        self.setting = setting
////        self.reps = reps
//    }
//    
//    // Weight
//    static let dumbbells = Equipment("dumbbells", weight: Measurement(value: -20, unit: .kilograms), reps: 10)
//    static let barbell = Equipment("barbell", weight: Measurement(value: -20, unit: .kilograms), reps: 10)
//    static let plates = Equipment("plates", weight: Measurement(value: -20, unit: .kilograms), reps: 10)
//    static let machine = Equipment("machine", weight: Measurement(value: -20, unit: .kilograms), reps: 10)
//    static let cables = Equipment("cables", weight: Measurement(value: -20, unit: .kilograms), reps: 10)
//    static let kettlebell = Equipment("kettlebell", weight: Measurement(value: -20, unit: .kilograms), reps: 10)
//    static let smithMachine = Equipment("smithMachine", weight: Measurement(value: -20, unit: .kilograms), reps: 10)
//    static let wearableWeight = Equipment("wearableWeight", weight: Measurement(value: -20, unit: .kilograms))
//
//    // Cardio
//    static let track = Equipment("track", category: .cardio, speed: Measurement(value: -20, unit: .kilometersPerHour))
//    static let treadmill = Equipment("treadmill", category: .cardio, speed: Measurement(value: -20, unit: .kilometersPerHour), setting: Measurement(value: 3.5, unit: .incline))
//    static let elliptical = Equipment("elliptical", category: .cardio, setting: Measurement(value: 15, unit: .setting))
//    static let stairsMachine = Equipment("stairsMachine", category: .cardio, setting: Measurement(value: 15, unit: .setting))
//    static let stairs = Equipment("stairsMachine", category: .cardio, setting: Measurement(value: 150, unit: .stairs))
//    static let stationaryBike = Equipment("stationaryBike", category: .cardio, setting: Measurement(value: 15, unit: .setting))
//    static let bycicle = Equipment("bycicle", category: .cardio, speed: Measurement(value: 15, unit: .kilometersPerHour))
//    static let rower = Equipment("rower", category: .cardio)
//    static let stepper = Equipment("stepper", category: .cardio)
//    
//    // Other
//    static let bodyweight = Equipment("none", category: .other, weight: Measurement(value: -80, unit: .kilograms), reps: 10)
//    static let bags = Equipment("bags", category: .other, weight: Measurement(value: -20, unit: .kilograms))
//    static let bands = Equipment("bands", category: .other, setting: Measurement(value: 3, unit: .resistance))
//    static let bars = Equipment("bars", category: .other, weight: Measurement(value: -20, unit: .kilograms), reps: 10)
//    static let medicineBall = Equipment("medicineBall", category: .other, weight: Measurement(value: -10, unit: .kilograms), reps: 10)
//    static let rollers = Equipment("rollers", category: .other)
//    static let bench = Equipment("bench", category: .other, setting: Measurement(value: 35, unit: .incline))
//}



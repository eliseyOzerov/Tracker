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
    let reps: Int?
    let resistance: Measurement<Unit>?
    
    init(id: UUID = UUID(), start: Date? = nil, end: Date? = nil, exercise: Exercise, reps: Int? = nil, resistance: Measurement<Unit>? = nil) {
        self.id = id
        self.start = start
        self.end = end
        self.exercise = exercise
        self.reps = reps
        self.resistance = resistance
    }
}

@Model
class Exercise: Identifiable {
    let id: UUID
    let title: String
    let groups: [MuscleGroup]
    let equipment: [Equipment]
    let instructions: String
    
    init(id: UUID = UUID(), title: String, groups: [MuscleGroup] = [], equipment: [Equipment] = [], instructions: String = "") {
        self.id = id
        self.title = title
        self.groups = groups
        self.equipment = equipment
        self.instructions = instructions
    }
}

enum Equipment: String, Codable, CaseIterable, Identifiable {
    var id : String { self.rawValue }
    
    case bars
    case floor
    case bags
    case bands
    case medicineBall
    case foamRollers
    
    case dumbbells
    case barbell
    case machine
    case cables
    case kettlebells
    case smithMachine
    
    case treadmill
    case elliptical
    case stairs
    case bycicle
    case rower
    case stepper
}


enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    var id : String { self.rawValue }
    
    case upperChest
    case middleChest
    case lowerChest
    
    case upperBack
    case middleBack
    case lowerBack
    case lats
    
    case frontDelts
    case sideDelts
    case rearDelts
    
    case bicepsLongHead
    case bicepsShortHead
    case tricepsLongHead
    case tricepsLateralHead
    case tricepsMedialHead
    case brachialis
    case forearms
    
    case upperAbs
    case lowerAbs
    case obliques
    case transverseAbdominis
    
    case quadsRectusFemoris
    case quadsVastusLateralis
    case quadsVastusMedialis
    case quadsVastusIntermedius
    case hamstringsBicepsFemoris
    case hamstringsSemitendinosus
    case hamstringsSemimembranosus
    case glutesMaximus
    case glutesMedius
    case glutesMinimus
    case calvesGastrocnemius
    case calvesSoleus
    case innerThighAdductorLongus
    case innerThighAdductorBrevis
    case innerThighAdductorMagnus
    
    case frontNeck
    case backNeck
    
    case hipFlexors
    case hipExtensors
}

struct MuscleGroupCategory {
    var groups: [MuscleGroup]
    
    static let neck = MuscleGroupCategory(groups: [.frontNeck, .backNeck])
    static let chest = MuscleGroupCategory(groups: [.upperChest, .middleChest, .lowerChest])
    static let back = MuscleGroupCategory(groups: [.upperBack, .middleBack, .lowerBack, .lats])
    static let shoulders = MuscleGroupCategory(groups: [.frontDelts, .sideDelts, .rearDelts])
    static let arms = MuscleGroupCategory(
        groups: [
            .bicepsLongHead,
            .bicepsShortHead,
            .tricepsLongHead,
            .tricepsLateralHead,
            .tricepsMedialHead,
            .brachialis,
            .forearms
        ]
    )
    static let core = MuscleGroupCategory(groups: [
        .upperAbs,
        .lowerAbs,
        .obliques,
        .transverseAbdominis,
    ])
    static let hips = MuscleGroupCategory(groups: [.hipFlexors, .hipExtensors])
    static let legs = MuscleGroupCategory(groups: [
        .quadsRectusFemoris,
        .quadsVastusLateralis,
        .quadsVastusMedialis,
        .quadsVastusIntermedius,
        .hamstringsBicepsFemoris,
        .hamstringsSemitendinosus,
        .hamstringsSemimembranosus,
        .glutesMaximus,
        .glutesMedius,
        .glutesMinimus,
        .calvesGastrocnemius,
        .calvesSoleus,
        .innerThighAdductorLongus,
        .innerThighAdductorBrevis,
        .innerThighAdductorMagnus,
    ])
    
    static let values = [neck, chest, back, shoulders, arms, core, hips, legs]
    
    static func forGroup(_ group: MuscleGroup) -> MuscleGroupCategory {
        return values.first { $0.groups.contains(group) }!
    }
}

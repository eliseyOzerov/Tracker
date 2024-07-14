//
//  Workout.swift
//  Tracker
//
//  Created by Elisey Ozerov on 30. 6. 24.
//

import Foundation
import SwiftData
import HealthKit

enum ExerciseType {
    case weight
    case cardio
    case bodyweight
    case hiit
    case functional
    case movement
}

enum Movement {
    case neckCurls
    case neckExtension
    case neckRotation
    case shoulderPress
    case shoulderRaise
    case lateralShoulderRaise
    case shoulderAdduction
    case rearDeltFly
    case shoulderExtension
    case shoulderInternalRotation
    case shoulderExternalRotation
    case chestPress
    
}

@Model
class Workout {
    let title: String
    let start: Date?
    let end: Date?
    
    init(title: String? = nil, start: Date? = nil, end: Date? = nil) {
        self.title = title ?? "\(Date().partOfDay.rawValue.capitalized) workout"
        self.start = start
        self.end = end
    }
}

@Model
class Tempo {
    var eccentric: Int // Time in seconds for the lowering phase
    var pauseEccentric: Int // Time in seconds for the pause at the bottom
    var concentric: Int // Time in seconds for the lifting phase
    var pauseConcentric: Int // Time in seconds for the pause at the top

    init(eccentric: Int, pauseEccentric: Int, concentric: Int, pauseConcentric: Int) {
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

@Model
class BodyPosition {
    let joints: [Joint]
    
    init(joints: [Joint]) {
        self.joints = joints
    }
}

protocol Exercise: PersistentModel {
    var title: String { get }
    var equipment: [Equipment] { get }
    var instructions: String { get }
}

protocol ExerciseRecord: PersistentModel {
    var exercise: any Exercise { get }
    var start: Date { get }
    var end: Date { get }
}

@Model
class WeightExerciseRecord: ExerciseRecord {
    let start: Date
    let end: Date
    let exercise: any Exercise
    
    @Attribute(.transformable(by: MeasurementValueTransformer.self))
    let weight: Measurement<UnitMass>
    let reps: Int
    
    init(start: Date, end: Date, exercise: any Exercise, weight: Measurement<UnitMass>, reps: Int) {
        self.start = start
        self.end = end
        self.exercise = exercise
        self.weight = weight
        self.reps = reps
    }
}

@Model
class CardioExerciseRecord: ExerciseRecord {
    let start: Date
    let end: Date
    let exercise: any Exercise
    
    let distance: Measurement<UnitLength>?
    let speed: Measurement<UnitSpeed>?
    let elevation: Measurement<UnitLength>?
    let resistance: Double?
    
    init(start: Date, end: Date, exercise: any Exercise, distance: Measurement<UnitLength>?, speed: Measurement<UnitSpeed>?, elevation: Measurement<UnitLength>?, resistance: Double?) {
        self.start = start
        self.end = end
        self.exercise = exercise
        self.distance = distance
        self.speed = speed
        self.elevation = elevation
        self.resistance = resistance
    }
}

@Model
class WeightExercise: Exercise {
    // MARK: - Exercise
    let title: String
    let equipment: [Equipment]
    let instructions: String
    
    // MARK: - WeightExercise
    let movement: Movement
    let position: BodyPosition?
    let muscles: [MuscleInvolvement]
    let tempo: Tempo?
    
    init(title: String, equipment: [Equipment], instructions: String, movement: Movement, position: BodyPosition? = nil, muscles: [MuscleInvolvement], tempo: Tempo? = nil) {
        self.title = title
        self.equipment = equipment
        self.instructions = instructions
        self.movement = movement
        self.position = position
        self.muscles = muscles
        self.tempo = tempo
    }
}

@Model
class CardioExercise: Exercise {
    // MARK: - Exercise
    let title: String
    let equipment: [Equipment]
    let instructions: String
    
    init(title: String, equipment: [Equipment], instructions: String) {
        self.title = title
        self.equipment = equipment
        self.instructions = instructions
    }
}

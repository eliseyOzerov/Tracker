//
//  Anatomy.swift
//  Tracker
//
//  Created by Elisey Ozerov on 4. 7. 24.
//

import Foundation
import SwiftData

enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case neck
    case shoulders
    case upperArms
    case forearms
    case back
    case chest
    case core
    case hips
    case legs
}

enum JointType: String {
    case neck
    case shoulder
    case scapula
    case upperSpine
    case lowerSpine
    case elbow
    case wrist
    case hip
    case pelvis
    case tailbone
    case knee
    case ankle
}

enum ArticulationType: String {
    case protraction
    case retraction
    case depression
    case elevation
    case rotationUpward
    case rotationDownward
    case internalRotation
    case externalRotation
    case rotationLeft
    case rotationRight
    case flexion
    case extensionn
    case lateralFlexionLeft
    case lateralFlexionRight
    case transverseAdduction
    case transverseFlexion
    case transverseAbduction
    case transverseExtension
    case adduction
    case abduction
}

enum MuscleRole: String, Codable, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case agonist
    case antagonist
    case target
    case synergist
    case stabilizer
    case dynamicStabilizer
    case antagonistStabilizer
    
    var involvement: Double {
        switch self {
            case .agonist: 1.0
            case .antagonist: 0
            case .target: 1.0
            case .synergist: 0.7
            case .stabilizer: 0.5
            case .dynamicStabilizer: 0.6
            case .antagonistStabilizer: 0.3
        }
    }
}

enum ForceOrigin {
    case active
    case passive
}

enum GripWidth {
    case close
    case narrow
    case shoulder
    case normal
    case wide
}

@Model
class ArticulationAxis: Identifiable {
    @Attribute(.unique) let id: String
    
    let negative: ArticulationType
    let positive: ArticulationType
    
    private init(negative: ArticulationType, positive: ArticulationType) {
        self.negative = negative
        self.positive = positive
        self.id = "\(negative.rawValue).\(positive.rawValue)"
    }
    
    init(type: ArticulationType) {
        self.positive = ArticulationAxis.values.first { $0.negative == type || $0.positive == type }!.positive
        self.negative = ArticulationAxis.values.first { $0.negative == type || $0.positive == type }!.negative
    }
    
    static let retractionProtraction = ArticulationAxis(negative: .retraction, positive: .protraction)
    static let rotation = ArticulationAxis(negative: .rotationLeft, positive: .rotationRight)
    static let verticalRotation = ArticulationAxis(negative: .rotationDownward, positive: .rotationUpward)
    static let internalExternalRotation = ArticulationAxis(negative: .internalRotation, positive: .externalRotation)
    static let depressionElevation = ArticulationAxis(negative: .depression, positive: .elevation)
    static let lateralFlexion = ArticulationAxis(negative: .lateralFlexionLeft, positive: .lateralFlexionRight)
    static let flexionExtension = ArticulationAxis(negative: .flexion, positive: .extensionn)
    static let transverseFlexionExtension = ArticulationAxis(negative: .transverseFlexion, positive: .transverseExtension)
    static let abductionAdduction = ArticulationAxis(negative: .adduction, positive: .abduction)
    static let transverseAbductionAdduction = ArticulationAxis(negative: .transverseAdduction, positive: .transverseAbduction)
    
    static var values: [ArticulationAxis] {
        [
            retractionProtraction,
            rotation,
            verticalRotation,
            internalExternalRotation,
            depressionElevation,
            lateralFlexion,
            flexionExtension,
            transverseFlexionExtension,
            abductionAdduction,
            transverseAbductionAdduction
        ]
    }
    
    func type(for amount: Double) -> ArticulationType {
        amount < 0 ? negative : positive
    }
}

@Model
class Joint: Identifiable {
    let id: UUID

    let type: JointType
    var side: Side?
    var articulations: [Articulation]
    
    init(_ id: UUID = UUID(), type: JointType, side: Side? = nil, articulations: [Articulation] = []) {
        self.id = id
        self.type = type
        self.side = side
        self.articulations = articulations
    }
    
//    func getMuscles(for type: ArticulationType) -> [Muscle] {
//        Muscle.values.filter { $0.articulations.contains { $0.joint == self.type && $0.articulation == type }}
//    }
    
    func get(_ type: ArticulationAxis) -> Double? {
        return articulations.first { $0.axis == type }?.value
    }
    
    func set(_ type: ArticulationAxis, _ value: Double?) {
        guard let value = value else { return }
        if let index = articulations.firstIndex(where: { $0.axis == type }) {
            articulations.remove(at: index)
        }
        articulations.append(Articulation(axis: type, value: value))
    }
    
    static let neck = Joint(type: .neck, articulations: [
        Articulation(axis: .flexionExtension),
        Articulation(axis: .lateralFlexion),
        Articulation(axis: .rotation),
    ])
    static let upperSpine = Joint(type: .upperSpine, articulations: [
        Articulation(axis: .flexionExtension),
        Articulation(axis: .lateralFlexion),
        Articulation(axis: .rotation),
    ])
    static let lowerSpine = Joint(type: .lowerSpine, articulations: [
        Articulation(axis: .flexionExtension),
        Articulation(axis: .lateralFlexion),
        Articulation(axis: .rotation),
    ])
    static let scapula = Joint(type: .scapula, articulations: [
        Articulation(axis: .retractionProtraction),
        Articulation(axis: .depressionElevation),
        Articulation(axis: .verticalRotation)
    ])
    static let shoulder = Joint(type: .shoulder, articulations: [
        Articulation(axis: .flexionExtension),
        Articulation(axis: .abductionAdduction),
        Articulation(axis: .transverseAbductionAdduction),
        Articulation(axis: .internalExternalRotation)
    ])
    static let elbow = Joint(type: .elbow, articulations: [
        Articulation(axis: .flexionExtension)
    ])
    static let wrist = Joint(type: .wrist, articulations: [
        Articulation(axis: .internalExternalRotation),
        Articulation(axis: .flexionExtension),
        Articulation(axis: .abductionAdduction)
    ])
    static let hip = Joint(type: .hip, articulations: [
        Articulation(axis: .flexionExtension),
        Articulation(axis: .abductionAdduction),
        Articulation(axis: .transverseAbductionAdduction),
        Articulation(axis: .internalExternalRotation)
    ])
    static let knee = Joint(type: .hip, articulations: [
        Articulation(axis: .flexionExtension),
        Articulation(axis: .internalExternalRotation)
    ])
    static let ankle = Joint(type: .hip, articulations: [
        Articulation(axis: .flexionExtension)
    ])
}

@Model
class Articulation: Identifiable {
    let id: UUID
    
    let axis: ArticulationAxis
    let value: Double
    
    /// Values from -1 to 1
    init(_ id: UUID = UUID(), axis: ArticulationAxis, value: Double = 0) {
        assert(value > -1 && value < 1)
        self.id = id
        self.axis = axis
        self.value = value
    }
    
    /// Value from 0 to 1
    init(_ id: UUID = UUID(), type: ArticulationType, value: Double = 0) {
        assert(value > 0 && value < 1)
        self.id = id
        self.axis = ArticulationAxis(type: type)
        self.value = value
    }
    
    var type: ArticulationType {
        axis.type(for: value)
    }
}

@Model
class Muscle: Identifiable {
    var id: String { code }
    @Attribute(.unique) let code: String
    
    let group: MuscleGroup
    let areas: [Side]
    
    init(_ code: String, group: MuscleGroup, areas: [Side] = []) {
        self.code = code
        self.group = group
        self.areas = areas
    }
    
    static let neckFlexors = Muscle("neckFlexors", group: .neck)
    static let neckExtensors = Muscle("neckExtensors", group: .neck)
    static let deltoid = Muscle("deltoid", group: .shoulders, areas: [.front, .middle, .back])
    static let triceps = Muscle("triceps", group: .upperArms, areas: [.inner, .middle, .outer])
    static let biceps = Muscle("biceps", group: .upperArms, areas: [.inner, .outer])
    static let brachialis = Muscle("brachialis", group: .upperArms)
    static let brachioradialis = Muscle("brachioradialis", group: .forearms)
    static let forearmFlexors = Muscle("forearmFlexors", group: .forearms)
    static let forearmExtensors = Muscle("forearmExtensors", group: .forearms)
    static let lats = Muscle("lats", group: .back, areas: [.upper, .lower])
    static let traps = Muscle("traps", group: .back, areas: [.upper, .middle, .lower])
    static let teres = Muscle("teres", group: .back) // maybe upper back together with rhomboids and lower traps
    static let erectorSpinae = Muscle("erectorSpinae", group: .back)
    static let pecs = Muscle("pecs", group: .chest, areas: [.upper, .lower])
    static let abs = Muscle("abs", group: .core, areas: [.upper, .lower])
    static let obliques = Muscle("obliques", group: .core, areas: [.inner, .outer])
    static let glutes = Muscle("glutes", group: .legs)
    static let hipAbductors = Muscle("hipAbductors", group: .legs)
    static let hipAdductors = Muscle("hipAdductors", group: .legs)
    static let hipFlexors = Muscle("hipFlexors", group: .legs)
    static let quads = Muscle("quads", group: .legs, areas: [.inner, .middle, .outer])
    static let hamstrings = Muscle("hamstrings", group: .legs)
    static let calves = Muscle("calves", group: .legs)
    static let ankleFlexors = Muscle("calves", group: .legs)
    
    static var values: [Muscle] {
        [
            .neckFlexors,
            .neckExtensors,
            .deltoid,
            .triceps,
            .biceps,
            .brachialis,
            .brachioradialis,
            .forearmFlexors,
            .forearmExtensors,
            .lats,
            .traps,
            .teres,
            .erectorSpinae,
            .pecs,
            .abs,
            .obliques,
            .glutes,
            .hipAbductors,
            .hipAdductors,
            .hipFlexors,
            .quads,
            .hamstrings,
            .calves,
            .ankleFlexors
        ]
    }
    
    var groups: [MuscleGroup: [Muscle]] {
        [
            .neck: [.neckFlexors, .neckExtensors],
            .shoulders: [.deltoid],
            .upperArms: [.biceps, .triceps, .brachialis],
            .forearms: [.brachioradialis, .forearmFlexors, .forearmExtensors],
            .back: [.lats, .traps, .teres],
            .chest: [.pecs],
            .core: [.abs, .obliques, .erectorSpinae],
            .hips: [.glutes, .hipFlexors, .hipAbductors, .hipAdductors],
            .legs: [.quads, .hamstrings, .calves, .ankleFlexors],
        ]
    }
}

@Model
class MuscleInvolvement: Identifiable {
    let id: UUID
    let muscle: Muscle
    let area: Side?
    let role: MuscleRole
    
    init(_ id: UUID = UUID(), muscle: Muscle, area: Side? = nil, role: MuscleRole) {
        self.id = id
        self.muscle = muscle
        self.area = area
        self.role = role
    }
}

@Model
class JointArticulation: Identifiable {
    let id: UUID
    
    let type: JointArticulationType
    let amount: Double
    
    init(_ id: UUID = UUID(), type: JointArticulationType, amount: Double) {
        self.id = id
        self.type = type
        self.amount = amount
    }
}

@Model
class JointArticulationType: Identifiable {
    @Attribute(.unique) var id: String { "\(joint.rawValue).\(articulation.rawValue)" }
    
    let joint: JointType
    let articulation: ArticulationType
    let muscles: [MuscleInvolvement]
    
    private init(joint: JointType, articulation: ArticulationType, muscles: [MuscleInvolvement] = []) {
        self.joint = joint
        self.articulation = articulation
        self.muscles = muscles
    }
    
    static let neckFlexion = JointArticulationType(joint: .neck, articulation: .flexion, muscles: [MuscleInvolvement(muscle: .neckFlexors)])
    static let neckExtension = JointArticulationType(joint: .neck, articulation: .extensionn, muscles: [MuscleInvolvement(muscle: .neckExtensors)])
    
    /// Fill this out, these will make up JointArticulations, which in turn will be in Movements. These Movements will be in every Exercise. Exercises might also have a starting BodyPosition, to help specify how the user should start the Exercise.
    /// The reasoning behind this is as follows: Here we define all the muscles for each joint articulation. This way we can connect the exercises to specific muscles and their groups or joints. The JointArticulationTypes will come from a json which
    /// will be loaded into CoreData on app launch. Before that, Muscles will be loaded into CoreData as well. The Movements and BodyPositions will be specified per exercise, but we can also list some basic ones, like the bicep curls or shoulder press.
    /// This, together with a list of Equipment and optional Tempo will make up an Exercise. Equipment could also have the editable properties for each set, like only the weight of dumbbells, but not the bench incline for the Incline Dumbbell Press.
    /// Each WorkoutExercise will have a start and end timestamps, so the time in between the end of one exercise/set and start time of the next one will be considered as rest.
}

@Model
class BodyPosition: Identifiable {
    let id: UUID
    let joints: [Joint]
    
    init(_ id: UUID = UUID(), joints: [Joint] = []) {
        self.id = id
        self.joints = joints
    }
    
    func move(_ move: Movement) -> BodyPosition {
        let m = Movement(articulations: [
            JointArticulation(type: .neckExtension, amount: 1),
            JointArticulation(type: .neckExtension, amount: 1),
        ])
        let joints = joints
    }
}

@Model
class Movement: Identifiable {
    let id: UUID
    let title: String
    let muscles: [MuscleInvolvement]
    
    init(_ id: UUID = UUID(), title: String, muscles: [MuscleInvolvement] = []) {
        self.id = id
        self.title = title
        self.muscles = muscles
    }
    
    static let squat = Movement(
        title: "Shoulder press",
        muscles: [
            
        ]
    )
}

/// We're creating an exercise.
/// This exercise has a title, instruction notes and specs
/// The exercise specs are EquipmentUsage, which is a base class for WeightEquipmentUsage, CardioEquipmentUsage etc
/// WeightEquipmentUsage has equipment, startPosition, movement and tempo. We need this to know exactly what body parts to move during the exercise and for how long each rep
/// If the exercise is unilateral, we have inputs for both sides of the body



/// - Neck flexion
/// - Neck ex

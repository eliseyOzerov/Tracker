//
//  Equipment.swift
//  Tracker
//
//  Created by Elisey Ozerov on 3. 7. 24.
//

import Foundation
import SwiftData

enum MachineType: String, Codable, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case cable
    case plate
}

enum EquipmentCategory: String, Codable, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case weights
    case barbell
    case cables
    case attachment
    case machine
    case cardio
    case stationary
    case functional
}

enum EquipmentPropertyType {
    case weight
    case startPosition
    case seatPosition
    case incline
    case resistance
    case speed
    case size
    case width
    case height
    case machineType
}

@Model
class EquipmentUsage: Identifiable {
    let id: UUID
    
    let equipment: Equipment
    let startPosition: BodyPosition?
    let movement: Movement?
    let tempo: Tempo?
    
    init(
        id: UUID = UUID(),
        equipment: Equipment,
        startPosition: BodyPosition? = nil,
        movement: Movement? = nil,
        tempo: Tempo? = nil
    ) {
        self.id = id
        self.equipment = equipment
        self.startPosition = startPosition
        self.movement = movement
        self.tempo = tempo
    }
}

@Model
class Equipment: Identifiable {
    let id: UUID
    let title: String
    let category: EquipmentCategory
    let properties: [EquipmentProperty]
    
    init(_ id: UUID = UUID(), title: String, image: String? = nil, category: EquipmentCategory, properties: [EquipmentProperty] = []) {
        self.id = id
        self.title = title
        self.category = category
        self.properties = properties
    }
}

@Model
class EquipmentProperty: Identifiable {
    let id: UUID
    let type: EquipmentPropertyType
    let value: Double
    let editable: Bool
    
    init(id: UUID = UUID(), type: EquipmentPropertyType, value: Double, editable: Bool = true) {
        self.id = id
        self.type = type
        self.value = value
        self.editable = editable
    }
}

@Model
class WeightEquipment: Equipment {
    let weight: Measurement<UnitMass>
    
    init(weight: Measurement<UnitMass> = Measurement(value: -20, unit: .kilograms)) {
        self.weight = weight
    }
}

@Model
class Barbell: WeightEquipment {
    let gripWidth: GripWidth
    
    private init(gripWidth: GripWidth = .shoulder, weight: Measurement<UnitMass>) {
        self.gripWidth = gripWidth
        super.init(weight: weight)
    }
    
    func with(grip: GripWidth) -> Barbell {
        Barbell(gripWidth: grip, weight: self.weight)
    }
    
    
    static let log = Barbell(weight: Measurement(value: 50, unit: .kilograms))
    static let trapBar = Barbell(weight: Measurement(value: 25, unit: .kilograms))
    static let standard = Barbell(weight: Measurement(value: 20, unit: .kilograms))
    static let olympicWomen = Barbell(weight: Measurement(value: 15, unit: .kilograms))
    static let ezCurlBar = Barbell(weight: Measurement(value: 10, unit: .kilograms))
}

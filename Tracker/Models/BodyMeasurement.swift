//
//  BodyMeasurement.swift
//  Tracker
//
//  Created by Elisey Ozerov on 29. 6. 24.
//

import Foundation
import SwiftData

enum Bodypart: String, Codable, CaseIterable, Identifiable {
    case weight
    case neck
    case shoulders
    case chest
    case biceps
    case forearms
    case stomach
    case waist
    case hips
    case thighs
    case calves
    
    var id : String { self.rawValue }
}

enum Bodyside: String, Codable {
    case left
    case right
}

@Model
class BodyMeasurement: Identifiable {
    var id: UUID
    var timestamp: Date
    var bodypart: Bodypart
    var bodyside: Bodyside?
    
    @Attribute(.transformable(by: MeasurementValueTransformer.self))
    var measurement: Measurement<Dimension>
    
    @Transient
    var animate = false
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        bodypart: Bodypart,
        bodyside: Bodyside? = nil,
        measurement: Measurement<Dimension>
    ) {
        self.id = id
        self.timestamp = timestamp
        self.bodypart = bodypart
        self.bodyside = bodyside
        self.measurement = measurement
    }
}

//
//  MeasurementExtension.swift
//  Tracker
//
//  Created by Elisey Ozerov on 29. 6. 24.
//

import Foundation

extension Measurement {
    var toString: String {
        "\(value.formatted(.number)) \(unit.symbol)"
    }
}

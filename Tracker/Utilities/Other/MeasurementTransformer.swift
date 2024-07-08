//
//  MeasurementTransformer.swift
//  Tracker
//
//  Created by Elisey Ozerov on 26. 6. 24.
//

import Foundation

class MeasurementValueTransformer: ValueTransformer {    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSMeasurement.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let measurement = value as? Measurement<Dimension> else { return nil }
        return try? JSONEncoder().encode(measurement)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? JSONDecoder().decode(Measurement<Dimension>.self, from: data)
    }
}

extension MeasurementValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: MeasurementValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = MeasurementValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

let unitMassDict: [String: UnitMass] = Dictionary(uniqueKeysWithValues: [
    UnitMass.kilograms,
    UnitMass.grams,
    UnitMass.decigrams,
    UnitMass.centigrams,
    UnitMass.milligrams,
    UnitMass.micrograms,
    UnitMass.nanograms,
    UnitMass.picograms,
    UnitMass.ounces,
    UnitMass.pounds,
    UnitMass.stones,
    UnitMass.metricTons,
    UnitMass.shortTons,
    UnitMass.carats,
    UnitMass.ouncesTroy,
    UnitMass.slugs
].map { ($0.symbol, $0) })

let unitVolumeDict: [String: UnitVolume] = Dictionary(uniqueKeysWithValues: [
    UnitVolume.megaliters,
    UnitVolume.kiloliters,
    UnitVolume.liters,
    UnitVolume.deciliters,
    UnitVolume.centiliters,
    UnitVolume.milliliters,
    UnitVolume.cubicKilometers,
    UnitVolume.cubicMeters,
    UnitVolume.cubicDecimeters,
    UnitVolume.cubicCentimeters,
    UnitVolume.cubicMillimeters,
    UnitVolume.cubicInches,
    UnitVolume.cubicFeet,
    UnitVolume.cubicYards,
    UnitVolume.cubicMiles,
    UnitVolume.acreFeet,
    UnitVolume.bushels,
    UnitVolume.teaspoons,
    UnitVolume.tablespoons,
    UnitVolume.fluidOunces,
    UnitVolume.cups,
    UnitVolume.pints,
    UnitVolume.quarts,
    UnitVolume.gallons,
    UnitVolume.imperialTeaspoons,
    UnitVolume.imperialTablespoons,
    UnitVolume.imperialFluidOunces,
    UnitVolume.imperialPints,
    UnitVolume.imperialQuarts,
    UnitVolume.imperialGallons,
    UnitVolume.metricCups,
].map { ($0.symbol, $0) })

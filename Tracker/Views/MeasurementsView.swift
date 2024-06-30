//
//  MeasurementsView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 27. 6. 24.
//

import SwiftUI
import SwiftData
import Charts

struct MeasurementsView: View {
//    @Query(sort: \BodyMeasurement.timestamp, order: .reverse) var measurements: [BodyMeasurement]

    var measurements: [BodyMeasurement] = (0...10).map { i in
        BodyMeasurement(
            timestamp: Date().add(component: .day, value: -10 * i),
            bodypart: .chest,
            measurement: Measurement(value: Double.random(in: 80..<90), unit: UnitLength.centimeters as Dimension)
        )
    }
    
    func domain(bp: Bodypart) -> ScaleDomain {
        let m = measurements.filter { $0.bodypart == bp }.map { $0.measurement }
        let min = m.min()?.value ?? 80
        let max = m.max()?.value ?? 100
        return Int(min-30)...Int(max+30)
    }
    
    @State var selectedCard: Bodypart? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(Bodypart.allCases, id: \.self) { bp in
                    Button {
                        selectedCard = bp
                    } label: {
                        MeasurementCard(
                            bodypart: bp,
                            measurement: BodyMeasurement(bodypart: bp, measurement: Measurement(value: 100, unit: UnitLength.centimeters as Dimension))
                        ) {
                            Chart(measurements.filter { $0.bodypart == bp }) {
                                LineMark(
                                    x: .value("Month", $0.timestamp),
                                    y: .value("Value", $0.measurement.value)
                                )
                                .interpolationMethod(.catmullRom)
                            }
                            .chartYScale(domain: .automatic(includesZero: false))
                            .chartYAxis(.hidden)
                            .chartXAxis(.hidden)
                            .frame(maxWidth: 100, maxHeight: 50)
                        }
                    }

                }
                    .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationDestination(item: $selectedCard) { card in
                BodypartDetailView(bodypart: card)
            }
        }
    }
}

struct MeasurementCard: View {
    var bodypart: Bodypart
    var measurement: BodyMeasurement?
    
    var chart: any View
    
    init(bodypart: Bodypart, measurement: BodyMeasurement? = nil, @ViewBuilder chart: @escaping () -> some View) {
        self.bodypart = bodypart
        self.measurement = measurement
        self.chart = chart()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(bodypart.rawValue.uppercased())
                        .font(.footnote)
                        .foregroundStyle(.blue)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                Spacer()
                if let measurement = measurement {
                    HStack(alignment: .firstTextBaseline, spacing: .zero) {
                        Text(measurement.measurement.value.formatted(.number))
                            .font(.title2)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.black)
                        Text(" \(measurement.measurement.unit.symbol)")
                            .font(.body)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                } else {
                    HStack {
                        Text("Add data")
                            .font(.title2)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(Color(uiColor: .tertiaryLabel))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(Color(uiColor: .quaternaryLabel))
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                if let measurement = measurement {
                    HStack(spacing: 5) {
                        Text(measurement.timestamp.formatted(date: .abbreviated, time: .shortened))
                            .font(.footnote)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .fontDesign(.rounded)
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                    Spacer()
                    AnyView(chart)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    MeasurementsView()
}

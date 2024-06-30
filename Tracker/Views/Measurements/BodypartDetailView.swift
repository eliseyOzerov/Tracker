//
//  MeasurementEditorView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 30. 6. 24.
//

import SwiftUI
import SwiftData
import Charts

enum Period: String, CaseIterable {
    case threeMonths
    case sixMonths
    case oneYear
}

struct BodypartDetailView: View {
    var bodypart: Bodypart
    
    @Query var measurements: [BodyMeasurement]
    @State var emptyData: [BodyMeasurement] = []
    
    @State var date = Date()
    @State var measurement: Measurement<Dimension> = Measurement(value: -100, unit: UnitLength.centimeters as Dimension)
    
    @State var showInput = false
    @State var period: Period = .threeMonths
    
    var unit: Dimension {
        if bodypart == .weight {
            UnitMass.kilograms
        } else {
            UnitLength.centimeters
        }
    }
    
    init(bodypart: Bodypart) {
        self.bodypart = bodypart
        _measurements = Query(filter: #Predicate<BodyMeasurement> { measurement in
            measurement.bodypart == bodypart
        }, sort: \.timestamp, order: .reverse)
        self.measurement = Measurement(value: measurements.last?.measurement.value ?? -100, unit: unit)
    }
    
    func generateData(for range: Period) -> [BodyMeasurement] {
        var res = [BodyMeasurement]()
        for i in 0..<12 {
            var date = Date()
            switch range {
            case .threeMonths:
                date = date.add(component: .weekOfYear, value: -i)
            case .sixMonths:
                date = date.add(component: .weekOfYear, value: -2*i)
            case .oneYear:
                date = date.add(component: .month, value: -i)
            }
            let value = Double.random(in: 0...100)
            res.append(BodyMeasurement(timestamp: date, bodypart: bodypart, measurement: Measurement(value: value, unit: unit)))
        }
        return res
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                Picker(selection: $period) {
                    Text("3 months")
                        .tag(Period.threeMonths)
                    Text("6 months")
                        .tag(Period.sixMonths)
                    Text("12 months")
                        .tag(Period.oneYear)
                } label: {
                    EmptyView()
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last measurement")
                            .foregroundStyle(.tertiary)
                            .font(.callout)
                        if !measurements.isEmpty {
                            HStack {
                                Text(measurements.last!.measurement.value.formatted(.number))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                                Text(measurements.last!.measurement.unit.symbol)
                                    .foregroundStyle(.secondary)
                                    .fontDesign(.rounded)
                            }
                        } else {
                            Text("Not available")
                                .foregroundStyle(.secondary)
                                .font(.title2)
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    Spacer()
                }

                Chart {
                    if measurements.isEmpty {
                        ForEach(emptyData) {
                            LineMark(
                                x: .value("Timestamp", $0.timestamp, unit: .weekOfYear),
                                y: .value(bodypart.rawValue.capitalized, $0.measurement.value)
                            )
                            .foregroundStyle(.clear)
                        }
                        .symbol(BasicChartSymbolShape.circle)
                    } else {
                        ForEach(measurements, id: \.id) { m in
                            LineMark(x: .value("Timestamp", m.timestamp), y: .value(bodypart.rawValue.capitalized, m.measurement.value))
                                .foregroundStyle(.red)
                                .interpolationMethod(.catmullRom)
                        }
                    }
                }
                .overlay {
                    if measurements.isEmpty {
                        Text("No data entered yet")
                            .foregroundStyle(.secondary)
                            .font(.callout)
                            .fontWeight(.medium)
                    }
                }
                .frame(height: 250)
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                HStack {
                    Text("All entries")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.top)
                
                Group {
                    if false {
                        Text("No data yet")
                            .frame(height: 150)
                            .foregroundStyle(.tertiary)
                    } else {
                        LazyVStack(spacing: .zero) {
                            ForEach(emptyData) { m in
                                HStack {
                                    Text(m.timestamp.formatted(date: .abbreviated, time: .shortened))
                                    Spacer()
                                    HStack {
                                        Text("\(Int(ceil(m.measurement.value)))")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .fontDesign(.rounded)
                                        Text(m.measurement.unit.symbol)
                                            .foregroundStyle(.secondary)
                                            .fontDesign(.rounded)
                                    }
                                }
                                .padding()
                                Divider()
                                    .padding(.leading)
                                    .frame(height: 1)

                            }
                        }
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                    }
                }
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(bodypart.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.bouncy(duration: 0.5)) {
                        showInput = true
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(showInput)
            }
        }
        .overlay {
            if showInput {
                MeasurementInput(bodypart: bodypart, date: $date, measurement: $measurement, show: $showInput)
                    .containerShape(Rectangle())
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            Debouncer(delay: 0.2).call {
                withAnimation(.bouncy(duration: 0.5)) {
                    showInput = measurements.isEmpty
                }
            }
            self.emptyData = generateData(for: period)
        }
    }
}

struct MeasurementInput: View {
    @State var bodypart: Bodypart
    
    @Binding var date: Date
    @Binding var measurement: Measurement<Dimension>
    
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                ZStack {
                    HStack {
                        Button("Cancel") {
                            withAnimation(.bouncy(duration: 0.5)) {
                                show = false
                            }
                        }
                        Spacer()
                        Button("Add") {
                            // add measurement
                            resignFirstResponder()
                            withAnimation(.bouncy(duration: 0.5)) {
                                show = false
                            }
                        }
                        .disabled(measurement.value < 0)
                    }
                    Text("New measurement")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                Spacer().frame(height: 24)
                VStack {
                    DatePicker(
                        "Date & time",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .onTapGesture(count: 99) {} // hack to make sure the date picker opens, caused by the onTapGesture below
                    Divider()
                        .padding(.leading)
                    MeasurementInputRow(label: bodypart.rawValue.capitalized, measurement: $measurement)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .onTapGesture {
                        resignFirstResponder()
                    }
                }
                .background(Color(uiColor: .secondarySystemGroupedBackground))
            }
            .padding(.top)
            .padding(.bottom, 12)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding()
            .shadow(color: .black.opacity(0.05), radius: 15, y: 5)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            resignFirstResponder()
        }
    }
}

#Preview {
    BodypartDetailView(bodypart: .chest)
}

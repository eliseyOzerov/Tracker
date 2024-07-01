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
    @Environment(\.modelContext) var modelContext
    
    var bodypart: Bodypart
    
    @Query var measurements: [BodyMeasurement]
    @State var emptyData: [BodyMeasurement] = []
    
    @State var date = Date()
    @State var measurement: Measurement<Dimension> = Measurement(value: -100, unit: UnitLength.centimeters)
    
    @State var showInput = false
    @State var period: Period = .threeMonths
    @State var didClose = false
    @State var didOpen = false
    @State var isAtBottom = false
    
    var unit: Dimension {
        if bodypart == .weight {
            UnitMass.kilograms
        } else {
            UnitLength.centimeters
        }
    }
    
    init(bodypart: Bodypart) {
        self.bodypart = bodypart
//        _measurements = Query(filter: #Predicate<BodyMeasurement> { measurement in
//            measurement.bodypart.id == bodypart.id
//        }, sort: \.timestamp, order: .reverse)
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
    
    func setShowInput(_ visible: Bool) {
        withAnimation(.bouncy(duration: 0.5)) {
            showInput = visible
        }
    }
    
    @State var offset: CGPoint = .zero
    @State var recentChanges: [Double] = []
    
    var body: some View {
        OffsetObservingScrollView(offset: $offset) {
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
                .padding(.vertical)

                Chart {
                    ForEach(Array(emptyData.enumerated()), id: \.offset) {
                        LineMark(
                            x: .value("Timestamp", $1.timestamp, unit: .weekOfYear),
                            y: .value(bodypart.rawValue.capitalized, $1.measurement.value)
                        )
                        .foregroundStyle(.red)
                    }
                    .interpolationMethod(.catmullRom)
                    .symbol(BasicChartSymbolShape.circle)
                }
                .onChange(of: period) { old, new in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        emptyData = measurements.isEmpty ? generateData(for: new) : []
                    }
                }
                .overlay {
                    if (emptyData).isEmpty {
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
                                
                                if m != emptyData.last {
                                    Divider()
                                        .padding(.leading)
                                        .frame(height: 1)
                                }
                            }
                        }
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                    }
                }
                
                Rectangle()
                    .frame(width: 1, height: 1)
                    .foregroundStyle(.clear)
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onChange(of: offset) { new, old in
                                    isAtBottom = proxy.frame(in: .global).maxY < UIScreen.main.bounds.height
                                }
                        }
                    }
            }
            .background {
                Rectangle()
                    .foregroundStyle(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        resignFirstResponder()
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
                        didClose = false
                        didOpen = true
                    }
                    setShowInput(true)
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(showInput && !didClose)
            }
        }
        .overlay {
            if showInput && !didClose || didOpen {
                MeasurementInput(bodypart: bodypart, date: $date, measurement: $measurement, didClose: $didClose, didOpen: $didOpen)
                    .containerShape(Rectangle())
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            Debouncer(delay: 0.2).call {
                setShowInput(measurements.isEmpty)
                withAnimation(.easeInOut(duration: 0.5)) {
                    emptyData = measurements.isEmpty ? generateData(for: period) : []
                }
            }
        }
        .onChange(of: offset) { old, new in
            if recentChanges.count > 5 { recentChanges.removeFirst() }
            recentChanges.append(old.y - new.y)
            let directionConfirmed = recentChanges.allSatisfy { $0.sign == recentChanges.first!.sign }
            let magnitudeConfirmed = recentChanges.reduce(into: 0) { $0 += $1 } > 10
            let isOffsetNegative = new.y.sign == .minus
            let isScrollDown = abs(old.y) > abs(new.y)
            if !magnitudeConfirmed && !directionConfirmed { return }
            let show = (isOffsetNegative || isScrollDown) && (!isAtBottom || didOpen)
            setShowInput(show)
        }
    }
}

struct MeasurementInput: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var bodypart: Bodypart
    
    @Binding var date: Date
    @Binding var measurement: Measurement<Dimension>
    
    @Binding var didClose: Bool
    @Binding var didOpen: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                ZStack {
                    HStack {
                        Button("Cancel") {
                            withAnimation(.bouncy(duration: 0.5)) {
                                didOpen = false
                                didClose = true
                            }
                        }
                        Spacer()
                        Button("Add") {
                            // add measurement
                            resignFirstResponder()
                            withAnimation(.bouncy(duration: 0.5)) {
                                didOpen = false
                                didClose = true
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
                    .padding(.bottom, 4)
                    .padding(.horizontal)
                    .onTapGesture(count: 99) {} // hack to make sure the date picker opens, caused by the onTapGesture below
                    Divider()
                        .padding(.leading)
                        .frame(height: 1)
                    MeasurementInputRow(label: bodypart.rawValue.capitalized, measurement: $measurement)
                        .keyboardType(.decimalPad)
                        .padding(.bottom, 12)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
            .padding(.top)
            .background(Color(uiColor: colorScheme == .dark ? .tertiarySystemGroupedBackground : .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(8)
            .shadow(color: Theme.color.shadow, radius: 15, y: 5)
        }
    }
}

#Preview {
    BodypartDetailView(bodypart: .chest)
}

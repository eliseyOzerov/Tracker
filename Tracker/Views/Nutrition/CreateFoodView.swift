//
//  CreateFoodView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 23. 6. 24.
//

import SwiftUI
import PhotosUI

struct CreateFoodView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @State private var brand: String = ""
    @State private var brandedName: String = ""
    @State private var barcode: String = ""
    
    @State private var showBarcodeScanner = false
    @State private var showNutritionForm = false
    @State private var showIngredientsSearch = false
    
    @State private var nutrition: Nutrition? = nil
    
    var onCancel: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                }

                Section(header: Text("Metadata")) {
                    LabeledContent("Brand") {
                        TextField("e.g. Hellman's", text: $brand)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("Description") {
                        TextField("e.g. Light mayonnaise", text: $brandedName)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent {
                        TextField("e.g. 02342252543", text: $barcode)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        HStack {
                            Text("Barcode")
                            Button {
                                print("showBarcodeScanner: \(showBarcodeScanner)")
                                showBarcodeScanner = true
                            } label: {
                                Image(systemName: "barcode.viewfinder")
                                    .foregroundStyle(.blue)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                
                Section(header: Text("Ingredients")) {
                    NavButton("Add ingredients") {
                        showIngredientsSearch = true
                    }
                }

//                Section(header: Text("Photos")) {
//                    Button("Add photos") {
//                        showActionSheet = true
//                    }
//                    .actionSheet(isPresented: $showActionSheet) {
//                        ActionSheet(title: Text("Select Image Source"), buttons: [
//                            .default(Text("Camera"), action: {
//                                imagePickerSource = .camera
//                                showImagePicker = true
//                            }),
//                            .default(Text("Gallery"), action: {
//                                imagePickerSource = .photoLibrary
//                                showImagePicker = true
//                            }),
//                            .cancel()
//                        ])
//                    }
//                }
                
                Section {
                    if let nutrition = nutrition {
                        ForEach(nutrition.nutrients) { nutrient in
                            LabeledContent(nutrient.nutrient.rawValue.capitalized, value: nutrient.measurement.toString)
                                .containerShape(Rectangle()) // make sure gestures are detected
                                .background(Color.clear)
                                .onTapGesture {
                                    showNutritionForm = true
                                }
                        }
                    } else {
                        Button {
                            showNutritionForm = true
                        } label: {
                            HStack {
                                Text("Add nutrition")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue.lighter(0.5))
                            }
                        }
                    }
                } header: {
                    Text("Nutrition\(nutrition != nil ? " (Per \(nutrition!.measurement.toString))" : "")")
                }
            }
            .navigationDestination(isPresented: $showBarcodeScanner) {
                BarcodeScannerView { code in
                    self.barcode = code
                } onCancel: {
                    showBarcodeScanner = false
                }
                .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $showNutritionForm) {
                NutritionFormView(nutrition: self.nutrition) { nutrition in
                    self.nutrition = nutrition
                    modelContext.insert(nutrition)
                    showNutritionForm = false
                }
            }
            .navigationDestination(isPresented: $showIngredientsSearch) {
                SearchFoodsView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Create") {
                        print("Hello")
                    }
                }
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
            }
            .navigationTitle("Create food")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

class UnitSize: Unit {
    static var small = UnitSize(symbol: "sm")
    static var medium = UnitSize(symbol: "md")
    static var large = UnitSize(symbol: "lg")
}

struct UnitPicker: View {
    @Binding var unit: Unit
    
    var body: some View {
        Menu {
            Section(header: Text("Mass")) {
                Button("Grams (g)") {
                    unit = UnitMass.grams
                }
                Button("Milligrams (mg)") {
                    unit = UnitMass.milligrams
                }
                Button("Micrograms (mcg)") {
                    unit = UnitMass.micrograms
                }
            }
            
            Section(header: Text("Volume")) {
                Button("Liters (l)") {
                    unit = UnitVolume.liters
                }
                Button("Milliliters (ml)") {
                    unit = UnitVolume.milliliters
                }
            }
            
            Section(header: Text("Size")) {
                Button("Small (sm)") {
                    unit = UnitSize.small
                }
                Button("Medium (md)") {
                    unit = UnitSize.medium
                }
                Button("Large (lg)") {
                    unit = UnitSize.large
                }
            }
        } label: {
            Text(unit.symbol)
                .font(.headline)
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }
}


//HStack {
//    TextField("Protein", text: $protein)
//    Menu {
//        Button(action: { proteinUnit = .grams }) {
//            Text("Grams (g)")
//        }
//        Button(action: { proteinUnit = .milligrams }) {
//            Text("Milligrams (mg)")
//        }
//        Button(action: { proteinUnit = .micrograms }) {
//            Text("Micrograms (µg)")
//        }
//    } label: {
//        HStack(spacing: 4) {
//            Text(proteinUnit.symbol)
//                .font(.headline)
//            Image(systemName: "chevron.down")
//                .font(.caption)
//                .fontWeight(.bold)
//        }
//    }
//    .foregroundStyle(Color(uiColor: .tertiaryLabel))
//}
#Preview {
    CreateFoodView { }
}

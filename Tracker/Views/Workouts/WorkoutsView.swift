//
//  WorkoutsView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 27. 6. 24.
//

import SwiftUI

struct WorkoutsView: View {
    
    @State var showExercises = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: .zero) {
                Text("Templates")
                    .font(.headline)
                    .foregroundStyle(.tertiary)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Exercises") {
                        showExercises = true
                    }
                }
            }
            .navigationDestination(isPresented: $showExercises) {
                ManageWorkoutsView()
            }
        }
    }
}

#Preview {
    WorkoutsView()
}

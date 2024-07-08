//
//  EditWorkoutView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 2. 7. 24.
//

import SwiftUI

struct EditWorkoutView: View {
    let workout: Workout
    
    init(workout: Workout? = nil) {
        self.workout = workout ?? Workout()
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    EditWorkoutView()
}

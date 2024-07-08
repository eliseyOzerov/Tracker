//
//  WorkoutTemplatesView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 2. 7. 24.
//

import SwiftUI
import SwiftData

struct WorkoutTemplatesView: View {
    @Query var templates: [Workout]
    @State var showSheet = false
    
    var body: some View {
        Group {
            if templates.isEmpty {
                Button {
                    showSheet = true
                } label: {
                    VStack(spacing: Theme.spacing.s4) {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                        Text("Tap to add your first workout template 💪🏻")
                            .font(.title3)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                    }
                    .padding()
                    .padding()
                }
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(templates) { t in
                            Text(t.title)
                        }
                    }
                }
            }
        }
        .toolbar {
            if !templates.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            EditWorkoutView()
        }
    }
}

#Preview {
    WorkoutTemplatesView()
}

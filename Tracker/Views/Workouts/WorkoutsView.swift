//
//  WorkoutsView.swift
//  Tracker
//
//  Created by Elisey Ozerov on 27. 6. 24.
//

import SwiftUI
import SwiftData

struct WorkoutsView: View {
    
    @Query var workouts: [Workout]
    
    @State var showExercises = false
    @State var showAllTemplates = false
    @State var showWorkoutEditor = false
    
    @State var editingWorkout: Workout? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    VStack {
                        HStack {
                            Text("Templates")
                                .font(.title3)
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                            Spacer()
                            if !workouts.isEmpty {
                                Button("See all") {
                                    showAllTemplates = true
                                }
                                .font(.headline)
                            } else {
                                Button("Add") {
                                    showWorkoutEditor = true
                                    showAllTemplates = true
                                }
                                .font(.headline)
                            }
                        }
                        .fontDesign(.rounded)
                        .padding()
                        
                        if workouts.isEmpty {
                            HStack {
                                Image(systemName: "list.clipboard")
                                    .font(.system(size: 48))
                                    .fontWeight(.ultraLight)
                                Text("Tap add to create a new template.")
                                    .fontDesign(.rounded)
                                    .padding()
                            }
                            .foregroundStyle(.tertiary)
                            .frame(height: 100)
                            .padding(.horizontal, 64)
                        } else {
                            LazyVStack {
                                ForEach(workouts.filter { $0.start == nil }) { w in
                                    Text(w.title)
                                }
                            }
                        }
                    }
                    VStack {
                        HStack {
                            Text("History")
                                .font(.title3)
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .fontDesign(.rounded)
                        .padding()
                        
                        if workouts.isEmpty {
                            VStack {
                                Image(systemName: "dumbbell")
                                    .font(.system(size: 96))
                                    .fontWeight(.ultraLight)
                                Text("Tap start to record your first workout")
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.tertiary)
                                    .padding()
                            }
                            .foregroundStyle(.tertiary)
                            .frame(height: 350)
                        } else {
                            LazyVStack {
                                ForEach(workouts.filter { $0.start != nil }) { w in
                                    Text(w.title)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    Button {
                        editingWorkout = Workout(start: Date())
                        showWorkoutEditor = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Start empty workout")
                            Spacer()
                        }
                        .font(.headline)
                        .fontDesign(.rounded)
                        .padding()
                        .frame(height: 56)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .cornerRadius(12)
                    }
                    .padding()
                }
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
            .navigationDestination(isPresented: $showAllTemplates) {
                WorkoutTemplatesView(showSheet: showWorkoutEditor)
            }
            .sheet(isPresented: $showWorkoutEditor) {
                EditWorkoutView(workout: editingWorkout)
            }
        }
    }
}

#Preview {
    WorkoutsView()
}

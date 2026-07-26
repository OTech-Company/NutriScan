//
//  ExerciseRoute.swift
//  NutriScan
//

import SwiftUI

enum ExerciseRoute: Route {
    case workoutPlayer(exercise: Exercise)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .workoutPlayer(let exercise):
            ExerciseWorkoutPlayerView(exercise: exercise)
        }
    }
}

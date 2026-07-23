//
//  ExerciseRoute.swift
//  NutriScan
//

import SwiftUI

enum ExerciseRoute: Route {
    // No push-destinations yet; detail is presented as a sheet.
    // Add push cases here as the feature grows (e.g. .workoutPlayer).

    @ViewBuilder
    var destination: some View {
        EmptyView()
    }
}

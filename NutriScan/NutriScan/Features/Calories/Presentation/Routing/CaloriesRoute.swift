//
//  CaloriesRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 22/07/2026.
//

import SwiftUI

enum CaloriesRoute: Route {
    case stepHistory(viewModel: StepCounterViewModel)
    case exercises

    @ViewBuilder
    var destination: some View {
        switch self {
        case .stepHistory(let viewModel):
            StepHistoryScreen(viewModel: viewModel)
        case .exercises:
            ExercisesView()
        }
    }

    // MARK: - Equatable Conformance
    static func == (lhs: CaloriesRoute, rhs: CaloriesRoute) -> Bool {
        switch (lhs, rhs) {
        case (.stepHistory(let lhsVM), .stepHistory(let rhsVM)):
            return lhsVM === rhsVM
        case (.exercises, .exercises):
            return true
        default:
            return false
        }
    }

    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .stepHistory(let viewModel):
            hasher.combine(0)
            hasher.combine(ObjectIdentifier(viewModel))
        case .exercises:
            hasher.combine(1)
        }
    }
}

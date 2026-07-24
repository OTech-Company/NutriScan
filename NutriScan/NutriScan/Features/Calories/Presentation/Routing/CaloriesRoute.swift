//
//  StepRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 22/07/2026.
//

import SwiftUI

enum CaloriesRoute: Route {
    case stepHistory(viewModel: StepCounterViewModel)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .stepHistory(let viewModel):
            StepHistoryScreen(viewModel: viewModel)
        }
    }

    // MARK: - Equatable Conformance
    static func == (lhs: CaloriesRoute, rhs: CaloriesRoute) -> Bool {
        switch (lhs, rhs) {
        case (.stepHistory(let lhsVM), .stepHistory(let rhsVM)):
            return lhsVM === rhsVM // Checks if both reference the same ViewModel instance
        }
    }

    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .stepHistory(let viewModel):
            hasher.combine(ObjectIdentifier(viewModel))
        }
    }
}

//
//  CaloriesHistoryFactory.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import SwiftUI

enum CaloriesHistoryFactory {
    @MainActor
    static func makeView() -> CaloriesHistoryView {
        CaloriesHistoryView(
            viewModel: CaloriesHistoryViewModel(
                getPageUseCase: DIContainer.shared.resolve(
                    type: GetCaloriesHistoryPageUseCaseProtocol.self
                ),
                getByDateUseCase: DIContainer.shared.resolve(
                    type: GetCaloriesHistoryByDateUseCaseProtocol.self
                )
            )
        )
    }
}

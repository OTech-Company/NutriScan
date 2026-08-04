//
//  AccountRestorationFactory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

@MainActor
final class AccountRestorationFactory {
    static func makeAccountRestorationView() -> AccountRestorationView {
        let viewModel = AccountRestorationViewModel(
            restoreAccountUseCase: DIContainer.shared.resolve(type: RestoreAccountUseCaseProtocol.self)
        )
        return AccountRestorationView(viewModel: viewModel)
    }
}

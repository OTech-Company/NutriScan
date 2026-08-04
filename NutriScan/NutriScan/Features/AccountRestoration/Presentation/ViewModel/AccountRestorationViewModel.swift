//
//  AccountRestorationViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation
import Observation

@Observable
final class AccountRestorationViewModel {
    var isLoading: Bool = false
    var generalError: String? = nil

    private let restoreAccountUseCase: RestoreAccountUseCaseProtocol

    init(restoreAccountUseCase: RestoreAccountUseCaseProtocol) {
        self.restoreAccountUseCase = restoreAccountUseCase
    }

    @MainActor
    func restoreAccount(flowCoordinator: AppFlowCoordinator) async {
        isLoading = true
        generalError = nil
        defer { isLoading = false }

        do {
            _ = try await restoreAccountUseCase.execute()
            flowCoordinator.didRestoreAccount()
        } catch {
            generalError = error.localizedDescription
        }
    }

    func logout(flowCoordinator: AppFlowCoordinator) {
        flowCoordinator.logout()
    }
}

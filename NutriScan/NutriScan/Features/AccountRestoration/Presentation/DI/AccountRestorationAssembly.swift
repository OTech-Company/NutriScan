//
//  AccountRestorationAssembly.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import Foundation

struct AccountRestorationAssembly: Assembly {
    func assemble(container: DIContainer) {
        let repository = AccountRestorationRepositoryImpl()
        container.register(
            type: AccountRestorationRepositoryProtocol.self,
            component: repository
        )

        container.register(
            type: RestoreAccountUseCaseProtocol.self,
            component: RestoreAccountUseCase(repository: repository)
        )
    }
}

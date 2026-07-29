//
//  AuthAssembly.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 27/07/2026.
//

import Foundation

struct AuthAssembly: Assembly {
    func assemble(container: DIContainer) {
        let repository = AuthRepositoryImpl()
        container.register(type: AuthRepositoryProtocol.self, component: repository)
        
        container.register(
            type: LoginUseCaseProtocol.self,
            component: LoginUseCase(repository: repository)
        )
        container.register(
            type: RegisterUseCaseProtocol.self,
            component: RegisterUseCase(repository: repository)
        )
        container.register(
            type: ForgotPasswordUseCaseProtocol.self,
            component: ForgotPasswordUseCase(repository: repository)
        )
        container.register(
            type: ResendVerificationUseCaseProtocol.self,
            component: ResendVerificationUseCase(repository: repository)
        )
    }
}

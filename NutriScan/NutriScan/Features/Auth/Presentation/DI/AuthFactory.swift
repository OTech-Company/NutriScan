//
//  AuthFactory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 27/07/2026.
//

import Foundation
import SwiftUI

enum AuthFactory {
    
    // MARK: - ViewModels
    
    static func makeLoginViewModel() -> LoginViewModel {
        let useCase = DIContainer.shared.resolve(type: LoginUseCaseProtocol.self)
        return LoginViewModel(loginUseCase: useCase)
    }

    static func makeRegisterViewModel() -> RegisterViewModel {
        let useCase = DIContainer.shared.resolve(type: RegisterUseCaseProtocol.self)
        return RegisterViewModel(registerUseCase: useCase)
    }

    static func makeForgotPasswordViewModel() -> ForgotPasswordViewModel {
        let useCase = DIContainer.shared.resolve(type: ForgotPasswordUseCaseProtocol.self)
        return ForgotPasswordViewModel(forgotPasswordUseCase: useCase)
    }

    static func makeVerificationPendingViewModel(email: String) -> VerificationPendingViewModel {
        let useCase = DIContainer.shared.resolve(type: ResendVerificationUseCaseProtocol.self)
        return VerificationPendingViewModel(email: email, resendUseCase: useCase)
    }

    // MARK: - Views
    
    static func makeLoginView() -> LoginView {
        LoginView(viewModel: makeLoginViewModel())
    }

    static func makeRegisterView() -> RegisterView {
        RegisterView(viewModel: makeRegisterViewModel())
    }

    static func makeForgotPasswordView() -> ForgotPasswordView {
        ForgotPasswordView(viewModel: makeForgotPasswordViewModel())
    }

    static func makeVerificationPendingView(email: String) -> VerificationPendingView {
        VerificationPendingView(viewModel: makeVerificationPendingViewModel(email: email))
    }
}

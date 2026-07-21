//
//  LoginViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 15/07/2026.
//

import Foundation
import Observation

@Observable
final class LoginViewModel {

    // MARK: - Fields
    var email    = ValidatedField()
    var password = ValidatedField()

    // MARK: - Status
    var isLoading: Bool = false
    var generalError: String? = nil
    var isEmailUnverified: Bool = false

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }

    // MARK: - Per-field validation (used by real-time onChange)

    func validateEmail() {
        email.validate(using: AppValidator.emailValidator)
    }

    func validatePassword() {
        password.validate(using: AppValidator.passwordValidator)
    }

    // MARK: - Full validation (used by signIn)

    /// Validates both fields. Returns `true` only if both fields pass.
    @discardableResult
    func validateAll() -> Bool {
        validateEmail()
        validatePassword()
        return email.state == .success && password.state == .success
    }

    // MARK: - Sign In

    /// Validates, then attempts authentication. Returns `true` on success.
    func signIn() async -> Bool {
        guard validateAll() else { return false }
        isLoading = true
        generalError = nil
        isEmailUnverified = false
        defer { isLoading = false }
        
        do {
            let request = LoginRequest(email: email.value, password: password.value)
            _ = try await loginUseCase.execute(request: request)
            return true
        } catch let error as NetworkError {
            if case .apiError(let apiError) = error,
               apiError.errorDescription == "Account is not fully set up" {
                isEmailUnverified = true
            } else {
                generalError = error.localizedDescription
            }
            return false
        } catch {
            generalError = error.localizedDescription
            return false
        }
    }
}

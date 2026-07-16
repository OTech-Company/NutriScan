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
        defer { isLoading = false }
        
        print("hellow nageh")
        // Simulate network latency (2 seconds)
        try? await Task.sleep(for: .seconds(2))
        
        // TODO: call AuthUseCase.login(email: email.value, password: password.value)
        return true
    }
}

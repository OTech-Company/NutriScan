//
//  RegisterViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 15/07/2026.
//

import Foundation
import Observation

@Observable
final class RegisterViewModel {

    // MARK: - Fields
    var email           = ValidatedField()
    var password        = ValidatedField()
    var confirmPassword = ValidatedField()

    // MARK: - Per-field validation (used by real-time onChange)

    func validateEmail() {
        email.validate(using: AppValidator.emailValidator)
    }

    func validatePassword() {
        password.validate(using: AppValidator.passwordValidator)
        // Keep confirm in sync when password changes
        if !confirmPassword.value.isEmpty {
            validateConfirmPassword()
        }
    }

    func validateConfirmPassword() {
        confirmPassword.validate {
            AppValidator.repeatPasswordValidator(value: $0, password: password.value)
        }
    }

    // MARK: - Full validation (used by signUp)

    /// Validates all three fields and returns `true` only if every field is `.success`.
    @discardableResult
    func validateAll() -> Bool {
        validateEmail()
        validatePassword()
        validateConfirmPassword()
        return email.state == .success
            && password.state == .success
            && confirmPassword.state == .success
    }

    // MARK: - Status
    var isLoading: Bool = false
    var generalError: String? = nil


    func signUp() async -> Bool {
        
        guard validateAll() else { return false }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 3) {
            self.isLoading = false
        }
        
        defer { isLoading = false }
        
        // TODO: call AuthUseCase.register(email: email.value, password: password.value)
        
        return true
    }
}

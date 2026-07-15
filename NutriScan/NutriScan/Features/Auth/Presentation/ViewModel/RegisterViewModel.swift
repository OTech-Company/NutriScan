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

    // MARK: - Status
    var isLoading: Bool = false
    var generalError: String? = nil


    @discardableResult
    func validateAll() -> Bool {
        let emailValid = email.validate(using: AppValidator.emailValidator)
        let passwordValid = password.validate(using: AppValidator.passwordValidator)
        let confirmValid = confirmPassword.validate(using: { [self] in
            AppValidator.repeatPasswordValidator(value: $0, password: password.value)
        })
        return emailValid && passwordValid && confirmValid
    }


    func signUp() async -> Bool {
        
        guard validateAll() else { return false }
        
        isLoading = true
        
        defer { isLoading = false }
        
        // TODO: call AuthUseCase.register(email: email.value, password: password.value)
        
        return true
    }
}

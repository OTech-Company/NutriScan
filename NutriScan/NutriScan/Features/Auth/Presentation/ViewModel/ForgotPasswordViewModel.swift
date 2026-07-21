//
//  ForgotPasswordViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import Foundation
import Observation

@Observable
final class ForgotPasswordViewModel {
    
    // MARK: - Fields
    var email = ValidatedField()
    
    // MARK: - Fields
    var email = ValidatedField()
    
    // MARK: - Status
    var isLoading: Bool = false
    var successMessage: String? = nil
    
    private let forgotPasswordUseCase: ForgotPasswordUseCase
    
    init(forgotPasswordUseCase: ForgotPasswordUseCase = ForgotPasswordUseCase()) {
        self.forgotPasswordUseCase = forgotPasswordUseCase
    }
    
    // MARK: - Validation
    func validateEmail() {
        email.validate(using: AppValidator.emailValidator)
    }
    
    func resetPassword() async -> Bool {
        validateEmail()
        guard email.state == .success else { return false }
        
        isLoading = true
        successMessage = nil
        
        defer { isLoading = false }
        
        do {
            let result = try await forgotPasswordUseCase.execute(email: email.value)
            successMessage = result.message
            return true
        } catch {
            email.state = .error
            email.error = error.localizedDescription
            return false
        }
    }
}

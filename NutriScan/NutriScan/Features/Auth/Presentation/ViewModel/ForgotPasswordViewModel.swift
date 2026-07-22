//
//  ForgotPasswordViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import Foundation
import Observation

enum ForgotPasswordPopupState {
    case hidden
    case enterEmail
    case emailSent
}

@Observable
final class ForgotPasswordViewModel {
    
    // MARK: - Selected Option
    var selectedOption: PasswordResetOption = .email
    
    // MARK: - Popup State
    var popupState: ForgotPasswordPopupState = .hidden
    
    // MARK: - Fields
    var email = ValidatedField()
    
    // MARK: - Status
    var isLoading: Bool = false
    var successMessage: String? = nil
    
    private let forgotPasswordUseCase: ForgotPasswordUseCase
    
    init(forgotPasswordUseCase: ForgotPasswordUseCase = ForgotPasswordUseCase()) {
        self.forgotPasswordUseCase = forgotPasswordUseCase
    }
    
    // MARK: - Popup Flow Actions
    func startResetFlow() {
        popupState = .enterEmail
    }
    
    func closePopup() {
        popupState = .hidden
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
            popupState = .emailSent
            return true
        } catch {
            email.state = .error
            email.error = error.localizedDescription
            return false
        }
    }
}

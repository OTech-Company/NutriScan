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
    
    // MARK: - Selected Option
    var selectedOption: PasswordResetOption = .twoFactor
    
    // MARK: - Status
    var isLoading: Bool = false
    var successMessage: String? = nil
    
    func resetPassword() async -> Bool {
        isLoading = true
        successMessage = nil
        
        // Simulate network latency (2 seconds)
        try? await Task.sleep(for: .seconds(2))
        
        defer { isLoading = false }
        
        successMessage = "Reset instructions sent via \(selectedOption.rawValue)!"
        return true
    }
}

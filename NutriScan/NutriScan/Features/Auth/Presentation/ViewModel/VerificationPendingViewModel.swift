//
//  VerificationPendingViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation
import Observation

@Observable
final class VerificationPendingViewModel {
    var email: String
    var countdown: Int = 0
    var isLoading: Bool = false
    var generalError: String? = nil
    var resendSuccess: Bool = false
    var resendMessage: String = ""
    
    private let resendUseCase: ResendVerificationUseCase
    
    init(email: String, resendUseCase: ResendVerificationUseCase = ResendVerificationUseCase()) {
        self.email = email
        self.resendUseCase = resendUseCase
    }
    
    func resendVerification() async {
        guard countdown == 0 else { return }
        isLoading = true
        generalError = nil
        resendSuccess = false
        
        defer { isLoading = false }
        
        do {
            let result = try await resendUseCase.execute(email: email)
            self.resendMessage = result.message
            resendSuccess = true
            startCountdown()
        } catch let error as NetworkError {
            generalError = error.localizedDescription
        } catch {
            generalError = error.localizedDescription
        }
    }
    
    private func startCountdown() {
        countdown = 60
        Task { @MainActor in
            while countdown > 0 {
                try? await Task.sleep(for: .seconds(1))
                countdown -= 1
            }
        }
    }
}

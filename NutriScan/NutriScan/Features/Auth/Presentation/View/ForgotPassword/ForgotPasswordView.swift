//
//  ForgotPasswordView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel = ForgotPasswordViewModel()
    @State private var showAlert = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // MARK: Header
                ForgotPasswordHeaderSection(onBack: {
                    router.pop()
                })
                
                // MARK: Reset Options
                ForgotPasswordOptionsSection(viewModel: viewModel)
                    .padding(.top, 32)
                
                Spacer(minLength: 40)
                
                // MARK: Action Button
                ForgotPasswordResetButtonSection(
                    onReset: handleReset,
                    isLoading: viewModel.isLoading
                )
            }
        }
        .appAuthBackground()
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
        .alert("Success", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                router.pop()
            }
        } message: {
            Text(viewModel.successMessage ?? "")
        }
    }
    
    private func handleReset() {
        Task {
            let success = await viewModel.resetPassword()
            if success {
                showAlert = true
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AppRouter())
}

//
//  ForgotPasswordResetButtonSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import SwiftUI

struct ForgotPasswordResetButtonSection: View {
    var onReset: () -> Void
    var isLoading: Bool = false

    var body: some View {
        VStack {
            CustomPuffedButton(
                title: "Reset Password",
                action: onReset,
                isLoading: isLoading
            )
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
}

#Preview {
    ForgotPasswordResetButtonSection(onReset: {})
        .background(Color.Teal.teal100)
}

//
//  RegisterSignUpButtonSection.swift
//  NutriScan
//

import SwiftUI

struct RegisterSignUpButtonSection: View {
    var onSignUp: () -> Void
    var onSignIn: () -> Void
    var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 18) {
            CustomPuffedButton(title: LocalizationKeys.Auth.Register.signUp.localized, action: onSignUp, isLoading: isLoading)
                .padding(.horizontal, 20)

            // "Already have an account?" row
            HStack(spacing: 4) {
                Text(LocalizationKeys.Auth.Register.alreadyHaveAccount.localized)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.RegisterSemantic.footerText)

                Button(action: onSignIn) {
                    Text(LocalizationKeys.Auth.Register.signIn.localized)
                        .font(Font.AppFont.textSecondary)
                        .fontWeight(.bold)
                        .foregroundColor(Color.RegisterSemantic.footerLink)
                        .underline()
                }
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 24)
    }
}

#Preview {
    RegisterSignUpButtonSection(onSignUp: {}, onSignIn: {})
        .background(Color.Teal.teal100)
}

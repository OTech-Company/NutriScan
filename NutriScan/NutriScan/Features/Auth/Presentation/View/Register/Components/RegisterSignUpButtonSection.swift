//
//  RegisterSignUpButtonSection.swift
//  NutriScan
//

import SwiftUI

struct RegisterSignUpButtonSection: View {
    var onSignUp: () -> Void
    var onSignIn: () -> Void
    var isLoading: Bool = false

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 18) {
            CustomPuffedButton(title: "Sign Up", action: onSignUp, isLoading: isLoading)                .padding(.horizontal, 20)

            // "Already have an account?" row
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(colorScheme == .light ? Color.Gray.gray1000 : Color.Gray.gray400)

                Button(action: onSignIn) {
                    Text("Sign In.")
                        .font(Font.AppFont.textSecondary)
                        .fontWeight(.bold)
                        .foregroundColor(Color.Teal.teal1000)
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

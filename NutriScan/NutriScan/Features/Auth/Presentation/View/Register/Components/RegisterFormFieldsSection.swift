//
//  RegisterFormFieldsSection.swift
//  NutriScan
//

import SwiftUI

struct RegisterFormFieldsSection: View {

    @Bindable var viewModel: RegisterViewModel

    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(
                title: "Email Address",
                leadingIcon: "envelope",
                isPassword: false,
                errorMessage: viewModel.email.error,
                placeHolder: "Enter your email address...",
                textFieldValue: $viewModel.email.value,
                state: $viewModel.email.state
            )

            CustomTextField(
                title: "Password",
                leadingIcon: "lock",
                isPassword: true,
                errorMessage: viewModel.password.error,
                placeHolder: "Create a password",
                textFieldValue: $viewModel.password.value,
                state: $viewModel.password.state
            )

            CustomTextField(
                title: "Password Confirmation",
                leadingIcon: "lock",
                isPassword: true,
                errorMessage: viewModel.confirmPassword.error,
                placeHolder: "Repeat password",
                textFieldValue: $viewModel.confirmPassword.value,
                state: $viewModel.confirmPassword.state
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .onChange(of: viewModel.email.value)           { viewModel.validateEmail() }
        .onChange(of: viewModel.password.value)        { viewModel.validatePassword() }
        .onChange(of: viewModel.confirmPassword.value) { viewModel.validateConfirmPassword() }
    }
}

#Preview {
    RegisterFormFieldsSection(viewModel: RegisterViewModel())
        .background(Color.Teal.teal100)
}

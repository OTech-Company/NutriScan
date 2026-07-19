//
//  LoginFormFieldsSection.swift
//  NutriScan
//

import SwiftUI

struct LoginFormFieldsSection: View {
    @Bindable var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 16) {
            CustomTextField(
                title: "Email Address",
                leadingIcon: "envelope",
                errorMessage: viewModel.email.error,
                placeHolder: "elementary221b@gmail.com",
                textFieldValue: $viewModel.email.value,
                state: $viewModel.email.state
            )

            CustomTextField(
                title: "Password",
                leadingIcon: "lock",
                isPassword: true,
                errorMessage: viewModel.password.error,
                placeHolder: "*****************",
                textFieldValue: $viewModel.password.value,
                state: $viewModel.password.state
            )
        }
        .onChange(of: viewModel.email.value)    { viewModel.validateEmail() }
        .onChange(of: viewModel.password.value) { viewModel.validatePassword() }
    }
}

#Preview {
    LoginFormFieldsSection(viewModel: LoginViewModel())
        .background(Color.Teal.teal100)
}

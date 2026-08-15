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
                title: LocalizationKeys.Auth.Login.emailTitle.localized,
                leadingIcon: "envelope",
                errorMessage: viewModel.email.error,
                placeHolder: LocalizationKeys.Auth.Login.emailPlaceholder.localized,
                textFieldValue: $viewModel.email.value,
                state: $viewModel.email.state
            )

            CustomTextField(
                title: LocalizationKeys.Auth.Login.passwordTitle.localized,
                leadingIcon: "lock",
                isPassword: true,
                errorMessage: viewModel.password.error,
                placeHolder: LocalizationKeys.Auth.Login.passwordPlaceholder.localized,
                textFieldValue: $viewModel.password.value,
                state: $viewModel.password.state
            )
        }
        .onChange(of: viewModel.email.value)    { viewModel.validateEmail() }
        .onChange(of: viewModel.password.value) { viewModel.validatePassword() }
    }
}

#Preview {
    LoginFormFieldsSection(viewModel: AuthFactory.makeLoginViewModel())
        .background(Color.Teal.teal100)
}

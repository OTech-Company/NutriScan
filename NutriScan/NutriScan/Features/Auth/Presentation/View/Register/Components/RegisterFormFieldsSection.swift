//
//  RegisterFormFieldsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

struct RegisterFormFieldsSection: View {

    @Bindable var viewModel: RegisterViewModel

    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(
                title: LocalizationKeys.Auth.Register.firstNameTitle.localized,
                leadingIcon: "person",
                isPassword: false,
                errorMessage: viewModel.firstName.error,
                placeHolder: LocalizationKeys.Auth.Register.firstNamePlaceholder.localized,
                textFieldValue: $viewModel.firstName.value,
                state: $viewModel.firstName.state
            )

            CustomTextField(
                title: LocalizationKeys.Auth.Register.lastNameTitle.localized,
                leadingIcon: "person",
                isPassword: false,
                errorMessage: viewModel.lastName.error,
                placeHolder: LocalizationKeys.Auth.Register.lastNamePlaceholder.localized,
                textFieldValue: $viewModel.lastName.value,
                state: $viewModel.lastName.state
            )

            CustomTextField(
                title: LocalizationKeys.Auth.Register.emailTitle.localized,
                leadingIcon: "envelope",
                isPassword: false,
                errorMessage: viewModel.email.error,
                placeHolder: LocalizationKeys.Auth.Register.emailPlaceholder.localized,
                textFieldValue: $viewModel.email.value,
                state: $viewModel.email.state
            )

            CustomTextField(
                title: LocalizationKeys.Auth.Register.passwordTitle.localized,
                leadingIcon: "lock",
                isPassword: true,
                errorMessage: viewModel.password.error,
                placeHolder: LocalizationKeys.Auth.Register.passwordPlaceholder.localized,
                textFieldValue: $viewModel.password.value,
                state: $viewModel.password.state
            )

            CustomTextField(
                title: LocalizationKeys.Auth.Register.confirmPasswordTitle.localized,
                leadingIcon: "lock",
                isPassword: true,
                errorMessage: viewModel.confirmPassword.error,
                placeHolder: LocalizationKeys.Auth.Register.confirmPasswordPlaceholder.localized,
                textFieldValue: $viewModel.confirmPassword.value,
                state: $viewModel.confirmPassword.state
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .onChange(of: viewModel.firstName.value)       { viewModel.validate(field: .firstName) }
        .onChange(of: viewModel.lastName.value)        { viewModel.validate(field: .lastName) }
        .onChange(of: viewModel.email.value)           { viewModel.validate(field: .email) }
        .onChange(of: viewModel.password.value)        { viewModel.validate(field: .password) }
        .onChange(of: viewModel.confirmPassword.value) { viewModel.validate(field: .confirmPassword) }
    }
}

#Preview {
    RegisterFormFieldsSection(viewModel: AuthFactory.makeRegisterViewModel())
        .background(Color.Teal.teal100)
}

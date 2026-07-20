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
                title: "First Name",
                leadingIcon: "person",
                isPassword: false,
                errorMessage: viewModel.firstName.error,
                placeHolder: "Enter your first name...",
                textFieldValue: $viewModel.firstName.value,
                state: $viewModel.firstName.state
            )

            CustomTextField(
                title: "Last Name",
                leadingIcon: "person",
                isPassword: false,
                errorMessage: viewModel.lastName.error,
                placeHolder: "Enter your last name...",
                textFieldValue: $viewModel.lastName.value,
                state: $viewModel.lastName.state
            )

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
        .onChange(of: viewModel.firstName.value)       { viewModel.validate(field: .firstName) }
        .onChange(of: viewModel.lastName.value)        { viewModel.validate(field: .lastName) }
        .onChange(of: viewModel.email.value)           { viewModel.validate(field: .email) }
        .onChange(of: viewModel.password.value)        { viewModel.validate(field: .password) }
        .onChange(of: viewModel.confirmPassword.value) { viewModel.validate(field: .confirmPassword) }
    }
}

#Preview {
    RegisterFormFieldsSection(viewModel: RegisterViewModel())
        .background(Color.Teal.teal100)
}

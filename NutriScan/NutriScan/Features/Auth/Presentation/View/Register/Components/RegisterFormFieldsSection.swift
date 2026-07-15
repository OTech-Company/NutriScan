//
//  RegisterFormFieldsSection.swift
//  NutriScan
//

import SwiftUI

struct RegisterFormFieldsSection: View {

    @Binding var email: ValidatedField
    @Binding var password: ValidatedField
    @Binding var confirmPassword: ValidatedField

    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(
                title: "Email Address",
                leadingIcon: "envelope",
                isPassword: false,
                errorMessage: email.error,
                placeHolder: "Enter your email address...",
                textFieldValue: $email.value,
                state: $email.state
            )

            CustomTextField(
                title: "Password",
                leadingIcon: "lock",
                isPassword: true,
                errorMessage: password.error,
                placeHolder: "Create a password",
                textFieldValue: $password.value,
                state: $password.state
            )

            CustomTextField(
                title: "Password Confirmation",
                leadingIcon: "lock",
                isPassword: true,
                errorMessage: confirmPassword.error,
                placeHolder: "Repeat password",
                textFieldValue: $confirmPassword.value,
                state: $confirmPassword.state
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

#Preview {
    RegisterFormFieldsSection(
        email: .constant(ValidatedField()),
        password: .constant(ValidatedField()),
        confirmPassword: .constant(ValidatedField(value: "pass_mismatch", state: .error, error: "ERROR: Password do not match!"))
    )
    .background(Color.Teal.teal100)
}

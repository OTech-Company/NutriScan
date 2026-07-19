//
//  CustomTextField.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 14/07/2026.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    var leadingIcon: String
    var isPassword: Bool = false
    var errorMessage: String = "Please enter a valid value"
    var placeHolder: String
    
    @Binding var textFieldValue: String
    @Binding var state: TextFieldState
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CustomTextFieldTitle(title: title)
            
            CustomTextFieldInput(
                leadingIcon: leadingIcon,
                placeHolder: placeHolder,
                isPassword: isPassword,
                textFieldValue: $textFieldValue,
                state: $state,
                isSecure: $isSecure
            )
            
            if state == .error {
                CustomTextFieldError(errorMessage: errorMessage)
            }
        }
        .padding(.horizontal, 5)
    }
}



#Preview("Light Mode") {
    ScrollView {
        VStack(spacing: 20) {
            CustomTextField(title: "Email Address", leadingIcon: "envelope", placeHolder: "Enter your email address...", textFieldValue: .constant(""), state: .constant(.normal))
            
            CustomTextField(title: "Password", leadingIcon: "lock", isPassword: true, placeHolder: "Create a password", textFieldValue: .constant("*****************"), state: .constant(.normal))
            
            CustomTextField(title: "Password Confirmation", leadingIcon: "lock", isPassword: true, errorMessage: "ERROR: Password do not match!", placeHolder: "Repeat password", textFieldValue: .constant("pass_mismatch"), state: .constant(.error))
        }
        .padding()
    }
    .background(Color(red: 240/255, green: 250/255, blue: 252/255))
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ScrollView {
        VStack(spacing: 20) {
            CustomTextField(title: "Email Address", leadingIcon: "envelope", placeHolder: "Enter your email address...", textFieldValue: .constant(""), state: .constant(.normal))
            
            CustomTextField(title: "Password", leadingIcon: "lock", isPassword: true, placeHolder: "Create a password", textFieldValue: .constant("*****************"), state: .constant(.normal))
            
            CustomTextField(title: "Password Confirmation", leadingIcon: "lock", isPassword: true, errorMessage: "ERROR: Password do not match!", placeHolder: "Repeat password", textFieldValue: .constant("pass_mismatch"), state: .constant(.error))
        }
        .padding()
    }
    .background(Color.Teal.teal1600)
    .preferredColorScheme(.dark)
}

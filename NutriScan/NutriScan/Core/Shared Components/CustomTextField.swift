//
//  CustomTextField.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 14/07/2026.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    var isPassword: Bool = false
    var errorMessage: String = "Please enter a valid value"
    var placeHolder: String
    
    @State private var isSecure: Bool = true
    @Binding var textFieldValue: String
    @Binding var state: TextFieldState
    @FocusState private var isTyping: Bool
    
    private var borderColor: Color {
        switch state {
        case .normal:   return isTyping ? ( colorScheme == .light ? Color.Teal.teal1000 : Color.Teal.teal500) : .gray.opacity(0.4)
        case .error:    return .red
        case .success:  return .green
        }
    }

    private var iconName: String? {
        switch state {
        case .normal:
            return isPassword ? (isSecure ? "eye.slash" : "eye") : nil
        case .error:
            return "exclamationmark.circle"
        case .success:
            return "checkmark.circle"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .medium))

            HStack {
                if isPassword && isSecure {
                    SecureField(placeHolder, text: $textFieldValue)
                        .textFieldStyle(.plain)
                        .focused($isTyping)
                } else {
                    TextField(placeHolder, text: $textFieldValue)
                        .textFieldStyle(.plain)
                        .focused($isTyping)
                }

                if let iconName {
                    Image(systemName: iconName)
                        .foregroundStyle(borderColor)
                        .onTapGesture {
                            if isPassword { isSecure.toggle() }
                        }
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 2)
            )
            .animation(.easeInOut(duration: 0.2), value: isTyping)
            .animation(.easeInOut(duration: 0.2), value: state)
            .animation(.easeInOut(duration: 0.2), value: isSecure)

            if state == .error {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.red)
            }
        }
       // .padding(.horizontal,5)
    }
}

enum TextFieldState {
    case success
    case error
    case normal
}

#Preview {
    CustomTextField(title: "Email",placeHolder: "Enter Your name", textFieldValue: .constant(""), state: .constant(.normal))
}

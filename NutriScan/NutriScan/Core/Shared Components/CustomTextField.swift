//
//  CustomTextField.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 14/07/2026.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    var leadingIcon: String // New property for leading icon
    var isPassword: Bool = false
    var errorMessage: String = "Please enter a valid value"
    var placeHolder: String
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isSecure: Bool = true
    @Binding var textFieldValue: String
    @Binding var state: TextFieldState
    @FocusState private var isTyping: Bool
    
    // Helper properties for adaptive colors
    private var titleColor: Color {
        colorScheme == .light ? Color.Teal.teal1600 : Color.Teal.teal300
    }
    
    private var placeholderColor: Color {
        colorScheme == .light ? Color.Teal.teal300 : Color.Teal.teal200
    }
    
    private var valueColor: Color {
        colorScheme == .light ? Color.Teal.teal1600 : Color.Teal.teal300
    }
    
    private var iconColor: Color {
        colorScheme == .light ? Color.Teal.teal1600 : Color.Teal.teal300
    }
    
    private var fieldBackgroundColor: Color {
        colorScheme == .light ? .white : Color.Teal.teal1500
    }
    
    private var focusedBorderColor: Color {
        colorScheme == .light ? Color.Teal.teal1600 : Color.Teal.teal600
    }
    
    private var borderColor: Color {
        switch state {
        case .normal:
            return isTyping ? focusedBorderColor : Color.clear
        case .error: return .red
        case .success: return .green
        }
    }
    
    // Update error colors for dark mode requirement and reference visuals
    private var errorBackgroundColor: Color {
        colorScheme == .light ? .red.opacity(0.1) : .black.opacity(0.2)
    }
    
    private var errorTextColor: Color {
        // Standard red is usually good. Brightening for dark is complex. Keep simple standard or slight blend. Let's use red with opacity blend to match visuals.
        colorScheme == .light ? .red : .red.opacity(0.8)
    }
    
    private var errorBorderColor: Color {
        colorScheme == .light ? .red.opacity(0.5) : .red
    }
    
    private var trailingIconName: String? {
        if isPassword {
            return isSecure ? "eye.slash" : "eye"
        }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Title
            Text(title)
                .font(Font.AppFont.subtitle2)
                .foregroundStyle(titleColor)
            
            // Input Field Container
            HStack(spacing: 12) {
                // Leading Icon
                Image(systemName: leadingIcon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
                
                // Text/Secure Field
                Group {
                    if isPassword && isSecure {
                        SecureField("", text: $textFieldValue, prompt: Text(placeHolder).foregroundColor(placeholderColor))
                    } else {
                        TextField("", text: $textFieldValue, prompt: Text(placeHolder).foregroundColor(placeholderColor))
                    }
                }
                .font(Font.AppFont.textDefault)
                .foregroundColor(valueColor)
                .focused($isTyping)
                .textFieldStyle(.plain)
                
                Spacer()
                
                // Trailing Icon
                if let trailingIconName {
                    Image(systemName: trailingIconName)
                        .font(.system(size: 18))
                        .foregroundStyle(iconColor)
                        .onTapGesture {
                            if isPassword { isSecure.toggle() }
                        }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56) // Height 56
            .background(fieldBackgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .animation(.easeInOut(duration: 0.2), value: isTyping)
            .animation(.easeInOut(duration: 0.2), value: state)
            .animation(.easeInOut(duration: 0.2), value: isSecure)
            
            // Error Message Container
            if state == .error {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(errorTextColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: 44) // Error height 44
                .frame(maxWidth: .infinity) // Take available width
                .background(errorBackgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(errorBorderColor, lineWidth: 1.5)
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 5)
    }
}

enum TextFieldState {
    case success
    case error
    case normal
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScrollView {
                VStack(spacing: 20) {
                    CustomTextField(title: "Email Address", leadingIcon: "envelope", placeHolder: "Enter your email address...", textFieldValue: .constant(""), state: .constant(.normal))
                    
                    CustomTextField(title: "Password", leadingIcon: "lock", isPassword: true, placeHolder: "Create a password", textFieldValue: .constant("*****************"), state: .constant(.normal))
                    
                    CustomTextField(title: "Email Address", leadingIcon: "envelope", errorMessage: "ERROR: Enter a valid email address!", placeHolder: "Enter your email address...", textFieldValue: .constant("invalid_email"), state: .constant(.error))
                }
                .padding()
            }
            .background(Color(red: 240/255, green: 250/255, blue: 252/255))
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
            
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
            .previewDisplayName("Dark Mode")
        }
    }
}
#Preview {
    CustomTextField_Previews.previews
}

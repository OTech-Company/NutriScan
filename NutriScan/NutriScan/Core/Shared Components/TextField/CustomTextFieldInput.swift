//
//  CustomTextFieldInput.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

struct CustomTextFieldInput: View {
    var leadingIcon: String
    var placeHolder: String
    var isPassword: Bool
    
    @Binding var textFieldValue: String
    @Binding var state: TextFieldState
    @Binding var isSecure: Bool
    
    @FocusState private var isTyping: Bool
    @Environment(\.colorScheme) var colorScheme
    
    // Adaptive Colors
    private var placeholderColor: Color {
        colorScheme == .light ? Color.Teal.teal300 : Color.Teal.teal200
    }
    
    private var fieldBackgroundColor: Color {
        colorScheme == .light ? .white : Color.Teal.teal1400
    }
    
    private var inputValueColor: Color {
        if colorScheme == .light {
            return isTyping ? Color.Gray.gray600 : Color.Teal.teal1000
        } else {
            return Color.Teal.teal400
        }
    }
    
    private var leftIconColor: Color {
        Color.Teal.teal1000
    }
    
    private var rightIconColor: Color {
        colorScheme == .light ? Color.Gray.gray400 : Color.Teal.teal500
    }
    
    private var focusedBorderColor: Color {
        colorScheme == .light ? Color.Teal.teal1600 : Color.Teal.teal600
    }
    
    private var borderColor: Color {
        switch state {
        case .normal: return isTyping ? focusedBorderColor : Color.clear
        case .error: return Color.Red.red500
        case .success: return .green
        }
    }
    
    private var trailingIconName: String? {
        if isPassword { return isSecure ? "eye.slash" : "eye" }
        return nil
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Leading Icon
            Image(systemName: leadingIcon)
                .font(.system(size: 18))
                .foregroundStyle(leftIconColor)
            
            // Text/Secure Field
            Group {
                if isPassword && isSecure {
                    SecureField("", text: $textFieldValue, prompt: Text(placeHolder).foregroundColor(placeholderColor))
                } else {
                    TextField("", text: $textFieldValue, prompt: Text(placeHolder).foregroundColor(placeholderColor))
                }
            }
            .font(Font.AppFont.subtitle2)
            .foregroundColor(inputValueColor)
            .focused($isTyping)
            .textFieldStyle(.plain)
            
            Spacer()
            
            // Trailing Icon
            if let trailingIconName {
                Image(systemName: trailingIconName)
                    .font(.system(size: 18))
                    .foregroundStyle(rightIconColor)
                    .onTapGesture {
                        if isPassword { isSecure.toggle() }
                    }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 68)
        .background(fieldBackgroundColor)
        .cornerRadius(12)
        .background(
            Group {
                if state == .error {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Red.red500.opacity(0.25))
                        .padding(-4)
                }
                if isTyping {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Teal.teal1000.opacity(0.25))
                        .padding(-4)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isTyping)
        .animation(.easeInOut(duration: 0.2), value: state)
        .animation(.easeInOut(duration: 0.2), value: isSecure)
    }
}

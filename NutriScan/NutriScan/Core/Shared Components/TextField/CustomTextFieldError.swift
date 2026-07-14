//
//  CustomTextFieldError.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

struct CustomTextFieldError: View {
    var errorMessage: String
    @Environment(\.colorScheme) var colorScheme
    
    private var errorBackgroundColor: Color {
        colorScheme == .light ? Color.Red.red100 : .black.opacity(0.2)
    }
    
    private var errorItemColor: Color {
        Color.Red.red500 // Stroke, message, and icon match FA4D5E
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16))
                .foregroundColor(errorItemColor)
            
            Text(errorMessage)
                .font(Font.AppFont.title1)
                .foregroundColor(errorItemColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(errorBackgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(errorItemColor, lineWidth: 1)
        )
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

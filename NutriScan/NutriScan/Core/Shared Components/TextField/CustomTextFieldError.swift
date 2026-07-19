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
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 11))
                .foregroundColor(errorItemColor)

            Text(errorMessage)
                .font(.caption)
                .foregroundColor(errorItemColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer()
        }
        .padding(.horizontal, 12)
        .frame(height: 32)
        .frame(maxWidth: .infinity)
        .background(errorBackgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(errorItemColor, lineWidth: 1)
        )
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

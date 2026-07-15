//
//  SocialLoginButton.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 15/07/2026.
//

import SwiftUI

struct SocialLoginButton: View {
    let iconName: String
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24) // Adjust inner icon size as needed
                .frame(width: 56, height: 56) // Outer button frame
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colorScheme == .light ? Color.Gray.gray500 : Color.Teal.teal600, lineWidth: 1)
                )
        }.customTealShadow()
    }
}

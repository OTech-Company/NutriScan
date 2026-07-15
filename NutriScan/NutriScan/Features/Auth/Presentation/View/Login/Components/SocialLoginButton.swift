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
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(colorScheme == .light ? Color.Teal.teal1600 : Color.Teal.teal400)
                .frame(width: 56, height: 56) 
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colorScheme == .light ? Color.Gray.gray500 : Color.Teal.teal600, lineWidth: 1)
                )
        }
        .customTealShadow()
    }
}

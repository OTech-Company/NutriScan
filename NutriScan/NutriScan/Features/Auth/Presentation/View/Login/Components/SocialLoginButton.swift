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
    
    var body: some View {
        Button(action: action) {
            Image(iconName)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.LoginSemantic.socialButtonIcon)
                .frame(width: 56, height: 56) 
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.LoginSemantic.socialButtonBorder, lineWidth: 1)
                )
        }
        .customTealShadow()
    }
}

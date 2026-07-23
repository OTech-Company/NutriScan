//
//  AuthHeaderView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 15/07/2026.
//

import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
        VStack(spacing: 48) {
            Image("logo white")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 128)

            Text("Sign In")
                .font(Font.AppFont.title2)
                .foregroundColor(Color.LoginSemantic.headerTitle)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 36)
        .background(Color.LoginSemantic.headerBackground)
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 32,
                bottomTrailingRadius: 32
            )
        )
        .customTealShadow()
    }
}

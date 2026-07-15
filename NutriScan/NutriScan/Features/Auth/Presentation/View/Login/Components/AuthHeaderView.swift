//
//  AuthHeaderView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 15/07/2026.
//

import SwiftUI

struct AuthHeaderView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 44) {
            Image("logo white")
                .resizable()
                .scaledToFit()
                .frame(height: 32)
                .padding(.top, 108)

            Text("Sign In")
                .font(Font.AppFont.title2)
                .foregroundColor(Color.Teal.teal200)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 48)
        .padding(.top, 48)
        .background(Color.Teal.teal800)
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 24,
                bottomTrailingRadius: 24
            )
        )
        .customTealShadow()
    }
}

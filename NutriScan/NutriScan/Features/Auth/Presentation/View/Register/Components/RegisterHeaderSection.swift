//
//  RegisterHeaderSection.swift
//  NutriScan
//

import SwiftUI

struct RegisterHeaderSection: View {

    var body: some View {
        VStack(spacing: 48) {
            Image("logo white")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 128)

            Text("Sign Up For Free!")
                .font(Font.AppFont.title2)
                .foregroundColor(Color.RegisterSemantic.headerTitle)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 36)
        .background(Color.RegisterSemantic.headerBackground)
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 32,
                bottomTrailingRadius: 32
            )
        )
        .customTealShadow()
    }
}

#Preview("Light Mode") {
    RegisterHeaderSection()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    RegisterHeaderSection()
        .preferredColorScheme(.dark)
}

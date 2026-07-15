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
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 36)
        .background(Color.Teal.teal800)
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

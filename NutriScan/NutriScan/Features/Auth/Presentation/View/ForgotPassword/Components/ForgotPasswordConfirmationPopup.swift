//
//  ForgotPasswordConfirmationPopup.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 18/07/2026.
//

import SwiftUI

struct ForgotPasswordConfirmationPopup: View {
    @Environment(\.colorScheme) var colorScheme

    var recipient: String
    var onResend: () -> Void
    var onClose: () -> Void

    var body: some View {
        ZStack {
            // MARK: - Dimmed Background Overlay
            Color.Teal.teal1600.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            VStack(spacing: 0) {
                
                // MARK: - Popup Card
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: Illustration
                    Image(colorScheme == .light ? "forgot_pass_confirm" : "forgot_pass_confirm_dark")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.all, -26) 
                        .customTealShadow()
                    
                    // MARK: Title
                    Text("Password Sent!")
                        .font(Font.AppFont.title1)
                        .foregroundColor(Color.ForgotPasswordSemantic.confirmationTitle)
                        .padding(.top, 12)

                    // MARK: Subtitle
                    Text("We've sent the password to\n\(recipient)")
                        .font(Font.AppFont.textPrimary)
                        .foregroundColor(Color.ForgotPasswordSemantic.confirmationSubtitle)
                        .lineSpacing(4)
                        .padding(.top, 8)

                    // MARK: Resend Button
                    CustomPuffedButton(title: "Resend code", action: onResend)
                        .padding(.top, 20)
                 }
                .padding(16)
                .background(Color.ForgotPasswordSemantic.confirmationCardBackground)
                .cornerRadius(24)
                .padding(.horizontal, 24)

                // MARK: - Close Button
                Button(action: onClose) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .frame(width: 64, height: 64)
                            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)

                        Image(systemName: "xmark")
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.Teal.teal1000)
                    }
                }
                .padding(.top, 44)

            }
        }
    }
}

#Preview {
    ForgotPasswordConfirmationPopup(
        recipient: "elem*******221b@gmail.com",
        onResend: {},
        onClose: {}
    )
}

//
//  AccountRestorationActionsSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

struct AccountRestorationActionsSection: View {
    let isLoading: Bool
    var onRestore: () -> Void
    var onLogout: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            CustomPuffedButton(
                title: "Restore My Account",
                action: onRestore,
                isLoading: isLoading
            )
            .padding(.horizontal, 20)
            
            Button(action: onLogout) {
                HStack(spacing: 4) {
                    Text("Want to exit?")
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.AccountRestorationSemantic.instructionText)
                    
                    Text("Log Out")
                        .font(Font.AppFont.textSecondary)
                        .fontWeight(.bold)
                        .foregroundColor(Color.AccountRestorationSemantic.linkText)
                        .underline()
                }
            }
            .disabled(isLoading)
            .padding(.top, 8)
        }
    }
}

#Preview {
    AccountRestorationActionsSection(isLoading: false, onRestore: {}, onLogout: {})
}

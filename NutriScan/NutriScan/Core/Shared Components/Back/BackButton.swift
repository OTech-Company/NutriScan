//
//  BackButton.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//


import SwiftUI
 
// MARK: - 1. Back Button
struct BackButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.BackButtonSemantics.backButtonIcon)
                .frame(width: 48, height: 48)
                .background(Color.BackButtonSemantics.backButtonBackground)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color.BackButtonSemantics.backButtonBorder,
                            lineWidth: 1
                        )
                )
        }
    }
}

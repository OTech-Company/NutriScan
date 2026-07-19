//
//  SuccessDialog.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct SuccessDialog: View {
    let title: String
    let subtitle: String
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background dim
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Dialog container
            VStack(spacing: 24) {
                // Lottie animation view
                LottieView(jsonName: "Success")
                    .frame(width: 150, height: 150)
                    .padding(.top, 16)
                
                VStack(spacing: 8) {
                    Text(title)
                        .font(Font.AppFont.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                
                Button(action: onDismiss) {
                    Text("Continue")
                        .font(Font.AppFont.subtitle1)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.Teal.teal1000)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(.horizontal, 36)
        }
    }
}

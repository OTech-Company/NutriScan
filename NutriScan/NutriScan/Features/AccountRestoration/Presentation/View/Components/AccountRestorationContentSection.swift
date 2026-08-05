//
//  AccountRestorationContentSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

struct AccountRestorationContentSection: View {
    let daysRemaining: Int?
    let formattedDateString: String

    var body: some View {
        VStack(spacing: 32) {
            
            // Premium Glowing Icon Badge
            ZStack {
                Circle()
                    .fill(Color.AccountRestorationSemantic.iconCircleOuter)
                    .frame(width: 130, height: 130)
                
                Circle()
                    .fill(Color.AccountRestorationSemantic.iconCircleMiddle)
                    .frame(width: 105, height: 105)
                
                Circle()
                    .fill(Color.AccountRestorationSemantic.iconCircleInner)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.AccountRestorationSemantic.iconCircleInner.opacity(0.4), radius: 10, x: 0, y: 5)
                
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(Color.AccountRestorationSemantic.iconForeground)
            }
            .padding(.top, 40)
            
            // Instructions & Info Card
            VStack(spacing: 16) {
                Text("Account Deletion Pending")
                    .font(Font.AppFont.subtitle1)
                    .fontWeight(.bold)
                    .foregroundColor(Color.AccountRestorationSemantic.titleText)
                    .multilineTextAlignment(.center)
                
                Text("You can restore your account within the grace period to retain all your data and settings.")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.AccountRestorationSemantic.instructionText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .lineSpacing(4)
                
                // Info Card
                VStack(spacing: 12) {
                    if let days = daysRemaining {
                        HStack {
                            Text("Days remaining to restore:")
                                .font(Font.AppFont.textSecondary)
                                .foregroundColor(Color.AccountRestorationSemantic.instructionText)
                            Spacer()
                            Text("\(days) days")
                                .font(Font.AppFont.subtitle1)
                                .fontWeight(.bold)
                                .foregroundColor(Color.AccountRestorationSemantic.daysRemainingText)
                        }
                    }

                    if !formattedDateString.isEmpty {
                        HStack {
                            Text("Scheduled Deletion Date:")
                                .font(Font.AppFont.textSecondary)
                                .foregroundColor(Color.AccountRestorationSemantic.instructionText)
                            Spacer()
                            Text(formattedDateString)
                                .font(Font.AppFont.textSecondary)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.AccountRestorationSemantic.titleText)
                        }
                    }
                }
                .padding(16)
                .background(Color.AccountRestorationSemantic.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    AccountRestorationContentSection(daysRemaining: 14, formattedDateString: "Aug 18, 2026")
}

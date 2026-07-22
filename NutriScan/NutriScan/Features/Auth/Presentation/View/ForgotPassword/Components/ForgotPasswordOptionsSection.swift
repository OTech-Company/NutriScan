//
//  ForgotPasswordOptionsSection.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import SwiftUI

struct ForgotPasswordOptionsSection: View {
    @Bindable var viewModel: ForgotPasswordViewModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(PasswordResetOption.allCases) { option in
                let isSelected = viewModel.selectedOption == option
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        viewModel.selectedOption = option
                    }
                }) {
                    HStack(spacing: 16) {
                        // Icon Container
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isSelected ? Color.ForgotPasswordSemantic.iconContainerSelectedBackground : Color.ForgotPasswordSemantic.iconContainerBackground)
                                .frame(width: 64, height: 64)
                            
                            Image(option.iconName)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isSelected ? Color.ForgotPasswordSemantic.iconSelectedColor : Color.ForgotPasswordSemantic.iconColor)
                        }
                        
                        // Text Labels
                        VStack(alignment: .leading, spacing: 4) {
                            Text(option.title)
                                .font(Font.AppFont.plusJakartaSansMedium18)
                                .foregroundColor(isSelected ? Color.ForgotPasswordSemantic.optionTitleSelectedColor : Color.ForgotPasswordSemantic.optionTitleColor)
                            
                            Text(option.subtitle)
                                .font(Font.AppFont.lexendDecaLight12)
                                .foregroundColor(isSelected ? Color.ForgotPasswordSemantic.optionSubtitleSelectedColor : Color.ForgotPasswordSemantic.optionSubtitleColor)
                        }
                        
                        Spacer()
                        
                        // Trailing Arrow
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(isSelected ? Color.ForgotPasswordSemantic.arrowSelectedColor : Color.ForgotPasswordSemantic.arrowColor)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(isSelected ? Color.ForgotPasswordSemantic.optionSelectedBackground : Color.ForgotPasswordSemantic.optionBackground)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Color.ForgotPasswordSemantic.optionSelectedBorder : Color.ForgotPasswordSemantic.optionBorder, lineWidth: isSelected ? 1.5 : 1)
                    )
                    .shadow(color: Color.black.opacity(isSelected ? 0.06 : 0.02), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ForgotPasswordOptionsSection(viewModel: ForgotPasswordViewModel())
        .background(Color.Teal.teal100)
}

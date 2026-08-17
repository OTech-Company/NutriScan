//
//  CustomAlertCard.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

struct CustomAlertCard: View {
    let config: CustomAlertConfig
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    let actionsDisabled: Bool
    
    var showCard: Bool
    var showIcon: Bool
    var showButtons: Bool
    var reduceMotion: Bool

    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 0) {
                Spacer().frame(height: CustomAlertMetrics.topSpacerHeight)
                
                VStack(spacing: CustomAlertMetrics.titleBottomPadding) {
                    Text(config.title)
                        .font(Font.AppFont.subtitle2)
                        .foregroundColor(Color.CustomAlertSemantic.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .accessibilityAddTraits(.isHeader)
                        
                    Text(config.message)
                        .font(Font.AppFont.textCaption)
                        .foregroundColor(Color.CustomAlertSemantic.description)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, CustomAlertMetrics.horizontalPadding)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(config.title). \(config.message)")
                
                Spacer()
                
                HStack(spacing: CustomAlertMetrics.buttonSpacing) {
                    secondaryButton
                    primaryButton
                }
                .padding(.horizontal, CustomAlertMetrics.horizontalPadding)
                .padding(.bottom, CustomAlertMetrics.bottomPadding)
                .offset(y: reduceMotion || showButtons ? 0 : CustomAlertMetrics.buttonsInitialOffsetY)
                .opacity(reduceMotion || showButtons ? 1 : 0)
            }
            .frame(width: CustomAlertMetrics.cardWidth, height: CustomAlertMetrics.cardHeight)
            .background(Color.CustomAlertSemantic.background)
            .cornerRadius(CustomAlertMetrics.cardCornerRadius)
            .customAlertShadow()
            .scaleEffect(reduceMotion || showCard ? 1 : CustomAlertMetrics.cardInitialScale)
            .offset(y: reduceMotion || showCard ? 0 : CustomAlertMetrics.cardInitialOffsetY)
            .opacity(reduceMotion || showCard ? 1 : 0)
            
            ZStack {
                RoundedRectangle(cornerRadius: CustomAlertMetrics.iconBadgeCornerRadius)
                    .fill(config.type.iconColor)
                    .frame(width: CustomAlertMetrics.iconBadgeSize, height: CustomAlertMetrics.iconBadgeSize)
                
                Image(config.type.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: CustomAlertMetrics.iconSize, height: CustomAlertMetrics.iconSize)
                    .foregroundColor(.white)
            }
            .accessibilityHidden(true)
            .offset(y: CustomAlertMetrics.iconVerticalOffset)
            .rotationEffect(.degrees(reduceMotion || showIcon ? 0 : CustomAlertMetrics.iconInitialRotation))
            .scaleEffect(reduceMotion || showIcon ? 1 : CustomAlertMetrics.iconInitialScale)
            .opacity(reduceMotion || showIcon ? 1 : 0)
        }
        .padding(.top, CustomAlertMetrics.outerTopPadding)
    }

    private var primaryButton: some View {
        alertButton(config.primaryButton, action: primaryAction)
            .accessibilityHint(config.primaryButton.role == .destructive ? "Destructive action" : "")
    }

    @ViewBuilder
    private var secondaryButton: some View {
        if let button = config.secondaryButton, let secondaryAction {
            alertButton(button, action: secondaryAction)
        }
    }

    private func alertButton(_ button: CustomAlertButton, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(button.title)
                .font(Font.AppFont.textCaption)
                .foregroundColor(button.role.foregroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: CustomAlertMetrics.buttonHeight)
        .background(button.role.backgroundColor)
        .cornerRadius(CustomAlertMetrics.buttonCornerRadius)
        .disabled(actionsDisabled)
        .accessibilityLabel(button.title)
    }
}

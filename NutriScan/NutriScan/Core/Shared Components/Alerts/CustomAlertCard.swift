//
//  CustomAlertCard.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

struct CustomAlertCard: View {
    let type: CustomAlertType
    let title: String
    let description: String
    let primaryButtonTitle: String
    let primaryButtonColor: Color
    let primaryAction: () -> Void
    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?
    
    var showCard: Bool
    var showIcon: Bool
    var showButtons: Bool
    var reduceMotion: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 0) {
                Spacer().frame(height: CustomAlertMetrics.topSpacerHeight)
                
                VStack(spacing: CustomAlertMetrics.titleBottomPadding) {
                    Text(title)
                        .font(Font.AppFont.subtitle2)
                        .foregroundColor(Color.CustomAlertSemantic.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .accessibilityAddTraits(.isHeader)
                        
                    Text(description)
                        .font(Font.AppFont.textCaption)
                        .foregroundColor(Color.CustomAlertSemantic.description)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, CustomAlertMetrics.horizontalPadding)
                .accessibilityElement(children: .combine)
                
                Spacer()
                
                HStack(spacing: CustomAlertMetrics.buttonSpacing) {
                    if let secondaryTitle = secondaryButtonTitle {
                        Button(action: secondaryAction ?? {}) {
                            Text(secondaryTitle)
                                .font(Font.AppFont.textCaption)
                                .foregroundColor(Color.CustomAlertSemantic.secondaryButtonText)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(height: CustomAlertMetrics.buttonHeight)
                        .background(Color.CustomAlertSemantic.secondaryButtonBackground)
                        .cornerRadius(CustomAlertMetrics.buttonCornerRadius)
                        .accessibilityLabel(secondaryTitle)
                        .accessibilityAddTraits(.isButton)
                    }
                    
                    Button(action: primaryAction) {
                        Text(primaryButtonTitle)
                            .font(Font.AppFont.textCaption)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: CustomAlertMetrics.buttonHeight)
                    .background(primaryButtonColor)
                    .cornerRadius(CustomAlertMetrics.buttonCornerRadius)
                    .accessibilityLabel(primaryButtonTitle)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(type == .delete ? "Destructive action" : "")
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
                    .fill(type.iconColor)
                    .frame(width: CustomAlertMetrics.iconBadgeSize, height: CustomAlertMetrics.iconBadgeSize)
                
                Image(type.iconName)
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
}

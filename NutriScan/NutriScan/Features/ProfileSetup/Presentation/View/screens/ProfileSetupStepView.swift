//
//  ProfileSetupStepView.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//

import SwiftUI

struct ProfileSetupStepView<Content: View>: View {
    let currentStep: Int
    let totalSteps: Int
    let titleSegments: [TitleSegment]
    let subtitle: String
    let onBack: () -> Void
    let onNext: () -> Void

    var showBackButton: Bool = true
    var showHeader: Bool = true

    @ViewBuilder let content: () -> Content

    private enum Layout {
        static var horizontalPadding: CGFloat { 22 }
        static var backButtonTopPadding: CGFloat { 12 }
        static var backButtonSize: CGFloat { 48 }
        static var headerTopSpacing: CGFloat { 80 }
        static var headerInternalSpacing: CGFloat { 8 }
        static var nextButtonBottomPadding: CGFloat { 42 }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if showBackButton {
                    BackButton(action: onBack)
                }
                Spacer()
            }
            .frame(height: Layout.backButtonSize)
            .padding(.top, Layout.backButtonTopPadding)

            if showHeader {
                VStack(spacing: Layout.headerInternalSpacing) {
                    StepProgressText(current: currentStep, total: totalSteps)
                    TitleBlock(segments: titleSegments, subtitle: subtitle)
                }
                .padding(.top, Layout.headerTopSpacing)
            }

            Spacer(minLength: 0)
            content()
            Spacer(minLength: 0)

            ProgressNextButton(currentStep: currentStep, totalSteps: totalSteps) {
                onNext()
            }
            .padding(.bottom, Layout.nextButtonBottomPadding)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .background(
            Color.ProfileSetupSemantic.background
                .ignoresSafeArea()
        )
    }
}

//
//  ProfileSetupStepView.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//
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

    var body: some View {
        VStack(spacing: 28) {
            if showBackButton {
                HStack {
                    BackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 20)
            }

            if showHeader {
                StepProgressText(current: currentStep, total: totalSteps)

                TitleBlock(
                    segments: titleSegments,
                    subtitle: subtitle
                )
            }
            content()

            Spacer()

            if showHeader {
                ProgressNextButton(currentStep: currentStep, totalSteps: totalSteps) {
                    onNext()
                }
                .padding(.bottom, 30)
            }
        }
        .padding(.top, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.ProfileSetupSemantic.background
                .ignoresSafeArea()
        )
    }
}

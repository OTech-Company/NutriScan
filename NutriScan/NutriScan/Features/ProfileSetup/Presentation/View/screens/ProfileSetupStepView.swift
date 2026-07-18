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
        VStack(spacing: 0) {
            // 1. Fixed Top Navigation Row
            ZStack {
                if showBackButton {
                    HStack {
                        BackButton(action: onBack)
                        Spacer()
                    }
                }
                Text("")
            }
            .frame(height: 48)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            // 2. Main Header Text Blocks
            if showHeader {
                Spacer(minLength: 80)
                
                StepProgressText(current: currentStep, total: totalSteps)
//                Spacer(minLength: 8)
                TitleBlock(
                    segments: titleSegments,
                    subtitle: subtitle
                )
            }
            
            switch currentStep {
            case 3:
                Spacer(minLength: 42)
            default:
                Spacer(minLength: 80)
            }
            
            // 3. Dynamic Center Component Layer (Pushed entirely outside header logic)
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 4. Dynamic Spacing Layout based on the Step
            switch currentStep {
            case 1:
                Spacer(minLength: 102)
            case 2:
                Spacer(minLength: 132)
            case 3:
                Spacer(minLength: 63)
            case 4:
                Spacer(minLength: 53)
            default:
                Spacer()
            }
            
            // 5. Fixed Next Button Row
            ProgressNextButton(currentStep: currentStep, totalSteps: totalSteps) {
                onNext()
            }
            .padding(.bottom, 42)
        }
        .background(
            Color.ProfileSetupSemantic.background
                .ignoresSafeArea()
        )
    }
}

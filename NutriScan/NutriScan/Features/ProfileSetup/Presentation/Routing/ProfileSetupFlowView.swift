//
//  ProfileSetupFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//
//
//  ProfileSetupFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

/// Single screen for the whole profile-setup wizard. Steps are NOT
/// separate navigation destinations — `currentStep` drives which
/// content is shown, and we animate the swap in place. This avoids
/// pushing a new screen (and duplicating title/subtitle/progress
/// chrome) for every step.
struct ProfileSetupFlowView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var currentStep: ProfileSetupStep = .gender

    // Answers collected across steps. Add more as needed.
    @State private var gender: Gender = .female
    @State private var birthdate: Date = Date()
    @State private var weight: Int = 60
    @State private var height: Int = 170

    var body: some View {
        ProfileSetupStepView(
            currentStep: currentStep.stepNumber,
            totalSteps: ProfileSetupStep.totalSteps ,
            titleSegments: currentStep.titleSegments,
            subtitle: currentStep.subtitle,
            onBack: goBack,
            onNext: goNext,
            showBackButton: currentStep != ProfileSetupStep.allCases.first,
            showHeader: currentStep != .healthProfile
        ) {
            stepContent
                 .id(currentStep)
                 .transition(.opacity)
                 .animation(.easeInOut(duration: 0.25), value: currentStep)
         
        }
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case .gender:
            GenderSelectionRow(selectedGender: $gender)

        case .birthdate:
            // TODO: plug in your existing birthdate picker content here,
            // bound to `$birthdate`.
            Text("Birthdate content goes here")

        case .weight:
            VStack(spacing: 40) {
                ValueCard(value: weight, style: .plain)
                RulerDial(value: $weight, unit: .weight)
            }

        case .height:
            VStack(spacing: 40) {
                ValueCard(value: height, style: .boxed)
                RulerDial(value: $height, unit: .height)
            }

        case .healthProfile:
            // TODO: plug in your existing health profile content here.
            VStack(spacing: 40) {
                HealthProfileSetupView()
            }
        }
    }

    private func goNext() {
        if let next = ProfileSetupStep(rawValue: currentStep.rawValue + 1) {
            currentStep = next
        } else {
            // Last step completed — hand off to whatever comes after
            // profile setup (e.g. router.push(SomeRoute) or dismiss).
        }
    }

    private func goBack() {
        if let previous = ProfileSetupStep(rawValue: currentStep.rawValue - 1) {
            currentStep = previous
        } else {
            router.pop() // first step's back button exits the whole flow
        }
    }
}

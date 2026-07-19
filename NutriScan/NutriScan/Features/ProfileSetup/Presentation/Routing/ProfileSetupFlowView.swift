//
//  ProfileSetupFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct ProfileSetupFlowView: View {
    @StateObject private var router = AppRouter()
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var viewModel = ProfileSetupFlowViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            ProfileSetupStepView(
                currentStep: viewModel.currentStepIndex,
                totalSteps: viewModel.totalSteps,
                titleSegments: viewModel.currentStep.titleSegments,
                subtitle: viewModel.currentStep.subtitle,
                onBack: handleBack,
                onNext: handleNext
            ) {
                centerContent
            }
            .appProfileSetupBackground()
            .animation(.easeInOut(duration: 0.25), value: viewModel.currentStep)
            .navigationDestination(for: AnyRoute.self) { route in
                route.view()
            }
            .navigationBarHidden(true)
        }
        .environmentObject(router)
    }

    @ViewBuilder
    private var centerContent: some View {
        switch viewModel.currentStep {
        case .gender:
            GenderSelectionRow(selectedGender: $viewModel.selectedGender)
        case .birthdate:
            BirthdateSelectionView(birthdate: $viewModel.birthdate)
        case .weight:
            WeightSelectionView(weight: $viewModel.weight)
        case .height:
            HeightSelectionView(height: $viewModel.height)
        case .healthProfile:
            EmptyView() // handled by a separate screen
        }
    }

    private func handleBack() {
        if viewModel.isFirstStep {
            flowCoordinator.logout() // or another way to exit the flow if needed. Wait, flowCoordinator.flow = .splash/onboarding? For now we just pop if there's an outer stack, but since this is the root of the flow, pop won't work on router if it's empty. Let's see what happens.
        } else {
            viewModel.goBack()
        }
    }

    private func handleNext() {
        if viewModel.currentStep == .height {
            // Push health profile route
            router.push(ProfileSetupRoute.healthProfile)
        } else {
            viewModel.goNext()
        }
    }
}

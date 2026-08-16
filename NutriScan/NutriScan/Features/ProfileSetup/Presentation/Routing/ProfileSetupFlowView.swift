//
//  ProfileSetupFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

struct ProfileSetupFlowView: View {
    private enum AlertDestination: String, Identifiable {
        case invalidAge
        var id: String { rawValue }
    }

    @StateObject private var router = AppRouter()
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var viewModel = ProfileSetupFlowFactory.makeViewModel()
    @State private var alert: AlertDestination?

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
        .customAlert(item: $alert, config: { _ in
            CustomAlertConfig(
                    type: .error,
                    title: "Invalid Age",
                    message: "Your age must be at least 6 years."
                )
        }, primaryAction: { _ in })
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
        if viewModel.currentStep == .birthdate {
            let ageComponents = Calendar.current.dateComponents([.year], from: viewModel.birthdate, to: Date())
            let age = ageComponents.year ?? 0
            if age < 6 {
                alert = .invalidAge
                return
            }
        }
        
        if viewModel.currentStep == .height {
            // Push health profile route
            router.push(ProfileSetupRoute.healthProfile(viewModel))
        } else {
            viewModel.goNext()
        }
    }
}

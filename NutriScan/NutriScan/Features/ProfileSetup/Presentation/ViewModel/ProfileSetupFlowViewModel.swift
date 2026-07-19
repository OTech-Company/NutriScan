//
//  ProfileSetupFlowViewModel.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/07/2026.
//

import Foundation
import Observation

@Observable
final class ProfileSetupFlowViewModel {

    var currentStep: ProfileSetupStep = .gender

    var selectedGender: Gender = .male
    var birthdate: Date = Calendar.current.date(byAdding: .year, value: -23, to: Date()) ?? Date()
    var weight: Int = 60
    var height: Int = 183

    var currentStepIndex: Int { currentStep.stepNumber }
    var totalSteps: Int { ProfileSetupStep.totalSteps }
    var isFirstStep: Bool { currentStep == .gender }

    func goNext() {
        guard let next = ProfileSetupStep(rawValue: currentStep.rawValue + 1) else { return }
        currentStep = next
    }

    func goBack() {
        guard let previous = ProfileSetupStep(rawValue: currentStep.rawValue - 1) else { return }
        currentStep = previous
    }

    // TODO: persist gender/birthdate/weight/height via ProfileUseCase once backend integration lands
}

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

    private let updateProfileUseCase: ProfileSetupUpdateUseCaseProtocol
    private let fetchOptionsUseCase: FetchProfileSetupOptionsUseCaseProtocol

    var currentStep: ProfileSetupStep = .gender

    var selectedGender: ProfileSetupGender = .male
    var birthdate: Date = Calendar.current.date(byAdding: .year, value: -23, to: Date()) ?? Date()
    var weight: Int = 60
    var height: Int = 183

    var allConditions: [ProfileSetupDiseaseOption] = []
    var allAllergies: [ProfileSetupAllergyOption] = []
    
    var selectedConditions: Set<ProfileSetupDiseaseOption> = []
    var selectedAllergies: Set<ProfileSetupAllergyOption> = []
    
    var isSaving: Bool = false
    var saveError: String? = nil
    
    var isLoadingOptions: Bool = false
    var loadOptionsError: String? = nil

    init(updateProfileUseCase: ProfileSetupUpdateUseCaseProtocol, fetchOptionsUseCase: FetchProfileSetupOptionsUseCaseProtocol) {
        self.updateProfileUseCase = updateProfileUseCase
        self.fetchOptionsUseCase = fetchOptionsUseCase
    }

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

    func toggleCondition(_ condition: ProfileSetupDiseaseOption) {
        if selectedConditions.contains(condition) {
            selectedConditions.remove(condition)
        } else {
            selectedConditions.insert(condition)
        }
    }

    func toggleAllergy(_ allergy: ProfileSetupAllergyOption) {
        if selectedAllergies.contains(allergy) {
            selectedAllergies.remove(allergy)
        } else {
            selectedAllergies.insert(allergy)
        }
    }

    @MainActor
    func loadHealthProfileOptions() async {
        guard allConditions.isEmpty || allAllergies.isEmpty else { return }
        isLoadingOptions = true
        loadOptionsError = nil
        do {
            let options = try await fetchOptionsUseCase.execute()
            allAllergies = options.allergies
            allConditions = options.diseases
        } catch {
            loadOptionsError = error.localizedDescription
        }
        isLoadingOptions = false
    }

    @MainActor
    func saveProfile() async -> Bool {
        isSaving = true
        saveError = nil
        let update = ProfileSetupUpdate(
            firstName: nil,
            lastName: nil,
            dateOfBirth: birthdate,
            gender: selectedGender,
            heightCm: height,
            weightKg: weight,
            allergyIds: selectedAllergies.map(\.id),
            diseaseIds: selectedConditions.map(\.id)
        )
        do {
            _ = try await updateProfileUseCase.execute(update)
            isSaving = false
            return true
        } catch {
            saveError = error.localizedDescription
            isSaving = false
            return false
        }
    }
}

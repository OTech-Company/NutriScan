//
//  EditProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//

import Combine
import SwiftUI

@Observable
final class EditProfileViewModel {
    
    // MARK: - Dependencies
    private let useCase: ProfileUseCaseProtocol
    
    // MARK: - Validated Fields
    var firstName = ValidatedField(value: "")
    var lastName = ValidatedField(value: "")
    var height = ValidatedField(value: "")
    var weight = ValidatedField(value: "")
    
    // MARK: - Display Only
    var email: String = ""
    var birthdate: Date = Date()
    var gender: String = "FEMALE"

    // MARK: - Data Sources (UI Presentation)
    var allAllergies: [String] = []
    var allConditions: [String] = []

    // MARK: - Chip States
    var conditionChips: [ProfileChipItem] = []
    var allergyChips: [ProfileChipItem] = []

    // MARK: - Bottom Sheet States
    var showConditionSearchSheet = false
    var showAllergySearchSheet = false

    var conditionSearchQuery = ""
    var allergySearchQuery = ""

    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Backend Caches (Domain Entities)
    private var availableAllergies: [ReferenceItem] = []
    private var availableDiseases: [ReferenceItem] = []

    init(useCase: ProfileUseCaseProtocol = DIContainer.shared.resolve(type: ProfileUseCaseProtocol.self)) {
        self.useCase = useCase
    }
    
    // MARK: - Networking: Load Data
    @MainActor
    func loadInitialData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let data = try await useCase.getEditProfileData()
            
            self.availableAllergies = data.allergies
            self.availableDiseases = data.diseases
            
            self.allAllergies = data.allergies.map { $0.name }
            self.allConditions = data.diseases.map { $0.name }
            
            self.email = data.profile.email
            self.firstName.value = data.profile.firstName
            self.lastName.value = data.profile.lastName
            
            if let h = data.profile.heightCm { self.height.value = String(Int(h)) }
            if let w = data.profile.weightKg { self.weight.value = String(Int(w)) }
            if let g = data.profile.gender { self.gender = g }
            if let dob = data.profile.dateOfBirth { self.birthdate = dob }
            
            // Map backend items to togglable ProfileChipItems
            self.allergyChips = data.profile.allergies.map {
                ProfileChipItem(name: $0.name, isSelected: true, isNewlyAdded: false)
            }
            self.conditionChips = data.profile.diseases.map {
                ProfileChipItem(name: $0.name, isSelected: true, isNewlyAdded: false)
            }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    // MARK: - Networking: Save Data
    @MainActor
    func validateAndSave() async {
        let isFirstNameValid = firstName.validate(using: AppValidator.displayNameValidator)
        let isLastNameValid = lastName.validate(using: AppValidator.displayNameValidator)
        let isHeightValid = height.validate(using: AppValidator.heightValidator)
        let isWeightValid = weight.validate(using: AppValidator.weightValidator)
        
        guard isFirstNameValid, isLastNameValid, isHeightValid, isWeightValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Only map IDs for chips that are actively selected
        let mappedAllergyIds = allergyChips.filter { $0.isSelected }.compactMap { chip in
            availableAllergies.first(where: { $0.name == chip.name })?.id
        }
        
        let mappedDiseaseIds = conditionChips.filter { $0.isSelected }.compactMap { chip in
            availableDiseases.first(where: { $0.name == chip.name })?.id
        }
        
        let updateRequest = ProfileUpdate(
            firstName: firstName.value,
            lastName: lastName.value,
            dateOfBirth: birthdate,
            gender: gender,
            heightCm: Double(height.value) ?? 0,
            weightKg: Double(weight.value) ?? 0,
            allergyIds: mappedAllergyIds,
            diseaseIds: mappedDiseaseIds
        )
        
        do {
            print(updateRequest)
            _ = try await useCase.updateProfile(update: updateRequest)
            
            // SUCCESS: Trigger GET Profile to refresh the UI.
            // This will lock in newly added chips and drop toggled-off ones.
            await loadInitialData()
            
            print("Profile saved and refreshed successfully!")
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    // MARK: - Computed Filtered Results
    var filteredConditions: [String] {
        let activeNames = Set(conditionChips.map { $0.name })
        let unselected = allConditions.filter { !activeNames.contains($0) }
        
        if conditionSearchQuery.isEmpty { return unselected }
        return unselected.filter { $0.localizedCaseInsensitiveContains(conditionSearchQuery) }
    }
    
    var filteredAllergies: [String] {
        let activeNames = Set(allergyChips.map { $0.name })
        let unselected = allAllergies.filter { !activeNames.contains($0) }
        
        if allergySearchQuery.isEmpty { return unselected }
        return unselected.filter { $0.localizedCaseInsensitiveContains(allergySearchQuery) }
    }

    // MARK: - Actions: Conditions
    func selectCondition(_ condition: String) {
        if !conditionChips.contains(where: { $0.name == condition }) {
            conditionChips.append(ProfileChipItem(name: condition, isSelected: true, isNewlyAdded: true))
        }
        conditionSearchQuery = ""
        showConditionSearchSheet = false
    }
    
    func toggleCondition(_ condition: String) {
        if let index = conditionChips.firstIndex(where: { $0.name == condition }) {
            conditionChips[index].isSelected.toggle()
        }
    }

    func removeCondition(_ condition: String) {
        conditionChips.removeAll(where: { $0.name == condition && $0.isNewlyAdded })
    }

    // MARK: - Actions: Allergies
    func selectAllergy(_ allergy: String) {
        if !allergyChips.contains(where: { $0.name == allergy }) {
            allergyChips.append(ProfileChipItem(name: allergy, isSelected: true, isNewlyAdded: true))
        }
        allergySearchQuery = ""
        showAllergySearchSheet = false
    }
    
    func toggleAllergy(_ allergy: String) {
        if let index = allergyChips.firstIndex(where: { $0.name == allergy }) {
            allergyChips[index].isSelected.toggle()
        }
    }

    func removeAllergy(_ allergy: String) {
        allergyChips.removeAll(where: { $0.name == allergy && $0.isNewlyAdded })
    }
}

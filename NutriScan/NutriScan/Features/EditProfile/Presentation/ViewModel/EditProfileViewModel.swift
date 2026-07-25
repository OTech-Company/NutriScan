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
    private let getProfileDataUseCase: GetEditProfileUseCaseProtocol
    private let updateProfileUseCase: UpdateEditProfileUseCaseProtocol

    // MARK: - Validated Fields
    var firstName = ValidatedField(value: "")
    var lastName = ValidatedField(value: "")
    var height = ValidatedField(value: "")
    var weight = ValidatedField(value: "")

    // MARK: - Display Only
    var email: String = ""
    var birthdate: Date = Date()
    var gender: String = "FEMALE"

    var conditions = ChipSelectionManager()
    var allergies = ChipSelectionManager()

    // MARK: - Status
    var isLoading = false
    var errorMessage: String?

    // MARK: - Dirty-Check Baseline
    private var snapshot: ProfileUpdate?
    private var revertAction: (() -> Void)?

    init(
        getProfileDataUseCase: GetEditProfileUseCaseProtocol = DIContainer.shared.resolve(type: GetEditProfileUseCaseProtocol.self),
        updateProfileUseCase: UpdateEditProfileUseCaseProtocol = DIContainer.shared.resolve(type: UpdateEditProfileUseCaseProtocol.self)
    ) {
        self.getProfileDataUseCase = getProfileDataUseCase
        self.updateProfileUseCase = updateProfileUseCase
    }

    // MARK: - Networking: Load Data

    @MainActor
    func loadInitialData() async {
        isLoading = true
        errorMessage = nil

        do {
            let data = try await getProfileDataUseCase.execute()

            self.email = data.profile.email
            self.firstName.value = data.profile.firstName
            self.lastName.value = data.profile.lastName

            if let h = data.profile.heightCm { self.height.value = String(Int(h)) } else { self.height.value = "" }
            if let w = data.profile.weightKg { self.weight.value = String(Int(w)) } else { self.weight.value = "" }
            if let g = data.profile.gender { self.gender = g }
            if let dob = data.profile.dateOfBirth { self.birthdate = dob }

            conditions.configure(availableItems: data.diseases, existingSelections: data.profile.diseases)
            allergies.configure(availableItems: data.allergies, existingSelections: data.profile.allergies)

            captureSnapshot()
            
            // Capture local revert closure to avoid network call on discard
            let origEmail = data.profile.email
            let origFirstName = data.profile.firstName
            let origLastName = data.profile.lastName
            let origHeightCm = data.profile.heightCm
            let origWeightKg = data.profile.weightKg
            let origGender = data.profile.gender
            let origDOB = data.profile.dateOfBirth
            let availDiseases = data.diseases
            let existDiseases = data.profile.diseases
            let availAllergies = data.allergies
            let existAllergies = data.profile.allergies
            
            self.revertAction = { [weak self] in
                guard let self = self else { return }
                self.email = origEmail
                self.firstName.value = origFirstName
                self.lastName.value = origLastName
                if let h = origHeightCm { self.height.value = String(Int(h)) } else { self.height.value = "" }
                if let w = origWeightKg { self.weight.value = String(Int(w)) } else { self.weight.value = "" }
                if let g = origGender { self.gender = g }
                if let dob = origDOB { self.birthdate = dob }
                self.conditions.configure(availableItems: availDiseases, existingSelections: existDiseases)
                self.allergies.configure(availableItems: availAllergies, existingSelections: existAllergies)
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Dirty Checking & Reverting

    private func captureSnapshot() {
        snapshot = buildUpdateRequest()
    }
    
    func revertChanges() {
        revertAction?()
        captureSnapshot()
        errorMessage = nil
    }

    /// Builds the exact ProfileUpdate that would be sent to the backend,
    /// from current field/chip state. Single source of truth used both
    /// for the real Save request and as the dirty-check comparison target.
    private func buildUpdateRequest() -> ProfileUpdate {
        ProfileUpdate(
            firstName: firstName.value,
            lastName: lastName.value,
            dateOfBirth: birthdate,
            gender: gender,
            heightCm: Double(height.value) ?? 0,
            weightKg: Double(weight.value) ?? 0,
            allergyIds: allergies.selectedIds,
            diseaseIds: conditions.selectedIds
        )
    }

    /// True if current form state differs from the last loaded/saved snapshot.
    var hasUnsavedChanges: Bool {
        guard let snapshot else { return false }
        let current = buildUpdateRequest()

        return snapshot.firstName != current.firstName
            || snapshot.lastName != current.lastName
            || snapshot.dateOfBirth != current.dateOfBirth
            || snapshot.gender != current.gender
            || snapshot.heightCm != current.heightCm
            || snapshot.weightKg != current.weightKg
            || snapshot.allergyIds != current.allergyIds
            || snapshot.diseaseIds != current.diseaseIds
    }

    func validateFields() -> Bool {
        let isFirstNameValid = firstName.validate(using: AppValidator.displayNameValidator)
        let isLastNameValid = lastName.validate(using: AppValidator.displayNameValidator)
        let isHeightValid = height.validate(using: AppValidator.heightValidator)
        let isWeightValid = weight.validate(using: AppValidator.weightValidator)
        return isFirstNameValid && isLastNameValid && isHeightValid && isWeightValid
    }

    // MARK: - Networking: Save Data

    @MainActor
    func performSave() async {
        isLoading = true
        errorMessage = nil

        do {
            _ = try await updateProfileUseCase.execute(update: buildUpdateRequest())
            await loadInitialData() // also re-captures snapshot and stops loading
            print("Profile saved and refreshed successfully!")
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

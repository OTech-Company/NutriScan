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

    // MARK: - Chip Collections (delegated, not duplicated)
    var conditions = ChipSelectionManager()
    var allergies = ChipSelectionManager()

    // MARK: - Status
    var isLoading = false
    var errorMessage: String?

    // MARK: - Dirty-Check Baseline
    private var snapshot: ProfileUpdate?

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

            self.email = data.profile.email
            self.firstName.value = data.profile.firstName
            self.lastName.value = data.profile.lastName

            if let h = data.profile.heightCm { self.height.value = String(Int(h)) }
            if let w = data.profile.weightKg { self.weight.value = String(Int(w)) }
            if let g = data.profile.gender { self.gender = g }
            if let dob = data.profile.dateOfBirth { self.birthdate = dob }

            conditions.configure(availableItems: data.diseases, existingSelections: data.profile.diseases)
            allergies.configure(availableItems: data.allergies, existingSelections: data.profile.allergies)

            captureSnapshot()

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Dirty Checking

    private func captureSnapshot() {
        snapshot = buildUpdateRequest()
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

    // MARK: - Networking: Save Data

    @MainActor
    func validateAndSave() async {
        guard validateFields() else { return }

        guard hasUnsavedChanges else {
            print("No changes detected — skipping network call.")
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            _ = try await useCase.updateProfile(update: buildUpdateRequest())
            await loadInitialData() // also re-captures snapshot
            print("Profile saved and refreshed successfully!")
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func validateFields() -> Bool {
        let isFirstNameValid = firstName.validate(using: AppValidator.displayNameValidator)
        let isLastNameValid = lastName.validate(using: AppValidator.displayNameValidator)
        let isHeightValid = height.validate(using: AppValidator.heightValidator)
        let isWeightValid = weight.validate(using: AppValidator.weightValidator)
        return isFirstNameValid && isLastNameValid && isHeightValid && isWeightValid
    }
}

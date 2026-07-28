//
//  EditProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//

import Combine
import PhotosUI
import SwiftUI

@Observable
final class EditProfileViewModel {

    // MARK: - Dependencies
    private let observeProfileUseCase: ObserveProfileUseCaseProtocol
    private let updateProfileUseCase: UpdateProfileUseCaseProtocol
    private let getReferenceDataUseCase: GetReferenceDataUseCaseProtocol

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

    // MARK: - Avatar Selection State
    var selectedPhotoItem: PhotosPickerItem? = nil {
        didSet {
            Task { await loadSelectedImage() }
        }
    }
    var avatarData: Data? = nil
    var avatarUIImage: UIImage? = nil

    // MARK: - Status
    var isLoading = false
    var errorMessage: String?

    // MARK: - Dirty-Check Baseline
    private var snapshot: ProfileUpdate?
    private var revertAction: (() -> Void)?

    init(
        observeProfileUseCase: ObserveProfileUseCaseProtocol = DIContainer.shared.resolve(type: ObserveProfileUseCaseProtocol.self),
        updateProfileUseCase: UpdateProfileUseCaseProtocol = DIContainer.shared.resolve(type: UpdateProfileUseCaseProtocol.self),
        getReferenceDataUseCase: GetReferenceDataUseCaseProtocol = DIContainer.shared.resolve(type: GetReferenceDataUseCaseProtocol.self)
    ) {
        self.observeProfileUseCase = observeProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.getReferenceDataUseCase = getReferenceDataUseCase
        
        // Populate fields immediately upon initialization
        populateFromStore()
    }

    // MARK: - Instant Population
    private func populateFromStore() {
        guard let profile = observeProfileUseCase.execute().currentProfile else { return }
        
        self.email = profile.email
        self.firstName.value = profile.firstName
        self.lastName.value = profile.lastName

        if let h = profile.heightCm { self.height.value = String(Int(h)) } else { self.height.value = "" }
        if let w = profile.weightKg { self.weight.value = String(Int(w)) } else { self.weight.value = "" }
        if let g = profile.gender { self.gender = g }
        if let dob = profile.dateOfBirth { self.birthdate = dob }

        conditions.configure(availableItems: profile.diseases, existingSelections: profile.diseases)
        allergies.configure(availableItems: profile.allergies, existingSelections: profile.allergies)

        captureSnapshot()
        setupRevertAction(from: profile)
    }

    private func setupRevertAction(from profile: ProfileInfo) {
        let origEmail = profile.email
        let origFirstName = profile.firstName
        let origLastName = profile.lastName
        let origHeightCm = profile.heightCm
        let origWeightKg = profile.weightKg
        let origGender = profile.gender
        let origDOB = profile.dateOfBirth
        let existDiseases = profile.diseases
        let existAllergies = profile.allergies
        let origImage = self.avatarUIImage
        
        self.revertAction = { [weak self] in
            guard let self = self else { return }
            self.email = origEmail
            self.firstName.value = origFirstName
            self.lastName.value = origLastName
            if let h = origHeightCm { self.height.value = String(Int(h)) } else { self.height.value = "" }
            if let w = origWeightKg { self.weight.value = String(Int(w)) } else { self.weight.value = "" }
            if let g = origGender { self.gender = g }
            if let dob = origDOB { self.birthdate = dob }
            
            self.avatarUIImage = origImage
            self.avatarData = nil
            self.selectedPhotoItem = nil
            
            self.conditions.configure(availableItems: self.conditions.availableItems, existingSelections: existDiseases)
            self.allergies.configure(availableItems: self.allergies.availableItems, existingSelections: existAllergies)
            
            self.firstName.state = .normal
            self.lastName.state = .normal
            self.height.state = .normal
            self.weight.state = .normal
        }
    }

    // MARK: - Image Selection Loader
    @MainActor
    private func loadSelectedImage() async {
        guard let item = selectedPhotoItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                self.avatarData = data
                self.avatarUIImage = UIImage(data: data)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // MARK: - Networking: Load Reference Data
    @MainActor
    func loadReferenceData() async {
        do {
            let refData = try await getReferenceDataUseCase.execute()
            guard let profile = observeProfileUseCase.execute().currentProfile else { return }
            
            self.conditions.configure(availableItems: refData.diseases, existingSelections: profile.diseases)
            self.allergies.configure(availableItems: refData.allergies, existingSelections: profile.allergies)
        } catch {
            self.errorMessage = error.localizedDescription
        }
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
            || avatarData != nil
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
            try await updateProfileUseCase.execute(update: buildUpdateRequest())
            // Reset temporary image data states after successful sync
            self.avatarData = nil
            self.selectedPhotoItem = nil
            populateFromStore()
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

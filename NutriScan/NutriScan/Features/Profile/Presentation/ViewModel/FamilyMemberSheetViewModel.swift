//
//  FamilyMemberSheetViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//


import Foundation

@Observable
final class FamilyMemberSheetViewModel {
    let existingMember: FamilyMember?

    var name = ValidatedField(value: "")
    var relation = ValidatedField(value: "")

    var conditions = ChipSelectionManager()
    var allergies = ChipSelectionManager()

    var isLoading = false
    var errorMessage: String?

    private let getReferenceDataUseCase: GetEditProfileUseCaseProtocol
    private let updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol

    var isEditMode: Bool { existingMember != nil }

    init(
        existingMember: FamilyMember?,
        getReferenceDataUseCase: GetEditProfileUseCaseProtocol = DIContainer.shared.resolve(type: GetEditProfileUseCaseProtocol.self),
        updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol = DIContainer.shared.resolve(type: UpdateFamilyMembersUseCaseProtocol.self)
    ) {
        self.existingMember = existingMember
        self.getReferenceDataUseCase = getReferenceDataUseCase
        self.updateFamilyMembersUseCase = updateFamilyMembersUseCase

        if let member = existingMember {
            name.value = member.name
            relation.value = member.relation
        }
    }

    /// Loads the master allergy/disease reference lists (same lists Edit Profile
    /// uses) so this sheet's chips have something to select from and search.
    @MainActor
    func loadReferenceData() async {
        isLoading = true
        errorMessage = nil

        do {
            // Reuses the SAME endpoint/use case Edit Profile already calls for
            // allergies/diseases master lists — avoids a duplicate network call type.
            let data = try await getReferenceDataUseCase.execute()

            conditions.configure(
                availableItems: data.diseases,
                existingSelections: existingMember?.diseases ?? []
            )
            allergies.configure(
                availableItems: data.allergies,
                existingSelections: existingMember?.allergies ?? []
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func validate() -> Bool {
        let isNameValid = name.validate(using: AppValidator.displayNameValidator)
        let isRelationValid = relation.validate(using: AppValidator.displayNameValidator)
        return isNameValid && isRelationValid
    }

    private func buildInput() -> FamilyMemberInput {
        FamilyMemberInput(
            name: name.value,
            relation: relation.value,
            allergyIds: allergies.selectedIds,
            diseaseIds: conditions.selectedIds
        )
    }

    /// Returns the input to submit, and whether this is an add or update —
    /// the caller (ProfileViewModel) owns merging it into the full list.
    func submit() -> FamilyMemberInput? {
        guard validate() else { return nil }
        return buildInput()
    }
}

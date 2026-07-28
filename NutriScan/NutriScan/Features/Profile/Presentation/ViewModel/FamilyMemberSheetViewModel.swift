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
    let allMembers: [FamilyMember]
    
    enum AlertContext { case delete, duplicate, unsavedChanges }
    var alertContext: AlertContext = .delete

    var name = ValidatedField(value: "")
    var relation = ValidatedField(value: "")

    var conditions = ChipSelectionManager()
    var allergies = ChipSelectionManager()

    var isLoading = false
    var errorMessage: String?

    private let getReferenceDataUseCase: GetEditProfileUseCaseProtocol
    private let updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol

    // MARK: - Reference Data Storage for Reverting
    private var availableDiseases: [ReferenceItem] = []
    private var availableAllergies: [ReferenceItem] = []

    var isEditMode: Bool { existingMember != nil }

    init(
        existingMember: FamilyMember?,
        allMembers: [FamilyMember],
        getReferenceDataUseCase: GetEditProfileUseCaseProtocol = DIContainer.shared.resolve(type: GetEditProfileUseCaseProtocol.self),
        updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol = DIContainer.shared.resolve(type: UpdateFamilyMembersUseCaseProtocol.self)
    ) {
        self.existingMember = existingMember
        self.allMembers = allMembers
        self.getReferenceDataUseCase = getReferenceDataUseCase
        self.updateFamilyMembersUseCase = updateFamilyMembersUseCase

        if let member = existingMember {
            name.value = member.name
            relation.value = member.relation
        }
    }

    @MainActor
    func loadReferenceData() async {
        isLoading = true
        errorMessage = nil

        do {
            let data = try await getReferenceDataUseCase.execute()
            
            self.availableDiseases = data.diseases
            self.availableAllergies = data.allergies

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

    // MARK: - Validation & Dirty Check
    var hasUnsavedChanges: Bool {
        guard let existing = existingMember else { return true }
        
        let currentName = name.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let currentRelation = relation.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let existingAllergies = Set(existing.allergies.map(\.id))
        let existingDiseases = Set(existing.diseases.map(\.id))
        let currentAllergies = Set(allergies.selectedIds)
        let currentDiseases = Set(conditions.selectedIds)
        
        return currentName != existing.name ||
               currentRelation != existing.relation ||
               existingAllergies != currentAllergies ||
               existingDiseases != currentDiseases
    }
    
    func revertChanges() {
        guard let existing = existingMember else { return }
        name.value = existing.name
        relation.value = existing.relation
        
        name.state = .normal
        relation.state = .normal
        
        conditions.configure(availableItems: availableDiseases, existingSelections: existing.diseases)
        allergies.configure(availableItems: availableAllergies, existingSelections: existing.allergies)
    }

    func validate() -> Bool {
        let isNameValid = name.validate(using: AppValidator.displayNameValidator)
        let isRelationValid = relation.validate(using: AppValidator.displayNameValidator)
        return isNameValid && isRelationValid
    }
    
    func isDuplicate() -> Bool {
        let currentName = name.value.trimmingCharacters(in: .whitespaces).lowercased()
        let currentRelation = relation.value.trimmingCharacters(in: .whitespaces).lowercased()
        
        return allMembers.contains { member in
            if let existingId = existingMember?.id, member.id == existingId {
                return false
            }
            
            let memberName = member.name.trimmingCharacters(in: .whitespaces).lowercased()
            let memberRelation = member.relation.trimmingCharacters(in: .whitespaces).lowercased()
            
            return memberName == currentName && memberRelation == currentRelation
        }
    }

    private func buildInput() -> FamilyMemberInput {
        FamilyMemberInput(
            name: name.value,
            relation: relation.value,
            allergyIds: allergies.selectedIds,
            diseaseIds: conditions.selectedIds
        )
    }

    func submit() -> FamilyMemberInput? {
        guard validate() else { return nil }
        return buildInput()
    }
}

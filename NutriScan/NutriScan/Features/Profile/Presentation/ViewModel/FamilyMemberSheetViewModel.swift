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
    
    enum AlertContext { case delete, duplicate }
    var alertContext: AlertContext = .delete

    var name = ValidatedField(value: "")
    var relation = ValidatedField(value: "")

    var conditions = ChipSelectionManager()
    var allergies = ChipSelectionManager()

    var isLoading = false
    var errorMessage: String?

    // Updated to use the shared reference data use case protocol
    private let getReferenceDataUseCase: GetReferenceDataUseCaseProtocol
    private let updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol

    var isEditMode: Bool { existingMember != nil }

    init(
        existingMember: FamilyMember?,
        allMembers: [FamilyMember],
        getReferenceDataUseCase: GetReferenceDataUseCaseProtocol = DIContainer.shared.resolve(type: GetReferenceDataUseCaseProtocol.self),
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
            // The unified use case returns a tuple of (allergies, diseases)
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
    
    // MARK: - Validation
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

//
//  FamilyMemberSheetViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import Foundation
import SwiftUI

@Observable
final class FamilyMemberSheetViewModel {
    let existingMember: FamilyMember?
    let allMembers: [FamilyMember]

    var name = ValidatedField(value: "")
    var relation = ValidatedField(value: "")

    var conditions = ChipSelectionManager()
    var allergies = ChipSelectionManager()

    var isLoading = false
    var isImageUploading = false
    
    var isSaving = false
    var isDeleting = false
    
    var errorMessage: String?
    var pendingImageData: Data?

    private var snapshot: FamilyMemberInput?
    private var revertAction: (() -> Void)?

    private let getReferenceDataUseCase: GetReferenceDataUseCaseProtocol
    private let imageCompressor: ImageCompressing

    var isEditMode: Bool { existingMember != nil }

    init(
        existingMember: FamilyMember?,
        allMembers: [FamilyMember],
        getReferenceDataUseCase: GetReferenceDataUseCaseProtocol = DIContainer.shared.resolve(type: GetReferenceDataUseCaseProtocol.self),
        imageCompressor: ImageCompressing = ImageCompressor()
    ) {
        self.existingMember = existingMember
        self.allMembers = allMembers
        self.getReferenceDataUseCase = getReferenceDataUseCase
        self.imageCompressor = imageCompressor

        if let member = existingMember {
            name.value = member.name
            relation.value = member.relation
        }

        captureSnapshot()
        setupRevertAction()
    }

    @MainActor
    func loadReferenceData() async {
        isLoading = true
        errorMessage = nil

        do {
            let data = try await getReferenceDataUseCase.execute()
            conditions.configure(availableItems: data.diseases, existingSelections: existingMember?.diseases ?? [])
            allergies.configure(availableItems: data.allergies, existingSelections: existingMember?.allergies ?? [])
            captureSnapshot()
            setupRevertAction()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func captureSnapshot() {
        snapshot = buildInput()
    }

    private func setupRevertAction() {
        let origName = existingMember?.name ?? ""
        let origRelation = existingMember?.relation ?? ""
        let origDiseases = existingMember?.diseases ?? []
        let origAllergies = existingMember?.allergies ?? []

        self.revertAction = { [weak self] in
            guard let self = self else { return }
            self.name.value = origName
            self.relation.value = origRelation
            self.conditions.configure(availableItems: self.conditions.availableItems, existingSelections: origDiseases)
            self.allergies.configure(availableItems: self.allergies.availableItems, existingSelections: origAllergies)
            self.name.state = .normal
            self.relation.state = .normal
            self.pendingImageData = nil
            self.captureSnapshot()
        }
    }

    func revertChanges() {
        revertAction?()
        errorMessage = nil
    }

    var hasUnsavedChanges: Bool {
        guard let snapshot else { return false }
        let current = buildInput()

        return snapshot.name != current.name
            || snapshot.relation != current.relation
            || Set(snapshot.allergyIds) != Set(current.allergyIds)
            || Set(snapshot.diseaseIds) != Set(current.diseaseIds)
            || pendingImageData != nil
    }

    @MainActor
    func handleImageSelection(data: Data) async {
        self.pendingImageData = imageCompressor.compress(data)
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
            if let existingId = existingMember?.id, member.id == existingId { return false }
            return member.name.trimmingCharacters(in: .whitespaces).lowercased() == currentName
                && member.relation.trimmingCharacters(in: .whitespaces).lowercased() == currentRelation
        }
    }

    private func buildInput() -> FamilyMemberInput {
        FamilyMemberInput(
            id: existingMember?.id,
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

    func validateFieldsOrInputs() -> Bool {
        return validate()
    }
}

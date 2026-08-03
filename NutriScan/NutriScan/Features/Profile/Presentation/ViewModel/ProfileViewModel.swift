//
//  ProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

@Observable
final class ProfileViewModel {
    private let observeProfileUseCase: ObserveProfileUseCaseProtocol
    private let updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol
    private let getStreakUseCase: GetStreakUseCaseProtocol
    private let updateStreakUseCase: UpdateStreakUseCaseProtocol
    private let uploadFamilyMemberImageUseCase: UploadFamilyMemberImageUseCaseProtocol
    
    var isMutating: Bool = false
    var errorMessage: String?

    var fullName: String { observeProfileUseCase.execute().currentProfile?.fullName ?? "" }
    var familyMembers: [FamilyMember] { observeProfileUseCase.execute().currentProfile?.familyMembers ?? [] }
    var streakDays: Int { observeProfileUseCase.execute().streakDays }
    
    var state: ProfileState {
        let rawURL = observeProfileUseCase.execute().currentProfile?.imageUrl
        let cleanURL = (rawURL?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true) ? nil : rawURL
        
        return ProfileState(
            fullName: self.fullName,
            familyMembers: self.familyMembers,
            streakDays: self.streakDays,
            avatarURL: cleanURL ?? AppConstants.defaultUserAvatarURL,
            isLoading: self.isMutating,
            errorMessage: self.errorMessage
        )
    }

    init(
        observeProfileUseCase: ObserveProfileUseCaseProtocol = DIContainer.shared.resolve(type: ObserveProfileUseCaseProtocol.self),
        updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol = DIContainer.shared.resolve(type: UpdateFamilyMembersUseCaseProtocol.self),
        getStreakUseCase: GetStreakUseCaseProtocol = DIContainer.shared.resolve(type: GetStreakUseCaseProtocol.self),
        updateStreakUseCase: UpdateStreakUseCaseProtocol = DIContainer.shared.resolve(type: UpdateStreakUseCaseProtocol.self),
        uploadFamilyMemberImageUseCase: UploadFamilyMemberImageUseCaseProtocol = DIContainer.shared.resolve(type: UploadFamilyMemberImageUseCaseProtocol.self)
    ) {
        self.observeProfileUseCase = observeProfileUseCase
        self.updateFamilyMembersUseCase = updateFamilyMembersUseCase
        self.getStreakUseCase = getStreakUseCase
        self.updateStreakUseCase = updateStreakUseCase
        self.uploadFamilyMemberImageUseCase = uploadFamilyMemberImageUseCase
    }

    @MainActor
    func updateAndFetchStreak() async {
        do {
            try await updateStreakUseCase.execute()
            _ = try await getStreakUseCase.execute()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func addFamilyMember(_ newMember: FamilyMemberInput, imageData: Data?) async -> String? {
        let existing = familyMembers.map {
            FamilyMemberInput(
                name: $0.name, relation: $0.relation,
                allergyIds: $0.allergies.map(\.id), diseaseIds: $0.diseases.map(\.id)
            )
        }
        
        if let error = await submitFamilyMembers(existing + [newMember]) {
            return error
        }
        
        if let imageData = imageData {
            if let createdMember = familyMembers.first(where: { $0.name == newMember.name && $0.relation == newMember.relation }) {
                do {
                    try await uploadFamilyMemberImageUseCase.execute(id: createdMember.id, data: imageData)
                } catch {
                    return "Member added, but image upload failed: \(error.localizedDescription)"
                }
            }
        }
        return nil
    }

    @MainActor
    func updateFamilyMember(id: String, with updated: FamilyMemberInput, imageData: Data?) async -> String? {
        var updatedList: [FamilyMemberInput] = []
        for member in familyMembers {
            if member.id == id {
                updatedList.append(updated)
            } else {
                updatedList.append(FamilyMemberInput(
                    name: member.name, relation: member.relation,
                    allergyIds: member.allergies.map(\.id), diseaseIds: member.diseases.map(\.id)
                ))
            }
        }
        
        if let error = await submitFamilyMembers(updatedList) {
            return error
        }
        
        if let data = imageData {
            do {
                try await uploadFamilyMemberImageUseCase.execute(id: id, data: data)
            } catch {
                return "Details saved, but image upload failed: \(error.localizedDescription)"
            }
        }
        return nil
    }

    @MainActor
    func deleteFamilyMember(id: String) async -> String? {
        let remaining = familyMembers
            .filter { $0.id != id }
            .map {
                FamilyMemberInput(
                    name: $0.name, relation: $0.relation,
                    allergyIds: $0.allergies.map(\.id), diseaseIds: $0.diseases.map(\.id)
                )
            }
        return await submitFamilyMembers(remaining)
    }

    @MainActor
    private func submitFamilyMembers(_ members: [FamilyMemberInput]) async -> String? {
        isMutating = true
        var resultError: String? = nil
        do {
            try await updateFamilyMembersUseCase.execute(members: members)
        } catch {
            resultError = error.localizedDescription
        }
        isMutating = false
        return resultError
    }
}

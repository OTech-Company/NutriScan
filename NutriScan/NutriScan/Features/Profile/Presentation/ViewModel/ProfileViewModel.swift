//
//  ProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

private struct MessageError: Error {
    let message: String
}

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
        let idsBefore = Set(familyMembers.map(\.id))
        let payload = familyMembers.map { $0.toInput() } + [newMember]

        switch await submitFamilyMembers(payload) {
        case .failure(let error):
            return error.message
        case .success(let refreshed):
            guard let imageData,
                  let created = refreshed.first(where: { !idsBefore.contains($0.id) })
            else { return nil }
            let resolvedId = created.id

            do {
                try await uploadFamilyMemberImageUseCase.execute(id: resolvedId, data: imageData)
            } catch {
                return "Member added, but image upload failed: \(error.localizedDescription)"
            }
            return nil
        }
    }

    @MainActor
    func updateFamilyMember(id: String, with updated: FamilyMemberInput, imageData: Data?) async -> String? {
        let payload = familyMembers.map { $0.id == id ? updated : $0.toInput() }

        switch await submitFamilyMembers(payload) {
        case .failure(let error):
            return error.message
        case .success:
            guard let imageData else { return nil }
            do {
                try await uploadFamilyMemberImageUseCase.execute(id: id, data: imageData)
            } catch {
                return "Details saved, but image upload failed: \(error.localizedDescription)"
            }
            return nil
        }
    }

    @MainActor
    func deleteFamilyMember(id: String) async -> String? {
        let remaining = familyMembers
            .filter { $0.id != id }
            .map { $0.toInput() }

        switch await submitFamilyMembers(remaining) {
        case .failure(let error): return error.message
        case .success: return nil
        }
    }
    
    @MainActor
    private func submitFamilyMembers(_ members: [FamilyMemberInput]) async -> Result<[FamilyMember], MessageError> {
        isMutating = true
        defer { isMutating = false }
        do {
            try await updateFamilyMembersUseCase.execute(members: members)
            return .success(familyMembers)
        } catch {
            return .failure(MessageError(message: error.localizedDescription))
        }
    }
}

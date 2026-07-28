//
//  ProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//
import Foundation

@Observable
final class ProfileViewModel {
    // MARK: - Dependencies
    private let observeProfileUseCase: ObserveProfileUseCaseProtocol
    private let updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol
    private let getStreakUseCase: GetStreakUseCaseProtocol
    private let updateStreakUseCase: UpdateStreakUseCaseProtocol
    
    // MARK: - State
    var isMutating: Bool = false // Only true during PATCH requests
    var errorMessage: String?

    // MARK: - Reactive Data Properties
    // Because SharedProfileStore is @Observable, accessing these properties
    // guarantees the View will re-render if the underlying store changes.
    var fullName: String {
        observeProfileUseCase.execute().currentProfile?.fullName ?? ""
    }
    
    var familyMembers: [FamilyMember] {
        observeProfileUseCase.execute().currentProfile?.familyMembers ?? []
    }
    
    var streakDays: Int {
        observeProfileUseCase.execute().streakDays
    }
    
    var state: ProfileState {
        // Bridge for your existing UI components that expect a ProfileState object
        ProfileState(
            fullName: self.fullName,
            familyMembers: self.familyMembers,
            streakDays: self.streakDays,
            avatarURL: observeProfileUseCase.execute().currentProfile?.imageUrl ?? AppConstants.defaultUserAvatarURL,
            isLoading: self.isMutating,
            errorMessage: self.errorMessage
        )
    }

    init(
        observeProfileUseCase: ObserveProfileUseCaseProtocol = DIContainer.shared.resolve(type: ObserveProfileUseCaseProtocol.self),
        updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol = DIContainer.shared.resolve(type: UpdateFamilyMembersUseCaseProtocol.self),
        getStreakUseCase: GetStreakUseCaseProtocol = DIContainer.shared.resolve(type: GetStreakUseCaseProtocol.self),
        updateStreakUseCase: UpdateStreakUseCaseProtocol = DIContainer.shared.resolve(type: UpdateStreakUseCaseProtocol.self)
    ) {
        self.observeProfileUseCase = observeProfileUseCase
        self.updateFamilyMembersUseCase = updateFamilyMembersUseCase
        self.getStreakUseCase = getStreakUseCase
        self.updateStreakUseCase = updateStreakUseCase
    }

    // MARK: - Actions
    @MainActor
    func updateAndFetchStreak() async {
        do {
            try await updateStreakUseCase.execute()
            _ = try await getStreakUseCase.execute() // Repo handles updating the store automatically
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func addFamilyMember(_ newMember: FamilyMemberInput) async {
        let existing = familyMembers.map {
            FamilyMemberInput(
                name: $0.name, relation: $0.relation,
                allergyIds: $0.allergies.map(\.id), diseaseIds: $0.diseases.map(\.id)
            )
        }
        await submitFamilyMembers(existing + [newMember])
    }

    @MainActor
    func updateFamilyMember(id: String, with updated: FamilyMemberInput) async {
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
        await submitFamilyMembers(updatedList)
    }

    @MainActor
    func deleteFamilyMember(id: String) async {
        let remaining = familyMembers
            .filter { $0.id != id }
            .map {
                FamilyMemberInput(
                    name: $0.name, relation: $0.relation,
                    allergyIds: $0.allergies.map(\.id), diseaseIds: $0.diseases.map(\.id)
                )
            }
        await submitFamilyMembers(remaining)
    }

    @MainActor
    private func submitFamilyMembers(_ members: [FamilyMemberInput]) async {
        isMutating = true
        errorMessage = nil

        do {
            // Firing this automatically updates the SharedProfileStore inside the Repo
            try await updateFamilyMembersUseCase.execute(members: members)
        } catch {
            errorMessage = error.localizedDescription
        }
        isMutating = false
    }
}

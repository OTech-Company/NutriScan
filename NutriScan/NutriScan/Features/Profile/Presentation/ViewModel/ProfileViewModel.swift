//
//  ProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

@Observable
final class ProfileViewModel {
    var state = ProfileState()
    private(set) var hasLoaded = false

    private let getProfileSummaryUseCase: GetProfileSummaryUseCaseProtocol
    private let updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol
    
    private let getStreakUseCase: GetStreakUseCaseProtocol
    private let updateStreakUseCase: UpdateStreakUseCaseProtocol

    init(
        getProfileSummaryUseCase: GetProfileSummaryUseCaseProtocol = DIContainer.shared.resolve(type: GetProfileSummaryUseCaseProtocol.self),
        updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol = DIContainer.shared.resolve(type: UpdateFamilyMembersUseCaseProtocol.self),
        getStreakUseCase: GetStreakUseCaseProtocol = DIContainer.shared.resolve(type: GetStreakUseCaseProtocol.self),
        updateStreakUseCase: UpdateStreakUseCaseProtocol = DIContainer.shared.resolve(type: UpdateStreakUseCaseProtocol.self)
    ) {
        self.getProfileSummaryUseCase = getProfileSummaryUseCase
        self.updateFamilyMembersUseCase = updateFamilyMembersUseCase
        self.getStreakUseCase = getStreakUseCase
        self.updateStreakUseCase = updateStreakUseCase
    }

    @MainActor
    func loadProfile(forceRefresh: Bool = false) async {
        guard !hasLoaded || forceRefresh else { return }

        state.isLoading = true
        state.errorMessage = nil

        do {
            // Separate operations: Update the streak on the backend first, then fetch the latest value
            try await updateStreakUseCase.execute()
            state.streakDays = try await getStreakUseCase.execute()
            
            // Load the rest of the profile
            let summary = try await getProfileSummaryUseCase.execute()
            state.fullName = summary.fullName
            state.familyMembers = summary.familyMembers
            hasLoaded = true
        } catch {
            state.errorMessage = error.localizedDescription
        }

        state.isLoading = false
    }

    @MainActor
    func addFamilyMember(_ newMember: FamilyMemberInput) async {
        let existing = state.familyMembers.map {
            FamilyMemberInput(
                name: $0.name,
                relation: $0.relation,
                allergyIds: $0.allergies.map(\.id),
                diseaseIds: $0.diseases.map(\.id)
            )
        }
        await submitFamilyMembers(existing + [newMember])
    }

    @MainActor
    func updateFamilyMember(id: String, with updated: FamilyMemberInput) async {
        var updatedList: [FamilyMemberInput] = []
        for member in state.familyMembers {
            if member.id == id {
                updatedList.append(updated)
            } else {
                updatedList.append(FamilyMemberInput(
                    name: member.name,
                    relation: member.relation,
                    allergyIds: member.allergies.map(\.id),
                    diseaseIds: member.diseases.map(\.id)
                ))
            }
        }
        await submitFamilyMembers(updatedList)
    }

    @MainActor
    private func submitFamilyMembers(_ members: [FamilyMemberInput]) async {
        state.isLoading = true
        state.errorMessage = nil

        do {
            let summary = try await updateFamilyMembersUseCase.execute(members: members)
            state.fullName = summary.fullName
            state.familyMembers = summary.familyMembers
        } catch {
            state.errorMessage = error.localizedDescription
        }

        state.isLoading = false
    }

    @MainActor
    func deleteFamilyMember(id: String) async {
        let remaining = state.familyMembers
            .filter { $0.id != id }
            .map {
                FamilyMemberInput(
                    name: $0.name,
                    relation: $0.relation,
                    allergyIds: $0.allergies.map(\.id),
                    diseaseIds: $0.diseases.map(\.id)
                )
            }
        await submitFamilyMembers(remaining)
    }
}

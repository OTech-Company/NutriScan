//
//  ProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//
//
//  ProfileViewModel.swift
//  NutriScan
//
//  Features/Profile/Presentation/ViewModel/
//

import Foundation

@Observable
final class ProfileViewModel {
    var state = ProfileState()

    private let getProfileSummaryUseCase: GetProfileSummaryUseCaseProtocol
    private let updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol

    init(
        getProfileSummaryUseCase: GetProfileSummaryUseCaseProtocol = DIContainer.shared.resolve(type: GetProfileSummaryUseCaseProtocol.self),
        updateFamilyMembersUseCase: UpdateFamilyMembersUseCaseProtocol = DIContainer.shared.resolve(type: UpdateFamilyMembersUseCaseProtocol.self)
    ) {
        self.getProfileSummaryUseCase = getProfileSummaryUseCase
        self.updateFamilyMembersUseCase = updateFamilyMembersUseCase
    }

    @MainActor
    func loadProfile() async {
        state.isLoading = true
        state.errorMessage = nil

        do {
            let summary = try await getProfileSummaryUseCase.execute()
            state.fullName = summary.fullName
            state.familyMembers = summary.familyMembers
        } catch {
            state.errorMessage = error.localizedDescription
        }

        state.isLoading = false
    }

    /// Adds a new family member by sending the full desired list
    /// (existing members + the new one) to the PATCH endpoint.
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

    /// Updates one existing member in place, then resubmits the full list.
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

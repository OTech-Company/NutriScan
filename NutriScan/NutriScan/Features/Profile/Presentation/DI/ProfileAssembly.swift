//
//  ProfileAssembly.swift
//  NutriScan
//
import Foundation

struct ProfileAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register(
            type: GetStreakUseCaseProtocol.self,
            component: GetStreakUseCase()
        )

        container.register(
            type: UpdateStreakUseCaseProtocol.self,
            component: UpdateStreakUseCase()
        )

        container.register(
            type: UpdateFamilyMembersUseCaseProtocol.self,
            component: UpdateFamilyMembersUseCase()
        )
    }
}

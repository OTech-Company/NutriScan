//
//  RequestStepAuthorizationUseCase.swift
//  StepTracker - Domain / UseCases
//

import Foundation

protocol RequestStepAuthorizationUseCaseProtocol {
    func execute() async throws -> Bool
}

final class RequestStepAuthorizationUseCase: RequestStepAuthorizationUseCaseProtocol {
    private let repository: StepRepositoryProtocol

    init(repository: StepRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> Bool {
        try await repository.requestAuthorization()
    }
}

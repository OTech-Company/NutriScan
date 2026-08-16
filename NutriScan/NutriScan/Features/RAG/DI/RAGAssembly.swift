//
//  RAGAssembly.swift
//  NutriScan
//

import Foundation

struct RAGAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register(
            type: QueryRAGUseCase.self,
            component: QueryRAGUseCaseImpl(repository: RAGRepositoryImpl())
        )
    }
}

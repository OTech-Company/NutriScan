//
//  QueryRAGUseCase.swift
//  NutriScan
//

import Foundation

protocol QueryRAGUseCase {
    func execute(question: String, language: RAGLanguage) async throws -> RAGMessage
}

final class QueryRAGUseCaseImpl: QueryRAGUseCase {
    private let repository: RAGRepository

    init(repository: RAGRepository) {
        self.repository = repository
    }

    func execute(question: String, language: RAGLanguage) async throws -> RAGMessage {
        let trimmed = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw RAGError.emptyQuery
        }
        return try await repository.query(trimmed, language: language)
    }
}

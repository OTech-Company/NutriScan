//
//  RAGRepositoryImpl.swift
//  NutriScan
//

import Foundation

final class RAGRepositoryImpl: RAGRepository {
    private let apiService: RAGAPIServicing

    init(apiService: RAGAPIServicing = RAGAPIService()) {
        self.apiService = apiService
    }

    func query(_ question: String, language: RAGLanguage) async throws -> RAGMessage {
        let response = try await apiService.query(question, language: language)
        return map(response, language: language)
    }

    private func map(_ dto: RAGResponseDTO, language: RAGLanguage) -> RAGMessage {
        RAGMessage(
            query: dto.query,
            answer: dto.answer,
            sources: dto.sources.map {
                RAGSource(
                    fileName: $0.fileName,
                    chunkIndex: $0.chunkIndex,
                    score: $0.score,
                    snippet: $0.snippet
                )
            },
            language: language
        )
    }
}

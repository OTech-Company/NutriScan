//
//  RAGAPIService.swift
//  NutriScan
//

import Foundation

protocol RAGAPIServicing {
    func query(_ question: String) async throws -> RAGResponseDTO
}

struct RAGAPIService: RAGAPIServicing {
    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol = NetworkService.shared) {
        self.network = network
    }

    func query(_ question: String) async throws -> RAGResponseDTO {
        let dto = RAGQueryDTO(query: question)
        return try await network.request(RAGEndpoint.query(dto))
    }
}

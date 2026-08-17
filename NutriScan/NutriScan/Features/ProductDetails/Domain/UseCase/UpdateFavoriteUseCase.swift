//
//  UpdateFavoriteUseCase.swift
//  NutriScan
//

import Foundation

final class UpdateFavoriteUseCase {
    private let repository: ProductDetailsRepo

    init(repository: ProductDetailsRepo) {
        self.repository = repository
    }

    func execute(scanId: String, isFavorite: Bool) async throws {
        try await repository.updateFavorite(scanId: scanId, isFavorite: isFavorite)
    }
}

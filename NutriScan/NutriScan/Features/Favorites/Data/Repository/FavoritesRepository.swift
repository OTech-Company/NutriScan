//
//  FavoritesRepository.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 26/07/2026.
//

import Foundation

class FavoritesRepository: FavoritesRepositoryProtocol {
    private let remoteDataSource: FavoritesRemoteDataSourceProtocol
    
    init(remoteDataSource: FavoritesRemoteDataSourceProtocol = FavoritesRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getFavorites(page: Int, size: Int) async throws -> (favorites: [FavoritesScanEntity], totalPages: Int) {
        let response = try await remoteDataSource.getFavorites(page: page, size: size)
        let entities = response.content?.map { FavoritesScanEntity(dto: $0) } ?? []
        return (favorites: entities, totalPages: response.totalPages ?? 0)
    }
    
    func removeFavorite(scanId: String) async throws {
        try await remoteDataSource.removeFavorite(scanId: scanId)
    }
}


let mockFavoritesScanEntities: [FavoritesScanEntity] = [
    FavoritesScanEntity(
        id: "1",
        imageUrl: "testImage",
        condition: .Safe,
        productName: "Milk Product",
        calories: 180.0
    ),
    FavoritesScanEntity(
        id: "2",
        imageUrl: "testImage2",
        condition: .Caution,
        productName: "Whole Wheat Bread",
        calories: 220.0
    ),
    FavoritesScanEntity(
        id: "3",
        imageUrl: "testImage3",
        condition: .UnSafe,
        productName: "Sugary Snack",
        calories: 450.0
    ),
    FavoritesScanEntity(
        id: "4",
        imageUrl: "testImage4",
        condition: .Safe,
        productName: "Greek Yogurt",
        calories: 130.0
    ),
    FavoritesScanEntity(
        id: "5",
        imageUrl: "testImage5",
        condition: .Caution,
        productName: "Granola Bar",
        calories: 250.0
    ),
    FavoritesScanEntity(
        id: "6",
        imageUrl: "testImage6",
        condition: .UnSafe,
        productName: "Energy Drink",
        calories: 160.0
    ),
    FavoritesScanEntity(
        id: "7",
        imageUrl: "testImage7",
        condition: .Safe,
        productName: "Almonds",
        calories: 164.0
    )
]

//
//  UploadProfileImageUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

protocol UploadProfileImageUseCaseProtocol {
    func execute(data: Data) async throws
}

struct UploadProfileImageUseCase: UploadProfileImageUseCaseProtocol {
    private let repository: SharedProfileRepositoryProtocol
    
    init(repository: SharedProfileRepositoryProtocol = DIContainer.shared.resolve(type: SharedProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute(data: Data) async throws {
        try await repository.uploadProfileImage(data: data)
    }
}

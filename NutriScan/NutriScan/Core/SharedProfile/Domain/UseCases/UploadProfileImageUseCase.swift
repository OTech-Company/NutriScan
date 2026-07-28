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
    private let repository: UserProfileRepositoryProtocol
    
    init(repository: UserProfileRepositoryProtocol = DIContainer.shared.resolve(type: UserProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute(data: Data) async throws {
        try await repository.uploadProfileImage(data: data)
    }
}

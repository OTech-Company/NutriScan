//
//  UploadFamilyMemberImageUseCase.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 03/08/2026.
//

import Foundation

protocol UploadFamilyMemberImageUseCaseProtocol {
    func execute(id: String, data: Data) async throws
}

struct UploadFamilyMemberImageUseCase: UploadFamilyMemberImageUseCaseProtocol {
    private let repository: UserProfileRepositoryProtocol
    
    init(repository: UserProfileRepositoryProtocol = DIContainer.shared.resolve(type: UserProfileRepositoryProtocol.self)) {
        self.repository = repository
    }
    
    func execute(id: String, data: Data) async throws {
        try await repository.uploadFamilyMemberImage(id: id, data: data)
    }
}

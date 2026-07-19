//
//  NetworkProfileRepository.swift
//  NutriScan
//
//  Created by Osama Hosam on 16/07/2026.
//

import Foundation

class NetworkProfileRepository: ProfileRepository {
    private let session: URLSession
    private let baseURL = URL(string: "https://localhost:8080/api")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getUserProfile() async throws -> UserProfile {

        let mockResponse = UserProfileResponse(
            id: "5f2c1e2a-9b3d-4a11-8e2f-3c9d6a7b0011",
            email: "osama@example.com",
            username: "osama_dev",
            firstName: "Osama",
            lastName: "Hosam",
            dateOfBirth: "2002-05-14",
            gender: "MALE",
            heightCm: 175,
            weightKg: 70,
            allergies: [
                AllergyDTO(id: 1, name: "Tree Nuts"),
                AllergyDTO(id: 2, name: "Lactose Intolerance")
            ],
            // Intentionally left nil to ensure the completion percentage isn't always 100%
            diseases: nil,
            updatedAt: "2026-07-16T10:20:00Z"
        )
        
        return mockResponse.toDomain()
    }
}

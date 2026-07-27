//
//  ProfileResponseDTO+Domain.swift
//  NutriScan
//

import Foundation

extension ProfileResponseDTO {
    func toDomain() -> ProfileInfo {
        ProfileInfo(
            fullName: "\(firstName) \(lastName)",
            familyMembers: familyMembers.map { $0.toDomain() }
        )
    }
}

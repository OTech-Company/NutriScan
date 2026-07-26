//
//  ProfileSummaryResponseDTO+Domain.swift
//  NutriScan
//

import Foundation

extension ProfileSummaryResponseDTO {
    func toDomain() -> ProfileSummary {
        ProfileSummary(
            fullName: "\(firstName) \(lastName)",
            familyMembers: familyMembers.map { $0.toDomain() }
        )
    }
}

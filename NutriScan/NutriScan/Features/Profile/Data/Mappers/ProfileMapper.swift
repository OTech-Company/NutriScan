//
//  ProfileMapper.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

enum ProfileMapper {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    private static let isoFormatter = ISO8601DateFormatter()

    // MARK: - DTO to Entity
    
    static func map(dto: ReferenceItemDTO) -> ReferenceItem {
        return ReferenceItem(id: dto.id, name: dto.name)
    }

    static func map(dto: ProfileResponseDTO) -> Profile {
        return Profile(
            id: dto.id,
            email: dto.email,
            username: dto.username,
            firstName: dto.firstName,
            lastName: dto.lastName,
            dateOfBirth: dto.dateOfBirth.flatMap { dateFormatter.date(from: $0) },
            gender: dto.gender,
            heightCm: dto.heightCm,
            weightKg: dto.weightKg,
            allergies: dto.allergies.map { map(dto: $0) },
            diseases: dto.diseases.map { map(dto: $0) },
            updatedAt: dto.updatedAt.flatMap { isoFormatter.date(from: $0) }
        )
    }

    // MARK: - Entity to Request DTO
    
    static func map(update: ProfileUpdate) -> ProfileUpdateRequestDTO {
        return ProfileUpdateRequestDTO(
            firstName: update.firstName,
            lastName: update.lastName,
            dateOfBirth: dateFormatter.string(from: update.dateOfBirth),
            gender: update.gender,
            heightCm: update.heightCm,
            weightKg: update.weightKg,
            allergyIds: update.allergyIds,
            diseaseIds: update.diseaseIds
        )
    }
}

//
//  ProfileSummaryMapper.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

enum ProfileSummaryMapper {

    static func map(dto: FamilyMemberDTO) -> FamilyMember {
        FamilyMember(
            id: dto.id,
            name: dto.name,
            relation: dto.relation,
            // Assuming ReferenceItem is shared or duplicated locally
            allergies: dto.allergies.map { EditProfileMapper.map(dto: $0) },
            diseases: dto.diseases.map { EditProfileMapper.map(dto: $0) }
        )
    }

    static func map(dto: ProfileSummaryResponseDTO) -> ProfileSummary {
        ProfileSummary(
            fullName: "\(dto.firstName) \(dto.lastName)",
            familyMembers: dto.familyMembers.map { map(dto: $0) }
        )
    }

    // MARK: - Entity to Request DTO
    static func map(input: FamilyMemberInput) -> FamilyMemberRequestDTO {
        FamilyMemberRequestDTO(
            name: input.name,
            relation: input.relation,
            allergyIds: input.allergyIds,
            diseaseIds: input.diseaseIds
        )
    }

    static func map(inputs: [FamilyMemberInput]) -> FamilyMembersUpdateRequestDTO {
        FamilyMembersUpdateRequestDTO(familyMembers: inputs.map { map(input: $0) })
    }
}

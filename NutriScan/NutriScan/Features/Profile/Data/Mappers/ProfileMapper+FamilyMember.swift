//
//  ProfileMapper+FamilyMember.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

extension ProfileMapper {

    static func map(dto: FamilyMemberDTO) -> FamilyMember {
        FamilyMember(
            id: dto.id,
            name: dto.name,
            relation: dto.relation,
            allergies: dto.allergies.map { map(dto: $0) },
            diseases: dto.diseases.map { map(dto: $0) }
        )
    }

    static func map(dto: ProfileSummaryResponseDTO) -> ProfileSummary {
        ProfileSummary(
            fullName: "\(dto.firstName) \(dto.lastName)",
            familyMembers: dto.familyMembers.map { map(dto: $0) }
        )
    }

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

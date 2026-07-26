//
//  FamilyMemberInput+DTO.swift
//  NutriScan
//

import Foundation

extension FamilyMemberInput {
    func toRequestDTO() -> FamilyMemberRequestDTO {
        FamilyMemberRequestDTO(
            name: name,
            relation: relation,
            allergyIds: allergyIds,
            diseaseIds: diseaseIds
        )
    }
}

//
//  FamilyMemberInput+DTO.swift
//  NutriScan
//

import Foundation

extension FamilyMemberInput {
    func toRequestDTO() -> FamilyMemberRequestDTO {
        FamilyMemberRequestDTO(
            id: id,
            name: name,
            relation: relation,
            allergyIds: allergyIds,
            diseaseIds: diseaseIds
        )
    }
}

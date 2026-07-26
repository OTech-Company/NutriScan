//
//  FamilyMemberDTO+Domain.swift
//  NutriScan
//

import Foundation

extension FamilyMemberDTO {
    func toDomain() -> FamilyMember {
        FamilyMember(
            id: id,
            name: name,
            relation: relation,
            allergies: allergies.map { ReferenceItem(id: $0.id, name: $0.name) },
            diseases: diseases.map { ReferenceItem(id: $0.id, name: $0.name) }
        )
    }
}

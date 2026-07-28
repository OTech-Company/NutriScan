//
//  SharedFamilyMemberDTO+Domain.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//
import Foundation


extension UserFamilyMemberDTO {
    func toDomain() -> FamilyMember {
        FamilyMember(
            id: id,
            name: name,
            relation: relation,
            imageUrl: imageUrl,
            allergies: allergies?.map { ReferenceItem(id: $0.id, name: $0.name) } ?? [],
            diseases: diseases?.map { ReferenceItem(id: $0.id, name: $0.name) } ?? []
        )
    }
}


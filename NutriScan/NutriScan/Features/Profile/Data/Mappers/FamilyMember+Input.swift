//
//  FamilyMember+Input.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 03/08/2026.
//

import Foundation

extension FamilyMember {
    func toInput() -> FamilyMemberInput {
        FamilyMemberInput(
            id: id,
            name: name,
            relation: relation,
            allergyIds: allergies.map(\.id),
            diseaseIds: diseases.map(\.id)
        )
    }
}

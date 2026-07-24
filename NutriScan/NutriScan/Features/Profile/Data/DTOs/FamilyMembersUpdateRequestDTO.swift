//
//  FamilyMembersUpdateRequestDTO.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

struct FamilyMembersUpdateRequestDTO: Codable {
    let familyMembers: [FamilyMemberRequestDTO]
}

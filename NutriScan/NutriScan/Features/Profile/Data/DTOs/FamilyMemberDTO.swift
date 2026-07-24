//
//  FamilyMemberDTO.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

struct FamilyMemberDTO: Codable, Hashable {
    let id: String
    let name: String
    let relation: String
    let allergies: [ReferenceItemDTO]
    let diseases: [ReferenceItemDTO]
}

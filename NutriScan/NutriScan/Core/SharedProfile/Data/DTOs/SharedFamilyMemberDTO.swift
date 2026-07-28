//
//  SharedFamilyMemberDTO.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

struct SharedFamilyMemberDTO: Codable {
    let id: String
    let name: String
    let relation: String
    let imageUrl: String? // Future-proofed
    let allergies: [ReferenceItemDTO]?
    let diseases: [ReferenceItemDTO]?
}

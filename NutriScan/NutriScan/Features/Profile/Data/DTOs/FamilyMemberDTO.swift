//
//  FamilyMemberDTO.swift
//  NutriScan
//

import Foundation

struct FamilyMemberDTO: Codable, Hashable {
    let id: String
    let name: String
    let relation: String
    let allergies: [ReferenceItemDTO]
    let diseases: [ReferenceItemDTO]
}


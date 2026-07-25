//
//  FamilyMemberRequestDTO.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

struct FamilyMemberRequestDTO: Codable {
    let name: String
    let relation: String
    let allergyIds: [Int]
    let diseaseIds: [Int]
}

//
//  FamilyMemberInput.swift
//  NutriScan
//

import Foundation

struct FamilyMemberInput {
    let id: String?
    let name: String
    let relation: String
    let allergyIds: [Int]
    let diseaseIds: [Int]
}


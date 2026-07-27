//
//  FamilyMember.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

struct FamilyMember: Identifiable, Hashable {
    let id: String
    let name: String
    let relation: String
    let allergies: [ReferenceItem]
    let diseases: [ReferenceItem]
}

extension FamilyMember {
    static var dummyList: [FamilyMember] {
        [
            FamilyMember(id: "d1", name: "Sara Omar", relation: "Daughter", allergies: [], diseases: []),
            FamilyMember(id: "d2", name: "Omar Osama", relation: "Son", allergies: [], diseases: []),
            FamilyMember(id: "d3", name: "Youssef Ahmed", relation: "Brother", allergies: [], diseases: [])
        ]
    }
}

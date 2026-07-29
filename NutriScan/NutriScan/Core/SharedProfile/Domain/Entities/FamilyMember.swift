//
//  FamilyMember.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

struct FamilyMember: Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    let relation: String
    let imageUrl: String?
    let allergies: [ReferenceItem]
    let diseases: [ReferenceItem]
}

extension FamilyMember {
    static var dummyList: [FamilyMember] {
        [
            FamilyMember(id: "d1", name: "Sara Omar", relation: "Daughter", imageUrl: nil, allergies: [], diseases: []),
            FamilyMember(id: "d2", name: "Omar Osama", relation: "Son", imageUrl: nil, allergies: [], diseases: []),
            FamilyMember(id: "d3", name: "Youssef Ahmed", relation: "Brother", imageUrl: nil, allergies: [], diseases: [])
        ]
    }
}

//
//  FamilyMember.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

struct FamilyMember: Identifiable, Hashable {
    let id: String?          // nil for a not-yet-saved new member
    let name: String
    let relation: String
    let allergies: [ReferenceItem]
    let diseases: [ReferenceItem]
}

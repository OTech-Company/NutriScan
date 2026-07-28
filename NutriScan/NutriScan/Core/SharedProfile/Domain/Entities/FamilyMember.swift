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

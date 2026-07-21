//
//  ReferenceItemDTO.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

/// Represents the shared ID/Name objects used by Allergies and Diseases
struct ReferenceItemDTO: Codable, Hashable {
    let id: Int
    let name: String
}

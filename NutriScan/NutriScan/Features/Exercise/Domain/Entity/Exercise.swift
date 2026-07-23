//
//  Exercise.swift
//  NutriScan
//

import Foundation

struct Exercise: Identifiable, Hashable {
    let id: String
    let name: String
    let equipment: String    // e.g. "body weight"
    let target: String       // e.g. "abs"
    let category: String     // e.g. "Warm Up", "Yoga"
    let imageName: String?   // SF Symbol name or nil → fallback icon
    let instructions: String
}

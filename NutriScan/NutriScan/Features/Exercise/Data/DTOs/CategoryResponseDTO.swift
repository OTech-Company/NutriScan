//
//  CategoryResponseDTO.swift
//  NutriScan
//

import Foundation

struct CategoryResponseDTO: Decodable {
    let success: Bool
    let data: [String]
}

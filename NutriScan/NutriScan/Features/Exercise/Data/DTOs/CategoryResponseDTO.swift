//
//  CategoryResponseDTO.swift
//  NutriScan
//

import Foundation

struct CategoryResponseDTO: Decodable {
    let success: Bool
    let data: [String]

    func toDomain() -> [ExerciseCategory] {
        let domainCategories = data.map { rawString in
            ExerciseCategory(
                id: rawString,
                name: rawString.capitalized
            )
        }
        return [.all] + domainCategories
    }
}

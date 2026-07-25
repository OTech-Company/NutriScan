//
//  CategoryResponseDTO+Domain.swift
//  NutriScan
//

import Foundation

extension CategoryResponseDTO {
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

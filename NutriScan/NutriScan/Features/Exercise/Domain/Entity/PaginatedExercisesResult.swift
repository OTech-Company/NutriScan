//
//  PaginatedExercisesResult.swift
//  NutriScan
//

import Foundation

struct PaginatedExercisesResult: Equatable {
    let exercises: [Exercise]
    let hasNext: Bool
    let currentPage: Int
    let totalPages: Int
}

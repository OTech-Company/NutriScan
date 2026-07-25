//
//  ExerciseResponseDTO.swift
//  NutriScan
//

import Foundation

struct ExerciseResponseDTO: Decodable {
    let success: Bool
    let meta: ExerciseMetaDTO
    let data: [ExerciseDTO]
}

struct ExerciseMetaDTO: Decodable {
    let pagination: ExercisePaginationDTO
}

struct ExercisePaginationDTO: Decodable {
    let totalItems: Int
    let returnedItems: Int
    let currentPage: Int
    let totalPages: Int
    let limit: Int
    let hasNext: Bool
    let hasPrev: Bool
}

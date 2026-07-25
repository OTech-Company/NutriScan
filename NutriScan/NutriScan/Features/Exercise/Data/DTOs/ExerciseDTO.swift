//
//  ExerciseDTO.swift
//  NutriScan
//

import Foundation

struct ExerciseDTO: Decodable {
    let id: String
    let name: String
    let category: String
    let bodyPart: String
    let equipment: String
    let instructions: [String: String]
    let instructionSteps: [String: [String]]
    let muscleGroup: String
    let secondaryMuscles: [String]
    let target: String
    let repKcal: Double?
    let minKcal: Double?
    let mediaId: String
    let image: String
    let gifUrl: String
    let attribution: String
    let createdAt: String
}

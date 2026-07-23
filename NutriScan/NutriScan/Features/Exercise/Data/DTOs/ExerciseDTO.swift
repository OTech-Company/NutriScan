//
//  ExerciseDTO.swift
//  NutriScan
//

struct ExerciseDTO: Codable {
    let id: String
    let name: String
    let equipment: String
    let target: String
    let category: String
    let imageName: String?
    let instructions: String

    func toDomain() -> Exercise {
        Exercise(
            id: id,
            name: name,
            equipment: equipment,
            target: target,
            category: category,
            imageName: imageName,
            instructions: instructions
        )
    }
}

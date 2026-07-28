//
//  ProfileUpdate+DTO.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//
import Foundation

extension ProfileUpdate {
    func toRequestDTO() -> EditProfileUpdateRequestDTO {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dobString = formatter.string(from: self.dateOfBirth)
        
        return EditProfileUpdateRequestDTO(
            firstName: self.firstName,
            lastName: self.lastName,
            dateOfBirth: dobString,
            gender: self.gender,
            heightCm: self.heightCm,
            weightKg: self.weightKg,
            allergyIds: self.allergyIds,
            diseaseIds: self.diseaseIds
        )
    }
}

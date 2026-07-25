//
//  ProfileSummaryResponseDTO.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

//
//  ProfileSummaryResponseDTO.swift
//  NutriScan
//
//  Features/Profile/Data/DTO/
//
//  Decodes the SAME GET /v1/users/profile response as EditProfileResponseDTO,
//  but only declares the fields Profile actually needs. Codable safely
//  ignores any JSON fields not declared here.

import Foundation

struct ProfileSummaryResponseDTO: Codable {
    let firstName: String
    let lastName: String
    let familyMembers: [FamilyMemberDTO]
}

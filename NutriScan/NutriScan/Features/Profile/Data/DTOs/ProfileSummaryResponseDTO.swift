//
//  ProfileSummaryResponseDTO.swift
//  NutriScan
//
//  Decodes the GET /v1/users/profile response.
//  Codable safely ignores any JSON fields not declared here.

import Foundation

struct ProfileSummaryResponseDTO: Codable {
    let firstName: String
    let lastName: String
    let familyMembers: [FamilyMemberDTO]
}

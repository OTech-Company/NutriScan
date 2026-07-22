//
//  RegisterResponseDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

struct RegisterResponseDTO: Decodable {
    let message: String
    let requiresEmailVerification: Bool
}

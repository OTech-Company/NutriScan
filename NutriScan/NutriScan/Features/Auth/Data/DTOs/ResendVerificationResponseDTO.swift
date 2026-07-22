//
//  ResendVerificationResponseDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

struct ResendVerificationResponseDTO: Decodable {
    let message: String?
    
    init(message: String?) {
        self.message = message
    }
}

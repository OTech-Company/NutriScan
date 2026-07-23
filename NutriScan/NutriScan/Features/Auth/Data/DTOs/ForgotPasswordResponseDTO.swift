//
//  ForgotPasswordResponseDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 21/07/2026.
//

import Foundation

struct ForgotPasswordResponseDTO: Decodable {
    let message: String?
    
    init(message: String?) {
        self.message = message
    }
}

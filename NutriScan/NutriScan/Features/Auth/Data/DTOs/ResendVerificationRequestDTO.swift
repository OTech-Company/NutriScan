//
//  ResendVerificationRequestDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import Foundation

struct ResendVerificationRequestDTO: Encodable {
    let email: String

    init(email: String) {
        self.email = email
    }
}

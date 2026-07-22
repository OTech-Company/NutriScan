//
//  ForgotPasswordRequestDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 21/07/2026.
//

import Foundation

struct ForgotPasswordRequestDTO: Encodable {
    let email: String

    init(email: String) {
        self.email = email
    }
}

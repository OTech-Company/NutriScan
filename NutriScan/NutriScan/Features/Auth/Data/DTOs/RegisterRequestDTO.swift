//
//  RegisterRequestDTO.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

struct RegisterRequestDTO: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    let password: String
    let allergies: [Int]
    let diseases: [Int]

    init(
        firstName: String,
        lastName: String,
        email: String,
        username: String,
        password: String,
        allergies: [Int] = [],
        diseases: [Int] = []
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.password = password
        self.allergies = allergies
        self.diseases = diseases
    }
}

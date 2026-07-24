//
//  ProfileState.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

struct ProfileState {
    var fullName: String = ""
    var familyMembers: [FamilyMember] = []
    var isLoading: Bool = false
    var errorMessage: String?
}

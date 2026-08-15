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
    var streakDays: Int = 0
    var avatarURL: String? = AppConstants.defaultUserAvatarURL
    var isLoading: Bool = false
    var errorMessage: String?
    var hasCachedProfile: Bool = false
}

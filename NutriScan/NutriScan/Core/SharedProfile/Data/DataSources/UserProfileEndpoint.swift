//
//  SharedProfileEndpoint.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

enum UserProfileEndpoint: APIEndpoint {
    case getProfile
    case updateProfile(EditProfileUpdateRequestDTO)
    case updateFamilyMembers(FamilyMembersUpdateRequestDTO)
    case getAllergies
    case getDiseases
    case uploadImage(Data)
    case uploadFamilyMemberImage(id: String, data: Data)
    case updateStreak

    var baseURL: String { AppNetworkConfig.core.baseURL }

    var path: String {
        switch self {
        case .getProfile, .updateProfile, .updateFamilyMembers:
            return "/api/v1/users/profile"
        case .uploadImage:
            return "/api/v1/users/profile/image"
        case .uploadFamilyMemberImage(let id, _):
            return "/api/v1/users/family-member/\(id)/image"
        case .getAllergies:
            return "/api/v1/allergies"
        case .getDiseases:
            return "/api/v1/diseases"
        case .updateStreak:
            return "/api/v1/users/me/daily-streak"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile, .getAllergies, .getDiseases:
            return .get
        case .updateProfile, .updateFamilyMembers,
            .uploadFamilyMemberImage:
            return .patch
        case .uploadImage, .updateStreak:
            return .post
        }
    }

    var body: RequestBody {
        switch self {
        case .getProfile, .getAllergies, .getDiseases, .updateStreak:
            return .none
        case .updateProfile(let requestDTO):
            return .json(requestDTO)
        case .updateFamilyMembers(let dto):
            return .json(dto)
        case .uploadImage(let data):
            var form = MultipartFormData()

            form.files.append(
                MultipartFormData.FilePart(
                    name: "image",
                    filename: "profile_image.jpg",
                    mimeType: "image/jpeg",
                    data: data
                ))

            return .multipart(form)
        case .uploadFamilyMemberImage(_, let data):
            var form = MultipartFormData()
            form.files.append(
                MultipartFormData.FilePart(
                    name: "image",
                    filename: "family_member_image.jpg",
                    mimeType: "image/jpeg",
                    data: data
                ))
            return .multipart(form)
        }
    }

    var requiresAuth: Bool { true }
}

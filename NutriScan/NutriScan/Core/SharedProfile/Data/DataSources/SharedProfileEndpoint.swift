//
//  SharedProfileEndpoint.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation

enum SharedProfileEndpoint: APIEndpoint {
    case getProfile
    case updateProfile(EditProfileUpdateRequestDTO)
    case updateFamilyMembers(FamilyMembersUpdateRequestDTO)
    case getAllergies
    case getDiseases
    case uploadImage(Data)
    
    var baseURL: String { AppNetworkConfig.core.baseURL }
    
    var path: String {
        switch self {
        case .getProfile, .updateProfile, .updateFamilyMembers:
            return "/api/v1/users/profile"
        case .uploadImage:
            return "/api/v1/users/profile/image"
        case .getAllergies:
            return "/api/v1/allergies"
        case .getDiseases:
            return "/api/v1/diseases"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile, .getAllergies, .getDiseases:
            return .get
        case .updateProfile, .updateFamilyMembers:
            return .patch
        case .uploadImage:
            return .post
        }
    }
    
    var body: RequestBody {
        switch self {
        case .getProfile, .getAllergies, .getDiseases:
            return .none
        case .updateProfile(let requestDTO):
            return .json(requestDTO)
        case .updateFamilyMembers(let dto):
            return .json(dto)
        case .uploadImage(let data):
            var form = MultipartFormData()
            
            form.files.append(MultipartFormData.FilePart(
                name: "image",
                filename: "profile_image.jpg",
                mimeType: "image/jpeg",
                data: data
            ))
            
            return .multipart(form)
        }
    }
    
    var requiresAuth: Bool { true }
}

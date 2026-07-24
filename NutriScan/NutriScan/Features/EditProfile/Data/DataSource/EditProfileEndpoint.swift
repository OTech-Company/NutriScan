//
//  ProfileEndpoint.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//

import Foundation

enum EditProfileEndpoint: APIEndpoint {
    case getProfile
    case updateProfile(EditProfileUpdateRequestDTO)
    case getAllergies
    case getDiseases
    
    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }
    
    var path: String {
        switch self {
        case .getProfile, .updateProfile:
            return "/api/v1/users/profile"
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
        case .updateProfile:
            return .patch
        }
    }
    
    var body: RequestBody {
        switch self {
        case .getProfile, .getAllergies, .getDiseases:
            return .none
        case .updateProfile(let requestDTO):
            return .json(requestDTO)
        }
    }
    
    // Auth token is required for all these endpoints
    var requiresAuth: Bool {
        return true
    }
}

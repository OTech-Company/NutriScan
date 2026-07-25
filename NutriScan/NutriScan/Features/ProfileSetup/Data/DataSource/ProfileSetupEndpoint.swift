//
//  ProfileSetupEndpoint.swift
//  NutriScan
//

import Foundation

enum ProfileSetupEndpoint: APIEndpoint {
    case updateProfile(ProfileSetupUpdateDTO)
    case fetchAllergyOptions
    case fetchDiseaseOptions

    var baseURL: String {
        AppNetworkConfig.core.baseURL
    }

    var path: String {
        switch self {
        case .updateProfile: return "/api/v1/users/profile"
        case .fetchAllergyOptions: return "/api/v1/allergies"
        case .fetchDiseaseOptions: return "/api/v1/diseases"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .updateProfile: return .patch
        case .fetchAllergyOptions, .fetchDiseaseOptions: return .get
        }
    }

    var body: RequestBody {
        switch self {
        case .updateProfile(let dto): return .json(dto)
        case .fetchAllergyOptions, .fetchDiseaseOptions: return .none
        }
    }
}

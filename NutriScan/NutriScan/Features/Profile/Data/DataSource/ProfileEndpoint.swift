//
//  ProfileEndpoint.swift
//  NutriScan
//

import Foundation

enum ProfileEndpoint: APIEndpoint {
    case getProfile
    case updateFamilyMembers(FamilyMembersUpdateRequestDTO)

    var baseURL: String { AppNetworkConfig.core.baseURL }

    var path: String {
        "/api/v1/users/profile"
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile: return .get
        case .updateFamilyMembers: return .patch
        }
    }

    var body: RequestBody {
        switch self {
        case .getProfile: return .none
        case .updateFamilyMembers(let dto): return .json(dto)
        }
    }

    var requiresAuth: Bool { true }
}

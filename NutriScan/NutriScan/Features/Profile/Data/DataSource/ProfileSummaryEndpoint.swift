//
//  ProfileSummaryEndpoint.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation

enum ProfileSummaryEndpoint: APIEndpoint {
    case getProfileSummary
    case updateFamilyMembers(FamilyMembersUpdateRequestDTO)

    var baseURL: String { AppNetworkConfig.core.baseURL }

    var path: String {
        "/api/v1/users/profile"
    }

    var method: HTTPMethod {
        switch self {
        case .getProfileSummary: return .get
        case .updateFamilyMembers: return .patch
        }
    }

    var body: RequestBody {
        switch self {
        case .getProfileSummary: return .none
        case .updateFamilyMembers(let dto): return .json(dto)
        }
    }

    var requiresAuth: Bool { true }
}

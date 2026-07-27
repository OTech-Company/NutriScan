import Foundation

enum FavoritesEndpoint: APIEndpoint {
    case getFavorites(page: Int, size: Int)
    
    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }
    
    var path: String {
        switch self {
        case .getFavorites:
            return "/api/v1/scans/favorites"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getFavorites(let page, let size):
            return [
                "page": "\(page)",
                "size": "\(size)"
            ]
        }
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    var requiresAuth: Bool {
        return true
    }
}

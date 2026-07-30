import Foundation

enum FavoritesEndpoint: APIEndpoint {
    case getFavorites(page: Int, size: Int)
    case removeFavorite(scanId: String)
    
    var baseURL: String {
        return AppNetworkConfig.core.baseURL
    }
    
    var path: String {
        switch self {
        case .getFavorites:
            return "/api/v1/scans/favorites"
        case .removeFavorite(let scanId):
            return "/api/v1/scans/\(scanId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getFavorites:
            return .get
        case .removeFavorite:
            return .patch
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getFavorites(let page, let size):
            return [
                "page": "\(page)",
                "size": "\(size)"
            ]
        case .removeFavorite:
            return nil
        }
    }
    
    var body: RequestBody {
        switch self {
        case .getFavorites:
            return .none
        case .removeFavorite:
            return .json(["favorite": false])
        }
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    var requiresAuth: Bool {
        return true
    }
}

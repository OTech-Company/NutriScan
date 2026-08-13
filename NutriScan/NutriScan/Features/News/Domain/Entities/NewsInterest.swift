import Foundation

/// A profile-derived topic that can constrain the news feed.
enum NewsInterest: Hashable, Identifiable {
    case all
    case allergy(id: Int, name: String)
    case disease(id: Int, name: String)

    var id: String {
        switch self {
        case .all:
            return "all"
        case .allergy(let id, _):
            return "allergy-\(id)"
        case .disease(let id, _):
            return "disease-\(id)"
        }
    }

    var displayName: String {
        switch self {
        case .all:
            return "All"
        case .allergy(_, let name), .disease(_, let name):
            return name
        }
    }

    var queryTerm: String? {
        switch self {
        case .all:
            return nil
        case .allergy(_, let name):
            return "\(name) allergy"
        case .disease(_, let name):
            return "\(name) disease"
        }
    }
}

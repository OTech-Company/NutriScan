import Foundation

struct FlaggedIngredient: Identifiable, Equatable {
    let id = UUID()
    let ingredient: String
    let reason: String
    let type: FlagType

    enum FlagType: String, Decodable {
        case allergy = "ALLERGY"
        case additive = "ADDITIVE"
        case healthCondition = "HEALTH_CONDITION"
        case concern = "CONCERN"

        var displayName: String {
            switch self {
            case .allergy: return "Allergy"
            case .additive: return "Additive"
            case .healthCondition: return "Health Condition"
            case .concern: return "Concern"
            }
        }

        var icon: String {
            switch self {
            case .allergy: return "exclamationmark.triangle.fill"
            case .additive: return "questionmark.circle.fill"
            case .healthCondition: return "heart.circle.fill"
            case .concern: return "exclamationmark.circle.fill"
            }
        }
    }

    static func == (lhs: FlaggedIngredient, rhs: FlaggedIngredient) -> Bool {
        lhs.id == rhs.id
    }
}

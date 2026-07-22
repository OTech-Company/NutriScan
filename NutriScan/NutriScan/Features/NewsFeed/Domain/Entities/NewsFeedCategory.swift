//
//  NewsFeedCategory.swift
//  NewsFeed (Feature)
//

import Foundation

/// Curated topics surfaced as filter chips. `"health"` maps directly to
/// NewsAPI's `top-headlines?category=health`; the rest are implemented
/// as curated search queries against `/v2/everything` so the app can
/// offer a richer set of nutrition-focused topics than the API's fixed
/// category list provides.
enum NewsFeedCategory: String, CaseIterable, Identifiable {
    case topHealth = "Top Health"
    case nutrition = "Nutrition"
    case wellness = "Wellness"
    case diseasePrevention = "Disease Prevention"
    case fitness = "Fitness"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var searchQuery: String? {
        switch self {
        case .topHealth: return nil
        case .nutrition: return "nutrition OR diet OR vitamins OR supplements"
        case .wellness: return "wellness OR mental health OR sleep"
        case .diseasePrevention: return "disease prevention OR outbreak OR immunity"
        case .fitness: return "fitness OR exercise OR workout"
        }
    }
}

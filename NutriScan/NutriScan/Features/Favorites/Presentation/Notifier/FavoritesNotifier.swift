//
//  FavoritesNotifier.swift
//  NutriScan
//

import Foundation

/// A shared singleton that tracks whether the Favorites data needs to be refreshed.
/// Any screen that adds or removes a favorite should call `FavoritesNotifier.shared.setNeedsRefresh()`
/// so that the Favorites screen re-fetches data the next time it appears.
///
/// Usage from other screens:
///   FavoritesNotifier.shared.setNeedsRefresh()
///
@Observable
final class FavoritesNotifier {
    static let shared = FavoritesNotifier()
    
    private(set) var needsRefresh: Bool = true
    
    private init() {}
    
    /// Call this from any screen that modifies favorites (add/remove).
    func setNeedsRefresh() {
        needsRefresh = true
    }
    
    /// Called by the FavoritesViewModel after a successful fetch.
    func didRefresh() {
        needsRefresh = false
    }
}

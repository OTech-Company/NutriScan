//
//  AnyRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

/// Type-erased wrapper so routes from different, unrelated features
/// (each with its own concrete `Route` enum) can live together inside
/// a single `NavigationPath` / sheet / fullScreenCover state, while
/// SwiftUI still gets one concrete `Hashable` type to key off of.
///
/// This is the piece that makes "zero modification" possible: the
/// destination view is captured as a closure at creation time, so the
/// root of the app only ever needs to register `AnyRoute.self` once —
/// never the individual feature route types.
struct AnyRoute: Hashable, Identifiable {
    let id = UUID()

    /// Used for equality/hashing so `NavigationPath` behaves correctly
    /// (e.g. popping back to a specific route, diffing, etc).
    private let base: AnyHashable

    private let _destination: () -> AnyView

    init<R: Route>(_ route: R) {
        self.base = AnyHashable(route)
        self._destination = { AnyView(route.destination) }
    }

    @ViewBuilder
    func view() -> some View {
        _destination()
    }

    static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.base == rhs.base
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }
}
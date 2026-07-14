//
//  AppRouter.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

/// Owns all navigation state for a single navigation stack (e.g. one tab,
/// or the whole app if you're not using tabs).
///
/// Features never subclass or modify this file. They just call
/// `router.push(SomeFeatureRoute.someCase)` from anywhere that has
/// access to the router (typically via `@EnvironmentObject`).
final class AppRouter: ObservableObject {

    // MARK: - Push navigation (NavigationStack)

    @Published var path = NavigationPath()

    func push<R: Route>(_ route: R) {
        path.append(AnyRoute(route))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func pop(_ count: Int) {
        path.removeLast(min(count, path.count))
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    // MARK: - Modal presentation (sheet)

    @Published var sheetRoute: AnyRoute?

    func presentSheet<R: Route>(_ route: R) {
        sheetRoute = AnyRoute(route)
    }

    func dismissSheet() {
        sheetRoute = nil
    }

    // MARK: - Modal presentation (full screen cover)

    @Published var fullScreenRoute: AnyRoute?

    func presentFullScreen<R: Route>(_ route: R) {
        fullScreenRoute = AnyRoute(route)
    }

    func dismissFullScreen() {
        fullScreenRoute = nil
    }
}
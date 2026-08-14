//
//  AppRouter.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import Combine
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
        guard count > 0 else { return }
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

/// Owns the independent routers used by the five main tabs.
///
/// Router changes are forwarded so the main shell can derive its custom tab-bar
/// visibility from the selected tab without relying on process-wide state.
final class MainTabNavigationStore: ObservableObject {
    private let routers: [AppTab: AppRouter]
    private var routerSubscriptions: Set<AnyCancellable> = []

    init(routers: [AppTab: AppRouter]? = nil) {
        self.routers = routers ?? Dictionary(
            uniqueKeysWithValues: AppTab.allCases.map { ($0, AppRouter()) }
        )

        self.routers.values.forEach { router in
            router.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &routerSubscriptions)
        }
    }

    func router(for tab: AppTab) -> AppRouter {
        guard let router = routers[tab] else {
            preconditionFailure("Missing router for main tab: \(tab)")
        }
        return router
    }

    func isAtRoot(_ tab: AppTab) -> Bool {
        router(for: tab).path.isEmpty
    }

    func resetAll() {
        routers.values.forEach { router in
            router.popToRoot()
            router.dismissSheet()
            router.dismissFullScreen()
        }
    }
}

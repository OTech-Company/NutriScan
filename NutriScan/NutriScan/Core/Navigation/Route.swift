//
//  Route.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

/// Every screen destination in the app conforms to this protocol.
///
/// Each feature defines its own `Route` enum (e.g. `HomeRoute`,
/// `ProfileRoute`) and — crucially — describes how to build its own
/// destination view right there in the same file, via `destination`.
///
/// Because of this, `Core/Navigation` never needs to know about any
/// feature's screens, and adding a new route NEVER requires touching
/// this file, `AppRouter.swift`, or the app's composition root.
protocol Route: Hashable {
    associatedtype Destination: View
    @ViewBuilder var destination: Destination { get }
}
//
//  AppFlow.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import Foundation

/// The top-level app states. Unlike `Route` (used for push navigation
/// within a flow), switching between these is a full replacement of
/// the screen — there's no "back" from Main to Auth, for example.
enum AppFlow: Equatable {
    case splash
    case onboarding
    case auth
    case main
}
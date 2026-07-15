//
//  AppBackgroundModifier.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 15/07/2026.
//

import Foundation
import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            (colorScheme == .light ? Color.Teal.teal100 : Color.Teal.teal1600)
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
}

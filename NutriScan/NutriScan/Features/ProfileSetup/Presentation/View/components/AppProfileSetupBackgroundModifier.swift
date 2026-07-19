//
//  AppProfileSetupBackgroundModifier.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 18/07/2026.
//

import SwiftUI

struct AppProfileSetupBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            (colorScheme == .light ? Color.white : Color.Teal.teal1600)
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func appProfileSetupBackground() -> some View {
        modifier(AppProfileSetupBackgroundModifier())
    }
}

//
//  ProfileHeaderDecoration.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

struct ProfileHeaderDecoration: View {
    var body: some View {
        Circle()
            .fill(Color.ProfileSemantics.headerDecoration)
            .frame(
                width: ProfileSemantics.Sizes.decorationCircleSize,
                height: ProfileSemantics.Sizes.decorationCircleSize
            )
            .offset(
                x: ProfileSemantics.Spacing.decorationOffsetX,
                y: ProfileSemantics.Spacing.decorationOffsetY
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .clipped()
    }
}

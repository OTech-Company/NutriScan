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
            .frame(width: 220, height: 220)
            // Positive X pushes it off the right edge; Negative Y pushes it off the top edge.
            // You can tweak these numbers to change how much of the circle is visible.
            .offset(x: 90, y: -100)
            // Anchors the content strictly to the top right of whatever container it is placed in.
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .clipped()
    }
}

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
            .offset(x: 90, y: -140)
            .clipped()
    }
}

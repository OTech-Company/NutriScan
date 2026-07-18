//
//  SelectionIndicatorTriangle.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//

import SwiftUI

struct SelectionIndicatorView: View {
    
    var body: some View {
        Image(systemName: "triangle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 12, height: 10)
            .rotationEffect(.degrees(180))
            .foregroundStyle(Color.ProfileSetupSemantic.accent)
    }

    
}

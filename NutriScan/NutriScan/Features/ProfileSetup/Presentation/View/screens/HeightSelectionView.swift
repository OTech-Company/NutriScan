//
//  HeightSelectionView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/07/2026.
//

import SwiftUI

struct HeightSelectionView: View {
    @Binding var height: Int

    var body: some View {
        VStack(spacing: 24) {
            ValueCard(value: height, style: .boxed, sideCount: 1)
            RulerDial(value: $height, unit: .height)
        }
    }
}

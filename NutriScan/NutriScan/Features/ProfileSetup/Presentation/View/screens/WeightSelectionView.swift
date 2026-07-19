//
//  WeightSelectionView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/07/2026.
//

import SwiftUI

struct WeightSelectionView: View {
    @Binding var weight: Int

    var body: some View {
        VStack(spacing: 24) {
            ValueCard(value: weight, style: .plain, sideCount: 1)
            RulerDial(value: $weight, unit: .weight)
        }
    }
}

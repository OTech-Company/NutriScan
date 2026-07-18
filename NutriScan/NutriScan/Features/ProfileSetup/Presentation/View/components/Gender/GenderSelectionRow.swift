//
//  GenderSelectionRow.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//

import SwiftUI
struct GenderSelectionRow: View {
    @Binding var selectedGender: Gender

    var body: some View {
        HStack(alignment: .bottom, spacing: 22) {
            genderCard(for: .female)
            genderCard(for: .male)
        }
    }

    @ViewBuilder
    private func genderCard(for gender: Gender) -> some View {
        VStack(spacing: 8) {
            if selectedGender == gender {
                SelectionIndicatorView()
            } else {
                Color.clear.frame(width: 14, height: 8)
            }

            GenderSelectionCard(
                gender: gender,
                isSelected: selectedGender == gender,
                action: { selectedGender = gender }
            )
        }
    }
}

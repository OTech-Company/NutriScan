//
//  AllergiesSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct AllergiesSectionView: View {
    let allAllergies: [String]
    @Binding var selected: Set<String>
    var onAddOther: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Allergies")
                .font(Font.AppFont.subtitle2)
                .foregroundColor(Color.EditProfileSemantics.sectionTitle)

            FlowChipsLayout(
                horizontalSpacing: EditProfileSemantics.Spacing.chipSpacing,
                verticalSpacing: EditProfileSemantics.Spacing.chipSpacing
            ) {
                ForEach(allAllergies, id: \.self) { condition in
                    SelectableChip(
                        title: condition,
                        state: selected.contains(condition) ? .selected : .normal,
                        action: { toggle(condition) }
                    )
                }
                SelectableChip(title: "Other", state: .add, action: onAddOther)
            }
        }
    }

    private func toggle(_ allergy: String) {
        withAnimation(EditProfileSemantics.Animation.chipSelection) {
            if selected.contains(allergy) {
                selected.remove(allergy)
            } else {
                selected.insert(allergy)
            }
        }
    }
}

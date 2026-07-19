//
//  ConditionsSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct ConditionsSectionView: View {
    let allConditions: [String]
    @Binding var selected: Set<String>
    var onAddOther: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Chronic Conditions")
                .font(Font.AppFont.subtitle2)
                .foregroundColor(Color.EditProfileSemantics.sectionTitle)

            FlowChipsLayout(
                horizontalSpacing: EditProfileSemantics.Spacing.chipSpacing,
                verticalSpacing: EditProfileSemantics.Spacing.chipSpacing
            ) {
                ForEach(allConditions, id: \.self) { condition in
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

    private func toggle(_ condition: String) {
        withAnimation(EditProfileSemantics.Animation.chipSelection) {
            if selected.contains(condition) { selected.remove(condition) }
            else { selected.insert(condition) }
        }
    }
}


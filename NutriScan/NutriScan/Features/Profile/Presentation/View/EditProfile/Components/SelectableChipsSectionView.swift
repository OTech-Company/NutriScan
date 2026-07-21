//
//  SelectableChipsSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct SelectableChipsSectionView: View {
    let title: String
    let predefinedItems: [String]
    @Binding var customItems: [String]
    @Binding var selected: Set<String>
    
    var onAddOther: () -> Void
    let onRemoveCustom: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Font.AppFont.title3)
                .foregroundColor(Color.EditProfileSemantics.sectionTitle)

            FlowChipsLayout(
                horizontalSpacing: EditProfileSemantics.Spacing.chipSpacing,
                verticalSpacing: EditProfileSemantics.Spacing.chipSpacing
            ) {
                // 1. Render Default Chips
                ForEach(predefinedItems, id: \.self) { item in
                    SelectableChip(
                        title: item,
                        state: selected.contains(item) ? .selected : .normal,
                        action: { toggle(item) }
                    )
                }
                
                // 2. Render User Custom Chips
                ForEach(customItems, id: \.self) { item in
                    SelectableChip(
                        title: item,
                        state: .custom(isSelected: selected.contains(item)),
                        action: { toggle(item) },
                        onRemove: { onRemoveCustom(item) }
                    )
                }
                
                // 3. Render "+ Other" Button
                SelectableChip(title: "Other", state: .add, action: onAddOther)
            }
        }
    }

    private func toggle(_ item: String) {
        withAnimation(EditProfileSemantics.Animation.chipSelection) {
            if selected.contains(item) {
                selected.remove(item)
            } else {
                selected.insert(item)
            }
        }
    }
}

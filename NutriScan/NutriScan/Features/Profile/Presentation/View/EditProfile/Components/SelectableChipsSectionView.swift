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
    
    @Binding var isAdding: Bool
    @Binding var inputText: String
    
    let onSubmit: () -> Void
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
                
                ForEach(customItems, id: \.self) { item in
                    SelectableChip(
                        title: item,
                        state: .custom(isSelected: selected.contains(item)),
                        action: { toggle(item) },
                        onRemove: { onRemoveCustom(item) }
                    )
                }
                
                if isAdding {
                    InputChip(text: $inputText, onSubmit: onSubmit)
                } else {
                    SelectableChip(title: "Other", state: .add, action: { isAdding = true })
                }
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

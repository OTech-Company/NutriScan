//
//  SelectableChipsSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//

import SwiftUI

struct SelectableChipsSectionView: View {
    let title: String
    let items: [ProfileChipItem]
    
    var onAddOther: () -> Void
    let onToggle: (String) -> Void
    let onRemove: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Font.AppFont.title3)
                .foregroundColor(Color.EditProfileSemantics.sectionTitle)

            FlowChipsLayout(
                horizontalSpacing: EditProfileSemantics.Spacing.chipSpacing,
                verticalSpacing: EditProfileSemantics.Spacing.chipSpacing
            ) {
                ForEach(items, id: \.name) { chip in
                    if chip.isNewlyAdded {
                        // Newly added from search: shows 'x', selected by default
                        SelectableChip(
                            title: chip.name,
                            state: .custom(isSelected: chip.isNewlyAdded),
                            action: { }, // Tap does nothing, user must click 'x'
                            onRemove: { onRemove(chip.name) }
                        )
                    } else {
                        // Backend originated: no 'x', toggles selection state on tap
                        SelectableChip(
                            title: chip.name,
                            state: .custom(isSelected: chip.isSelected),
                            action: { onToggle(chip.name) }
                        )
                    }
                }
                
                SelectableChip(title: "Other", state: .add, action: onAddOther)
            }
        }
    }
}

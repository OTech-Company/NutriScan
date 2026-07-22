//
//  SelectableChip.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//

import SwiftUI

enum ChipState: Equatable {
    case normal
    case selected
    case add
    case custom(isSelected: Bool)
}

struct SelectableChip: View {
    let title: String
    var state: ChipState = .normal
    let action: () -> Void
    var onRemove: (() -> Void)? = nil

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if state == .add {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .semibold))
                }

                Text(title)
                    .font(Font.AppFont.textSecondary)

                // Only show the remove control when a removal handler was
                // actually provided — not just because the state is .custom.
                if let onRemove {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.leading, 4)
                        .onTapGesture {
                            onRemove()
                        }
                }
            }
            .foregroundColor(textColor)
            .padding(.horizontal, SelectableChipConstants.horizontalPadding)
            .frame(height: SelectableChipConstants.height)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(
                    cornerRadius: SelectableChipConstants.cornerRadius
                )
                .strokeBorder(
                    borderColor,
                    style: StrokeStyle(
                        lineWidth: 1, dash: state == .add ? [4, 3] : [])
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: SelectableChipConstants.cornerRadius))
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {
        switch state {
        case .normal, .add, .custom(false):
            return Color.ChipSemantics.defaultBackground
        case .selected, .custom(true):
            return Color.ChipSemantics.selectedBackground
        }
    }

    private var borderColor: Color {
        switch state {
        case .normal, .custom(false): return Color.ChipSemantics.defaultBorder
        case .selected, .custom(true): return Color.ChipSemantics.selectedBorder
        case .add: return Color.ChipSemantics.addBorder
        }
    }

    private var textColor: Color {
        switch state {
        case .normal, .custom(false): return Color.ChipSemantics.defaultText
        case .selected, .custom(true): return Color.ChipSemantics.selectedText
        case .add: return Color.ChipSemantics.addText
        }
    }
}

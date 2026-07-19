//
//  SelectableChip.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

enum ChipState {
    case normal
    case selected
    case add  // dashed "+ Other" style
}
struct SelectableChip: View {
    let title: String
    var state: ChipState = .normal
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if state == .add {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .semibold))
                }
                Text(title)
                    .font(Font.AppFont.textSecondary)
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
                        lineWidth: 1, dash: state == .add ? [4, 3] : []))
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: SelectableChipConstants.cornerRadius))
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {
        switch state {
        case .normal, .add: return Color.ChipSemantics.defaultBackground
        case .selected: return Color.ChipSemantics.selectedBackground
        }
    }

    private var borderColor: Color {
        switch state {
        case .normal: return Color.ChipSemantics.defaultBorder
        case .selected: return Color.ChipSemantics.selectedBorder
        case .add: return Color.ChipSemantics.addBorder
        }
    }

    private var textColor: Color {
        switch state {
        case .normal: return Color.ChipSemantics.defaultText
        case .selected: return Color.ChipSemantics.selectedText
        case .add: return Color.ChipSemantics.addText
        }
    }
}

//
//  CategoryChipView.swift
//  NewsFeed (Feature)
//

import SwiftUI

struct CategoryChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(NewsFeedTypography.chip)
                .foregroundStyle(isSelected ? Color.white : NewsFeedPalette.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(isSelected ? NewsFeedPalette.accent : NewsFeedPalette.surface)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : NewsFeedPalette.divider, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        CategoryChipView(title: "Top Health", isSelected: true) {}
        CategoryChipView(title: "Nutrition", isSelected: false) {}
    }
    .padding()
    .background(NewsFeedPalette.background)
}

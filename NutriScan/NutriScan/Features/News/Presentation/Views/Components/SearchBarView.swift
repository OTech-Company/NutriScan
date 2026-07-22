//
//  SearchBarView.swift
//  NewsFeed (Feature)
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String = "Search health & nutrition news"

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(NewsFeedPalette.textTertiary)

            TextField(placeholder, text: $text)
                .font(NewsFeedTypography.cardBody)
                .focused($isFocused)
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                    isFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(NewsFeedPalette.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(NewsFeedPalette.divider, lineWidth: 1)
        )
    }
}

#Preview {
    SearchBarView(text: .constant(""))
        .padding()
        .background(NewsFeedPalette.background)
}

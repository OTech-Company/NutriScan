//
//  ArticleCardSkeletonView.swift
//  NewsFeed (Feature)
//

import SwiftUI

struct ArticleCardSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(NewsFeedPalette.surfaceMuted)
                .frame(height: 170)

            VStack(alignment: .leading, spacing: 10) {
                Capsule().fill(NewsFeedPalette.surfaceMuted).frame(width: 90, height: 10)
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.surfaceMuted).frame(height: 14)
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.surfaceMuted).frame(width: 220, height: 14)
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.surfaceMuted).frame(height: 10)
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.surfaceMuted).frame(width: 160, height: 10)
            }
            .padding(14)
        }
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: NewsFeedMetrics.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: NewsFeedMetrics.cardCornerRadius, style: .continuous)
                .stroke(NewsFeedPalette.divider, lineWidth: 1)
        )
        .shimmering()
    }
}

struct ArticleFeedSkeletonList: View {
    var body: some View {
        VStack(spacing: NewsFeedMetrics.cardSpacing) {
            ForEach(0..<4, id: \.self) { _ in
                ArticleCardSkeletonView()
            }
        }
        .padding(.horizontal, NewsFeedMetrics.screenPadding)
    }
}

#Preview {
    ScrollView { ArticleFeedSkeletonList() }
        .background(NewsFeedPalette.background)
}

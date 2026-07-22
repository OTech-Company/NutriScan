//
//  ArticleCardView.swift
//  NewsFeed (Feature)
//

import SwiftUI

struct ArticleCardView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            articleImage
                .frame(height: 170)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                sourceRow

                Text(article.title)
                    .font(NewsFeedTypography.cardTitle)
                    .foregroundStyle(NewsFeedPalette.textPrimary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                if let description = article.description, !description.isEmpty {
                    Text(description)
                        .font(NewsFeedTypography.cardBody)
                        .foregroundStyle(NewsFeedPalette.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(14)
        }
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: NewsFeedMetrics.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: NewsFeedMetrics.cardCornerRadius, style: .continuous)
                .stroke(NewsFeedPalette.divider, lineWidth: 1)
        )
        .customTealShadow()
    }

    private var sourceRow: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(NewsFeedPalette.accent)
                .frame(width: 6, height: 6)

            Text(article.source.name.uppercased())
                .font(NewsFeedTypography.eyebrow)
                .foregroundStyle(NewsFeedPalette.accentStrong)
                .lineLimit(1)

            Spacer()

            Text(article.publishedAt.relativeShortString)
                .font(NewsFeedTypography.caption)
                .foregroundStyle(NewsFeedPalette.textTertiary)
        }
    }

    @ViewBuilder
    private var articleImage: some View {
        if let imageURL = article.imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    imagePlaceholder
                case .empty:
                    Rectangle()
                        .fill(NewsFeedPalette.surfaceMuted)
                        .shimmering()
                @unknown default:
                    imagePlaceholder
                }
            }
        } else {
            imagePlaceholder
        }
    }

    private var imagePlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [Color.Teal.teal200, Color.Teal.teal400],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "newspaper")
                .font(.system(size: 32))
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}

#Preview {
    ScrollView {
        ArticleCardView(article: .preview)
            .padding()
    }
    .background(NewsFeedPalette.background)
}

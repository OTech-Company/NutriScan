import SwiftUI

struct CompactArticleRow: View {
    let article: Article

    var body: some View {
        Button {
            // handled externally
        } label: {
            HStack(spacing: 12) {
                articleThumbnail

                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(NewsFeedTypography.cardTitle)
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 6) {
                        Circle()
                            .fill(NewsFeedPalette.accent)
                            .frame(width: 5, height: 5)
                        Text(article.source.name)
                            .font(NewsFeedTypography.eyebrow)
                            .foregroundStyle(NewsFeedPalette.textSecondary)
                            .lineLimit(1)
                        Text("·")
                            .foregroundStyle(NewsFeedPalette.textTertiary)
                        Text(article.publishedAt.relativeShortString)
                            .font(NewsFeedTypography.caption)
                            .foregroundStyle(NewsFeedPalette.textTertiary)
                    }
                }
            }
            .padding(12)
            .background(NewsFeedPalette.surface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(NewsFeedPalette.divider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var articleThumbnail: some View {
        if let imageURL = article.imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    thumbnailPlaceholder
                }
            }
            .frame(width: 80, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        } else {
            thumbnailPlaceholder
                .frame(width: 80, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }

    private var thumbnailPlaceholder: some View {
        ZStack {
            NewsFeedPalette.surfaceMuted
            Image(systemName: "photo")
                .font(.system(size: 18))
                .foregroundStyle(NewsFeedPalette.textTertiary)
        }
    }
}

struct CompactArticleRowSkeleton: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(NewsFeedPalette.surfaceMuted)
                .frame(width: 80, height: 72)

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(NewsFeedPalette.surfaceMuted)
                    .frame(height: 14)
                RoundedRectangle(cornerRadius: 4)
                    .fill(NewsFeedPalette.surfaceMuted)
                    .frame(width: 180, height: 14)
                RoundedRectangle(cornerRadius: 4)
                    .fill(NewsFeedPalette.surfaceMuted)
                    .frame(width: 120, height: 10)
            }
        }
        .padding(12)
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(NewsFeedPalette.divider, lineWidth: 1)
        )
        .shimmering()
    }
}

#Preview {
    VStack(spacing: 12) {
        CompactArticleRow(article: .preview)
        CompactArticleRowSkeleton()
    }
    .padding()
    .background(NewsFeedPalette.background)
}

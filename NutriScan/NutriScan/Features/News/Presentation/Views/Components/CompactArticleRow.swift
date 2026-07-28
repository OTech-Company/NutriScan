import SwiftUI

struct CompactArticleRow: View {
    let article: Article

    var body: some View {
        HStack(spacing: 14) {
            articleThumbnail
                .frame(width: 100, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(categoryName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(NewsFeedPalette.accent)

                Text(article.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(NewsFeedPalette.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 6) {
                    Circle()
                        .fill(NewsFeedPalette.accentSoft)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(NewsFeedPalette.accent)
                        )

                    Text(article.source.name)
                        .font(.system(size: 12))
                        .foregroundStyle(NewsFeedPalette.textSecondary)
                        .lineLimit(1)

                    Text("•")
                        .foregroundStyle(NewsFeedPalette.textTertiary)

                    Text(article.publishedAt.relativeShortString)
                        .font(.system(size: 12))
                        .foregroundStyle(NewsFeedPalette.textTertiary)
                }
            }
        }
        .padding(10)
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(NewsFeedPalette.divider, lineWidth: 1)
        )
    }

    private var categoryName: String {
        let title = article.title.lowercased()
        if title.contains("sport") || title.contains("football") || title.contains("tennis") || title.contains("race") {
            return "Sports"
        } else if title.contains("health") || title.contains("diet") || title.contains("nutrition") {
            return "Health"
        } else if title.contains("education") || title.contains("school") || title.contains("university") {
            return "Education"
        } else if title.contains("world") || title.contains("country") || title.contains("international") {
            return "World"
        }
        return "News"
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
        } else {
            thumbnailPlaceholder
        }
    }

    private var thumbnailPlaceholder: some View {
        ZStack {
            NewsFeedPalette.surfaceMuted
            Image(systemName: "photo")
                .font(.system(size: 20))
                .foregroundStyle(NewsFeedPalette.textTertiary)
        }
    }
}

struct CompactArticleRowSkeleton: View {
    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14)
                .fill(NewsFeedPalette.surfaceMuted)
                .frame(width: 100, height: 90)

            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(NewsFeedPalette.accentSoft)
                    .frame(width: 50, height: 10)
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
        .padding(10)
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
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

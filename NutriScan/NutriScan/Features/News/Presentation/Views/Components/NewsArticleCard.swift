import SwiftUI
import Shimmer

struct NewsArticleCard: View {
    let article: Article
    let filterLabel: String
    let onOpen: () -> Void
    let onShare: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onOpen) {
                articleImage
                    .frame(width: 137, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(article.title)
            .accessibilityHint("Opens article details")

            VStack(alignment: .leading, spacing: 0) {
                Button(action: onOpen) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(article.title)
                            .font(NewsFeedTypography.articleTitle)
                            .foregroundStyle(NewsFeedPalette.textPrimary)
                            .lineLimit(5)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 8)

                        if let author = article.author, !author.isEmpty {
                            Text("By \(author)")
                                .font(NewsFeedTypography.articleCaption)
                                .foregroundStyle(NewsFeedPalette.textSecondary)
                                .lineLimit(2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityHint("Opens article details")

                Spacer(minLength: 6)

                HStack(spacing: 10) {
                    Text(filterLabel)
                        .font(NewsFeedTypography.metadataStrong)
                        .foregroundStyle(NewsFeedPalette.metadataAccent)
                        .lineLimit(1)

                    Circle()
                        .fill(NewsFeedPalette.metadataSecondary)
                        .frame(width: 6, height: 6)

                    Text(article.publishedAt.relativeShortString)
                        .font(NewsFeedTypography.metadata)
                        .foregroundStyle(NewsFeedPalette.metadataSecondary)
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    Menu {
                        Button("Open Article", systemImage: "doc.text") {
                            onOpen()
                        }
                        Button("Share", systemImage: "square.and.arrow.up") {
                            onShare()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(NewsFeedPalette.menuIcon)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel("Article actions")
                }
                .frame(height: 32)
            }
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140, alignment: .topLeading)
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 156, maxHeight: 156)
        .background(NewsFeedPalette.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: NewsFeedPalette.cardShadow, radius: 10, x: 0, y: 10)
    }

    private var articleImage: some View {
        CachedImage(
            urlString: article.imageURLString,
            failureImageName: "photo_placeholder",
            contentMode: .fit,
            failurePadding: 36
        )
        .foregroundStyle(NewsFeedPalette.imagePlaceholderForeground)
        .frame(width: 137, height: 140)
        .clipped()
        .accessibilityHidden(true)
    }
}

struct NewsArticleCardSkeleton: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(NewsFeedPalette.skeleton)
                .frame(width: 137, height: 140)

            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.skeleton).frame(height: 12)
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.skeleton).frame(height: 12)
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.skeleton).frame(width: 118, height: 12)
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.skeleton).frame(width: 92, height: 10)
                Spacer()
                RoundedRectangle(cornerRadius: 4).fill(NewsFeedPalette.skeleton).frame(height: 12)
            }
            .padding(.vertical, 8)
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 156, maxHeight: 156)
        .background(NewsFeedPalette.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shimmering(active: !reduceMotion)
        .accessibilityHidden(true)
    }
}

#Preview("Article Card") {
    NewsArticleCard(article: .preview, filterLabel: "For You", onOpen: {}, onShare: {})
        .padding(22)
        .background(NewsFeedPalette.background)
}

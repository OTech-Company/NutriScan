import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @EnvironmentObject var router: AppRouter
    @State private var isBookmarked = false

    var body: some View {
        ZStack {
            NewsFeedPalette.background.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    heroSection
                    contentSection
                        .padding(.bottom, 32)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .overlay(alignment: .top) {
            topBar
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.3))
                    .clipShape(Circle())
            }

            Spacer()

            HStack(spacing: 12) {
                Button {
                    isBookmarked.toggle()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(.black.opacity(0.3))
                        .clipShape(Circle())
                }

                Button {} label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(.black.opacity(0.3))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            heroImage
                .frame(height: 340)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.75), .black.opacity(0.3), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 340)

            VStack(alignment: .leading, spacing: 8) {
                Text(categoryName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(NewsFeedPalette.accent)
                    .clipShape(Capsule())

                Text(article.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    Text("Trending")
                        .foregroundStyle(.white.opacity(0.7))
                    Text("•")
                        .foregroundStyle(.white.opacity(0.5))
                    Text(article.publishedAt.relativeShortString)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .font(.system(size: 13))
            }
            .padding(20)
            .padding(.bottom, 8)
        }
        .frame(height: 340)
    }

    // MARK: - Content

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sourceRow

            Divider()
                .background(NewsFeedPalette.divider)

            // Author row
            if let author = article.author, !author.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(NewsFeedPalette.accent)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Author")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(NewsFeedPalette.textTertiary)
                            .textCase(.uppercase)
                        Text(author)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(NewsFeedPalette.textPrimary)
                    }
                }

                Divider()
                    .background(NewsFeedPalette.divider)
            }

            // Published date
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundStyle(NewsFeedPalette.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Published")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(NewsFeedPalette.textTertiary)
                        .textCase(.uppercase)
                    Text(article.publishedAt.formatted(date: .long, time: .shortened))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                }
            }

            Divider()
                .background(NewsFeedPalette.divider)

            // Description
            if let description = article.description, !description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Summary")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(NewsFeedPalette.textTertiary)
                        .textCase(.uppercase)
                        .tracking(0.5)

                    Text(description)
                        .font(.system(size: 16))
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                        .lineSpacing(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            // Full content (cleaned of NewsAPI truncation marker)
            if let raw = article.content, !raw.isEmpty {
                let cleaned = raw.replacingOccurrences(
                    of: #"\s*\[\+\d+ chars\]"#,
                    with: "",
                    options: .regularExpression
                )
                if !cleaned.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Article")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(NewsFeedPalette.textTertiary)
                            .textCase(.uppercase)
                            .tracking(0.5)

                        Text(cleaned)
                            .font(.system(size: 16))
                            .foregroundStyle(NewsFeedPalette.textPrimary)
                            .lineSpacing(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            // Read full article button
            if let url = article.articleURL {
                Link(destination: url) {
                    HStack(spacing: 8) {
                        Text("Read Full Article")
                            .font(.system(size: 15, weight: .semibold))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(NewsFeedPalette.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.top, -24)
    }

    // MARK: - Source Row

    private var sourceRow: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(NewsFeedPalette.accentSoft)
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(article.source.name.prefix(1)).uppercased())
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(NewsFeedPalette.accent)
                )

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(article.source.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(NewsFeedPalette.accent)
                }
            }

            Spacer()

            Text(article.publishedAt.relativeShortString)
                .font(.system(size: 13))
                .foregroundStyle(NewsFeedPalette.textTertiary)
        }
    }

    // MARK: - Hero Image

    @ViewBuilder
    private var heroImage: some View {
        if let imageURL = article.imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.Teal.teal300, Color.Teal.teal600],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 340)
            .clipped()
        } else {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.Teal.teal300, Color.Teal.teal600],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: 340)
                .overlay {
                    Image(systemName: "newspaper")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.3))
                }
        }
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
}

#Preview {
    ArticleDetailView(article: .preview)
        .environmentObject(AppRouter())
}

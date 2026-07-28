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
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
        .padding(.top, 50)
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            heroImage
                .frame(height: 320)

            LinearGradient(
                colors: [.black.opacity(0.5), .black.opacity(0.1), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 320)

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
            .padding(16)
        }
        .frame(height: 320)
    }

    // MARK: - Content

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sourceRow

            Divider()
                .background(NewsFeedPalette.divider)

            if let description = article.description, !description.isEmpty {
                Text(description)
                    .font(.system(size: 16))
                    .foregroundStyle(NewsFeedPalette.textPrimary)
                    .lineSpacing(6)
            }

            if let content = article.content, !content.isEmpty {
                Text(content)
                    .font(.system(size: 16))
                    .foregroundStyle(NewsFeedPalette.textPrimary)
                    .lineSpacing(6)
            }
        }
        .padding(16)
        .background(NewsFeedPalette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .offset(y: -20)
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
                    image.resizable().scaledToFill()
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
        } else {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.Teal.teal300, Color.Teal.teal600],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
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

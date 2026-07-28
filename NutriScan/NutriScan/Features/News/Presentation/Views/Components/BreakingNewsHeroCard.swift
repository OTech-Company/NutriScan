import SwiftUI

struct BreakingNewsHeroCard: View {
    let article: Article

    var body: some View {
        ZStack(alignment: .bottom) {
            heroImage
                .frame(height: 260)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.75), .black.opacity(0.3), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 260)

            // Content overlay sits inside the fixed ZStack bounds
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(categoryName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(NewsFeedPalette.accent)
                        .clipShape(Capsule())
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)

                Spacer()

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text(article.source.name)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(NewsFeedPalette.accent)
                        Text("•")
                            .foregroundStyle(.white.opacity(0.6))
                        Text(article.publishedAt.relativeShortString)
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.7))
                        Spacer()
                    }

                    Text(article.title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(16)
            }
            .frame(height: 260, alignment: .top)
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var categoryName: String {
        let title = article.title.lowercased()
        if title.contains("sport") || title.contains("football") || title.contains("tennis") || title.contains("race") {
            return "Sports"
        } else if title.contains("health") || title.contains("diet") || title.contains("nutrition") {
            return "Health"
        } else if title.contains("education") || title.contains("school") || title.contains("university") {
            return "Education"
        }
        return "News"
    }

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
            .frame(height: 260)
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
                .frame(height: 260)
                .overlay {
                    Image(systemName: "newspaper")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.3))
                }
        }
    }
}

struct BreakingNewsHeroSkeleton: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [Color.Teal.teal200, Color.Teal.teal400],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 0) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.3))
                    .frame(width: 70, height: 24)
                    .padding(.top, 16)
                    .padding(.leading, 16)

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.3))
                        .frame(width: 180, height: 12)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.5))
                        .frame(height: 16)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.5))
                        .frame(width: 220, height: 16)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.4))
                        .frame(width: 160, height: 16)
                }
                .padding(16)
            }
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shimmering()
    }
}

#Preview {
    VStack(spacing: 16) {
        BreakingNewsHeroCard(article: .preview)
        BreakingNewsHeroSkeleton()
    }
    .padding()
    .background(NewsFeedPalette.background)
}

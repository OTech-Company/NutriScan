import SwiftUI

struct BreakingNewsHeroCard: View {
    let article: Article
    var body: some View {
        Button {
            // handled externally
        } label: {
            ZStack(alignment: .bottomLeading) {
                heroImage

                LinearGradient(
                    colors: [.black.opacity(0.75), .black.opacity(0.25), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(article.source.name.uppercased())
                        .font(NewsFeedTypography.eyebrow)
                        .foregroundStyle(.white.opacity(0.85))

                    Text(article.title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text(article.publishedAt.relativeShortString)
                    }
                    .font(NewsFeedTypography.caption)
                    .foregroundStyle(.white.opacity(0.7))
                }
                .padding(16)
            }
            .frame(height: 240)
            .clipShape(RoundedRectangle(cornerRadius: NewsFeedMetrics.cardCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }

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
                                colors: [Color.Teal.teal300, Color.Teal.teal700],
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
        } else {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.Teal.teal300, Color.Teal.teal700],
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
}

struct BreakingNewsHeroSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .fill(.white.opacity(0.3))
                .frame(width: 80, height: 10)
            RoundedRectangle(cornerRadius: 4)
                .fill(.white.opacity(0.5))
                .frame(height: 16)
            RoundedRectangle(cornerRadius: 4)
                .fill(.white.opacity(0.5))
                .frame(width: 200, height: 16)
            RoundedRectangle(cornerRadius: 4)
                .fill(.white.opacity(0.3))
                .frame(width: 100, height: 10)
        }
        .padding(16)
        .frame(height: 240)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.Teal.teal200, Color.Teal.teal500],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: NewsFeedMetrics.cardCornerRadius, style: .continuous))
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

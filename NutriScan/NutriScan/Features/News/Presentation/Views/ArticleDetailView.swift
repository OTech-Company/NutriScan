import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) private var dismiss
    @State private var isBookmarked = false
    @State private var showShareSheet = false

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
        .sheet(isPresented: $showShareSheet) {
            if let url = article.articleURL {
                ShareSheet(activityItems: [article.title, url])
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.3))
                    .clipShape(Circle())
            }

            Spacer()

            HStack(spacing: 12) {
                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
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
                .frame(width: UIScreen.main.bounds.width, height: 320)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.6), .black.opacity(0.2), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(width: UIScreen.main.bounds.width, height: 320)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(categoryName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(NewsFeedPalette.accent)
                        .clipShape(Capsule())

                    if let author = article.author, !author.isEmpty {
                        Text("•")
                            .foregroundStyle(.white.opacity(0.6))
                        Text(author)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                            .lineLimit(1)
                    }
                }

                Text(article.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 6) {
                    Text(article.source.name)
                        .foregroundStyle(.white.opacity(0.9))
                        .fontWeight(.medium)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(NewsFeedPalette.accent)
                    Text("•")
                        .foregroundStyle(.white.opacity(0.6))
                    Text(article.publishedAt.relativeShortString)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .font(.system(size: 13))
            }
            .padding(16)
        }
        .frame(height: 320)
    }

    // MARK: - Content Section

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Source & Meta Details Row
            sourceRow

            Divider()
                .background(NewsFeedPalette.divider)

            // Description / Lead paragraph
            if let description = article.description, !description.isEmpty {
                Text(description)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(NewsFeedPalette.textPrimary)
                    .lineSpacing(6)
            }

            // Main Content Body
            if let content = article.content, !content.isEmpty {
                Text(cleanedContent(content))
                    .font(.system(size: 16))
                    .foregroundStyle(NewsFeedPalette.textSecondary)
                    .lineSpacing(7)
            }

            // External Link Button to view full article on web if available
            if let url = article.articleURL {
                Link(destination: url) {
                    HStack {
                        Spacer()
                        Image(systemName: "safari")
                        Text("Read Full Article on Web")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(NewsFeedPalette.accentSoft)
                    .foregroundStyle(NewsFeedPalette.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.top, 10)
            }
        }
        .padding(20)
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
                
                if let author = article.author, !author.isEmpty {
                    Text("By \(author)")
                        .font(.system(size: 13))
                        .foregroundStyle(NewsFeedPalette.textTertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(article.publishedAt.relativeShortString)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(NewsFeedPalette.textTertiary)
            }
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
                        .frame(width: UIScreen.main.bounds.width, height: 320)
                        .clipped()
                default:
                    placeholderGradient
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 320)
            .clipped()
        } else {
            placeholderGradient
                .overlay {
                    Image(systemName: "newspaper")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.3))
                }
        }
    }

    private var placeholderGradient: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.Teal.teal300, Color.Teal.teal600],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: UIScreen.main.bounds.width, height: 320)
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

    /// NewsAPI frequently appends truncation indicators like ` [+1234 chars]` at the end of the content field. This helper strips that cleanly.
    private func cleanedContent(_ text: String) -> String {
        if let range = text.range(of: " \\[\\+\\d+ chars\\]", options: .regularExpression) {
            return String(text[..<range.lowerBound])
        }
        return text
    }
}

private struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ArticleDetailView(article: .preview)
        .environmentObject(AppRouter())
}

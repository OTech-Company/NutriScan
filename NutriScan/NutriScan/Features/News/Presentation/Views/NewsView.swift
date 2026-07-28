import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel: NewsViewModel
    @EnvironmentObject var router: AppRouter

    init(viewModel: NewsViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            let networkService: NetworkServiceProtocol = NetworkService()
            let remoteDataSource: NewsRemoteDataSourceProtocol = NewsRemoteDataSource(networkService: networkService)
            let repository: NewsRepositoryProtocol = NewsRepository(remoteDataSource: remoteDataSource)

            let defaultViewModel = NewsViewModel(
                fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCase(repository: repository),
                searchArticlesUseCase: SearchArticlesUseCase(repository: repository)
            )
            _viewModel = StateObject(wrappedValue: defaultViewModel)
        }
    }

    var body: some View {
        ZStack {
            NewsFeedPalette.background.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    searchBarButton
                    breakingNewsSection
                    recommendationSection
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .sheet(item: $viewModel.selectedArticleForReading) { article in
            if let url = article.articleURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
        .tint(NewsFeedPalette.accent)
    }

    // MARK: - Search Bar (navigates to Discover)

    private var searchBarButton: some View {
        Button {
            router.push(HomeRoute.discover)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(NewsFeedPalette.textTertiary)
                Text("Search health & nutrition news")
                    .font(NewsFeedTypography.cardBody)
                    .foregroundStyle(NewsFeedPalette.textTertiary)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(NewsFeedPalette.surface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(NewsFeedPalette.divider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, NewsFeedMetrics.screenPadding)
    }

    // MARK: - Breaking News

    private var breakingNewsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Breaking News", showSeeAll: true)

            if viewModel.viewState == .loading || viewModel.viewState == .idle {
                BreakingNewsHeroSkeleton()
                    .padding(.horizontal, NewsFeedMetrics.screenPadding)
            } else if let firstArticle = viewModel.articles.first {
                Button {
                    viewModel.onArticleTapped(firstArticle)
                } label: {
                    BreakingNewsHeroCard(article: firstArticle)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, NewsFeedMetrics.screenPadding)
            }
        }
    }

    // MARK: - Recommendation (Personalized)

    @ViewBuilder
    private var recommendationSection: some View {
        if viewModel.isLoadingPersonalized {
            recommendationSkeleton
        } else if !viewModel.personalizedArticles.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                sectionHeader(title: "Recommendation", showSeeAll: false)

                VStack(spacing: 10) {
                    ForEach(viewModel.personalizedArticles.prefix(5)) { article in
                        Button {
                            viewModel.onArticleTapped(article)
                        } label: {
                            CompactArticleRow(article: article)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, NewsFeedMetrics.screenPadding)
            }
        }
    }

    private var recommendationSkeleton: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Recommendation", showSeeAll: false)

            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { _ in
                    CompactArticleRowSkeleton()
                }
            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)
        }
    }

    // MARK: - Helpers

    private func sectionHeader(title: String, showSeeAll: Bool) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(NewsFeedPalette.textPrimary)
            Spacer()
            if showSeeAll {
                Button {} label: {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(NewsFeedTypography.chip)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundStyle(NewsFeedPalette.accent)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, NewsFeedMetrics.screenPadding)
    }
}

#Preview {
    NewsView()
}

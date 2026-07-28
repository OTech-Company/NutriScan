import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel: NewsViewModel

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
                    breakingNewsSection
                    recommendationSection
                    discoverSection
                }
                .padding(.vertical, 16)
            }
            .refreshable {
                await viewModel.onPullToRefresh()
            }
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.large)
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

    // MARK: - Breaking News

    private var breakingNewsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Breaking News", showSeeAll: true)

            if viewModel.viewState == .loading || viewModel.viewState == .idle {
                BreakingNewsHeroSkeleton()
                    .padding(.horizontal, NewsFeedMetrics.screenPadding)
            } else if let firstArticle = viewModel.articles.first {
                BreakingNewsHeroCard(article: firstArticle)
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

    // MARK: - Discover (Search + Chips + Feed)

    private var discoverSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Discover", showSeeAll: false)

            SearchBarView(text: $viewModel.searchText)
                .padding(.horizontal, NewsFeedMetrics.screenPadding)
                .onChange(of: viewModel.searchText) { _, newValue in
                    viewModel.onSearchTextChanged(newValue)
                }

            if !viewModel.isSearching {
                categoryChipsRow
            }

            feedContent
                .padding(.horizontal, NewsFeedMetrics.screenPadding)
        }
    }

    // MARK: - Feed Content

    @ViewBuilder
    private var feedContent: some View {
        switch viewModel.viewState {
        case .idle, .loading:
            VStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { _ in
                    CompactArticleRowSkeleton()
                }
            }

        case .loaded:
            VStack(spacing: 10) {
                ForEach(viewModel.articles) { article in
                    Button {
                        viewModel.onArticleTapped(article)
                    } label: {
                        CompactArticleRow(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }

        case .empty:
            FeedEmptyStateView()
                .padding(.top, 40)

        case .error(let message):
            FeedErrorStateView(message: message) {
                Task { await viewModel.onPullToRefresh() }
            }
            .padding(.top, 40)
        }
    }

    // MARK: - Category Chips

    private var categoryChipsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(NewsFeedCategory.allCases) { category in
                    CategoryChipView(
                        title: category.displayName,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                    }
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

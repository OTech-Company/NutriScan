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
                    breakingNewsSection
                        .padding(.bottom, 8)

                    recommendationSection
                }
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            topBar
                .padding(.vertical, 12)
                .background(NewsFeedPalette.background)
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.onAppear()
        }
        .sheet(item: $viewModel.selectedArticleForReading) { article in
            ArticleDetailView(article: article)
                .environmentObject(router)
        }
        .tint(NewsFeedPalette.accent)
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {} label: {
                Image(systemName: "back.arrow")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(NewsFeedPalette.textPrimary)
            }

            Spacer()

            HStack(spacing: 16) {
                Button {
                    router.push(HomeRoute.discover)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                }

            }
        }
        .padding(.horizontal, NewsFeedMetrics.screenPadding)
    }

    // MARK: - Breaking News

    private var breakingNewsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Breaking News")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(NewsFeedPalette.textPrimary)
                Spacer()

            }
            .padding(.horizontal, NewsFeedMetrics.screenPadding)

            Group {
                if viewModel.viewState == .loading || viewModel.viewState == .idle {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            BreakingNewsHeroSkeleton()
                                .frame(width: UIScreen.main.bounds.width - 64)
                            BreakingNewsHeroSkeleton()
                                .frame(width: UIScreen.main.bounds.width - 64)
                                .opacity(0.5)
                        }
                        .padding(.horizontal, NewsFeedMetrics.screenPadding)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(viewModel.articles.prefix(5)) { article in
                                Button {
                                    viewModel.onArticleTapped(article)
                                } label: {
                                    BreakingNewsHeroCard(article: article)
                                        .frame(width: UIScreen.main.bounds.width - 64)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, NewsFeedMetrics.screenPadding)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.viewState)

            if viewModel.viewState != .loading && viewModel.viewState != .idle {
                HStack(spacing: 6) {
                    ForEach(0..<min(viewModel.articles.count, 5), id: \.self) { index in
                        Capsule()
                            .fill(index == 0 ? NewsFeedPalette.accent : NewsFeedPalette.divider)
                            .frame(width: index == 0 ? 20 : 6, height: 6)
                    }
                }
                .frame(maxWidth: .infinity)
                .animation(.easeInOut, value: viewModel.articles.count)
            }
        }
    }

    // MARK: - Recommendation (Personalized)

    @ViewBuilder
    private var recommendationSection: some View {
        if viewModel.isLoadingPersonalized {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Recommendation")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                    Spacer()

                }
                .padding(.horizontal, NewsFeedMetrics.screenPadding)

                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        CompactArticleRowSkeleton()
                    }
                }
                .padding(.horizontal, NewsFeedMetrics.screenPadding)
            }
        } else if !viewModel.personalizedArticles.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Recommendation")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(NewsFeedPalette.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, NewsFeedMetrics.screenPadding)

                VStack(spacing: 12) {
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
}

#Preview {
    NewsView()
}

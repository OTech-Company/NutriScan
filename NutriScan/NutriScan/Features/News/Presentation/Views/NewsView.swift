import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel: NewsViewModel
    @EnvironmentObject var router: AppRouter
    @State private var currentHeroIndex = 0
    @State private var heroScrollPosition: String?

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
                    topBar
                    breakingNewsSection
                    recommendationSection
                }
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
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
            BackButton {
                router.pop()
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
                    HStack(spacing: 16) {
                        ForEach(viewModel.articles.prefix(5)) { article in
                            Button {
                                viewModel.onArticleTapped(article)
                            } label: {
                                BreakingNewsHeroCard(article: article)
                                    .frame(width: UIScreen.main.bounds.width - 60)
                            }
                            .buttonStyle(.plain)
                            .id(article.id)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, NewsFeedMetrics.screenPadding)
                .frame(height: 260)
                .scrollPosition(id: $heroScrollPosition)

                HStack(spacing: 6) {
                    ForEach(Array(viewModel.articles.prefix(5).enumerated()), id: \.offset) { index, article in
                        Capsule()
                            .fill(index == currentHeroIndex ? NewsFeedPalette.accent : NewsFeedPalette.divider)
                            .frame(width: index == currentHeroIndex ? 20 : 6, height: 6)
                            .animation(.easeInOut(duration: 0.2), value: currentHeroIndex)
                    }
                }
                .frame(maxWidth: .infinity)
                .onChange(of: heroScrollPosition) { _, newValue in
                    if let id = newValue, let index = viewModel.articles.prefix(5).firstIndex(where: { $0.id == id }) {
                        currentHeroIndex = index
                    }
                }
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
